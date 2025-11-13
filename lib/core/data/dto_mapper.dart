import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../database/database.dart';
import '../models/dtos/work_dto.dart';

/// DTOMapper - Converts API DTOs to Drift database models
/// Handles deduplication, synthetic works, and relationship creation
class DTOMapper {
  static const _uuid = Uuid();

  /// Map SearchResponseData to Drift models and insert into database
  static Future<List<Work>> mapAndInsertSearchResponse(
    SearchResponseData data,
    AppDatabase database,
  ) async {
    final List<Work> insertedWorks = [];

    // Group editions by ISBN for deduplication
    final editionsByISBN = <String, List<EditionDTO>>{};
    for (final edition in data.editions) {
      if (edition.isbn != null && edition.isbn!.isNotEmpty) {
        editionsByISBN.putIfAbsent(edition.isbn!, () => []).add(edition);
      }
    }

    // Validate work/edition count match
    if (data.works.length != data.editions.length) {
      print('⚠️ Warning: Works count (${data.works.length}) != Editions count (${data.editions.length}). Using index-based mapping may cause mismatches.');
    }

    // Process each work
    for (var i = 0; i < data.works.length; i++) {
      final workDTO = data.works[i];
      final editionDTO = i < data.editions.length ? data.editions[i] : null;

      // Map authors using authorIds from WorkDTO (backend provides correct relationships)
      final authorDTOs = data.authors
          .where((a) => workDTO.authorIds.contains(a.id))
          .toList();

      // Warn if no authors found for this work
      if (authorDTOs.isEmpty && workDTO.authorIds.isNotEmpty) {
        print('⚠️ Warning: Work "${workDTO.title}" has ${workDTO.authorIds.length} author IDs but no matching authors in response');
      }

      // Check for duplicates (synthetic works with same ISBN)
      if (workDTO.synthetic && editionDTO?.isbn != null) {
        final existing = await _findWorkByISBN(editionDTO!.isbn!, database);
        if (existing != null) {
          // Work already exists, skip
          continue;
        }
      }

      // Map DTOs to database models
      final workCompanion = _mapWorkDTOToCompanion(workDTO, editionDTO, authorDTOs);
      final authorCompanions = authorDTOs.map(_mapAuthorDTOToCompanion).toList();

      // Insert into database
      await database.insertWorkWithAuthors(workCompanion, authorCompanions);

      // If there's an edition, insert it
      if (editionDTO != null) {
        final editionCompanion = _mapEditionDTOToCompanion(
          editionDTO,
          workCompanion.id.value,
        );
        await database.into(database.editions).insert(editionCompanion);
      }

      // Fetch the inserted work
      final insertedWork = await (database.select(database.works)
        ..where((t) => t.id.equals(workCompanion.id.value)))
        .getSingle();
      insertedWorks.add(insertedWork);
    }

    return insertedWorks;
  }

  /// Map WorkDTO to WorksCompanion
  static WorksCompanion _mapWorkDTOToCompanion(
    WorkDTO dto,
    EditionDTO? edition,
    List<AuthorDTO> authors,
  ) {
    // Join author names with comma separator
    final authorNames = authors.map((a) => a.name).join(', ');

    return WorksCompanion.insert(
      id: dto.id,  // Use API-provided ID instead of generating UUID
      title: dto.title,
      author: Value(authorNames.isNotEmpty ? authorNames : null),
      subjectTags: Value(dto.subjectTags),
      synthetic: Value(dto.synthetic),
      primaryProvider: Value(dto.primaryProvider),
      contributors: Value(dto.contributors),
      googleBooksVolumeIDs: Value(dto.googleBooksVolumeIDs),
      openLibraryWorkID: Value(dto.openLibraryWorkID),
      reviewStatus: Value(ReviewStatus.verified),
      createdAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    );
  }

  /// Map EditionDTO to EditionsCompanion
  static EditionsCompanion _mapEditionDTOToCompanion(
    EditionDTO dto,
    String workId,
  ) {
    return EditionsCompanion.insert(
      id: _uuid.v4(),
      workId: workId,
      isbn: Value(dto.isbn),
      isbns: Value(dto.isbns),
      title: Value(dto.title),
      publisher: Value(dto.publisher),
      publishedYear: Value(dto.publishedYear),
      coverImageURL: Value(dto.coverImageURL),
      format: Value(_parseEditionFormat(dto.format)),
      pageCount: Value(dto.pageCount),
      primaryProvider: Value(dto.primaryProvider),
      googleBooksVolumeID: Value(dto.googleBooksVolumeID),
      openLibraryEditionID: Value(dto.openLibraryEditionID),
      createdAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    );
  }

  /// Map AuthorDTO to AuthorsCompanion
  static AuthorsCompanion _mapAuthorDTOToCompanion(AuthorDTO dto) {
    return AuthorsCompanion.insert(
      id: dto.id,  // Use backend-provided ID (not UUID)
      name: dto.name,
      gender: Value(_parseGender(dto.gender)),
      culturalRegion: Value(_parseCulturalRegion(dto.culturalRegion)),
      openLibraryAuthorID: Value(dto.openLibraryAuthorID),
      googleBooksAuthorID: Value(dto.googleBooksAuthorID),
      createdAt: Value(DateTime.now()),
    );
  }

  /// Find work by ISBN (for deduplication)
  static Future<Work?> _findWorkByISBN(String isbn, AppDatabase database) async {
    // Find edition with this ISBN
    final edition = await (database.select(database.editions)
      ..where((t) => t.isbn.equals(isbn)))
      .getSingleOrNull();

    if (edition == null) return null;

    // Get the work for this edition
    return await (database.select(database.works)
      ..where((t) => t.id.equals(edition.workId)))
      .getSingleOrNull();
  }

  /// Parse edition format string to enum
  static EditionFormat _parseEditionFormat(String format) {
    switch (format.toLowerCase()) {
      case 'hardcover':
        return EditionFormat.hardcover;
      case 'paperback':
        return EditionFormat.paperback;
      case 'ebook':
      case 'e-book':
        return EditionFormat.ebook;
      case 'audiobook':
        return EditionFormat.audiobook;
      default:
        return EditionFormat.unknown;
    }
  }

  /// Parse gender string to enum
  static AuthorGender _parseGender(String gender) {
    switch (gender.toLowerCase()) {
      case 'male':
        return AuthorGender.male;
      case 'female':
        return AuthorGender.female;
      case 'nonbinary':
      case 'non-binary':
        return AuthorGender.nonBinary;
      default:
        return AuthorGender.unknown;
    }
  }

  /// Parse cultural region string to enum
  static CulturalRegion? _parseCulturalRegion(String? region) {
    if (region == null) return null;

    switch (region.toLowerCase().replaceAll(' ', '')) {
      case 'northamerica':
        return CulturalRegion.northAmerica;
      case 'latinamerica':
        return CulturalRegion.latinAmerica;
      case 'europe':
        return CulturalRegion.europe;
      case 'africa':
        return CulturalRegion.africa;
      case 'middleeast':
        return CulturalRegion.middleEast;
      case 'southasia':
        return CulturalRegion.southAsia;
      case 'eastasia':
        return CulturalRegion.eastAsia;
      case 'southeastasia':
        return CulturalRegion.southeastAsia;
      case 'oceania':
        return CulturalRegion.oceania;
      default:
        return CulturalRegion.unknown;
    }
  }
}
