import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

/// ReviewStatus enum for tracking book verification state
enum ReviewStatus {
  verified,      // AI or user confirmed accurate
  needsReview,   // Low confidence (< 60%)
  userEdited,    // Human corrected AI result
}

/// EditionFormat enum
enum EditionFormat {
  hardcover,
  paperback,
  ebook,
  audiobook,
  unknown,
}

/// AuthorGender enum
enum AuthorGender {
  male,
  female,
  nonBinary,
  unknown,
}

/// CulturalRegion enum (for diversity insights)
enum CulturalRegion {
  northAmerica,
  latinAmerica,
  europe,
  africa,
  middleEast,
  southAsia,
  eastAsia,
  southeastAsia,
  oceania,
  unknown,
}

/// Converter for string lists (genres, ISBNs, etc.)
class StringListConverter extends TypeConverter<List<String>, String> {
  const StringListConverter();

  @override
  List<String> fromSql(String fromDb) {
    if (fromDb.isEmpty) return [];
    return fromDb.split(',').where((e) => e.isNotEmpty).toList();
  }

  @override
  String toSql(List<String> value) {
    return value.join(',');
  }
}

/// Works table - Abstract creative work (book, play, etc.)
class Works extends Table {
  // Primary Key
  TextColumn get id => text()();

  // Core Fields
  TextColumn get title => text()();
  TextColumn get author => text().nullable()();
  TextColumn get subjectTags => text().map(const StringListConverter()).withDefault(const Constant(''))();

  // Review Queue Properties
  IntColumn get reviewStatus => intEnum<ReviewStatus>().withDefault(const Constant(0))();
  TextColumn get originalImagePath => text().nullable()();  // Temp file path for correction UI
  TextColumn get boundingBox => text().nullable()();        // JSON-encoded crop coordinates
  RealColumn get aiConfidence => real().nullable()();       // AI detection confidence (0.0-1.0)

  // Provenance Tracking
  BoolColumn get synthetic => boolean().withDefault(const Constant(false))();
  TextColumn get primaryProvider => text().nullable()();
  TextColumn get contributors => text().map(const StringListConverter()).nullable()();

  // External IDs
  TextColumn get googleBooksVolumeIDs => text().map(const StringListConverter()).nullable()();
  TextColumn get openLibraryWorkID => text().nullable()();

  // Timestamps
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Editions table - Physical/digital manifestation of a Work
class Editions extends Table {
  // Primary Key
  TextColumn get id => text()();

  // Foreign Key to Work
  TextColumn get workId => text().references(Works, #id, onDelete: KeyAction.cascade)();

  // Core Fields
  TextColumn get isbn => text().nullable()();
  TextColumn get isbns => text().map(const StringListConverter()).withDefault(const Constant(''))();
  TextColumn get title => text().nullable()();
  TextColumn get publisher => text().nullable()();
  IntColumn get publishedYear => integer().nullable()();
  TextColumn get coverImageURL => text().nullable()();
  IntColumn get format => intEnum<EditionFormat>().withDefault(const Constant(4))(); // unknown
  IntColumn get pageCount => integer().nullable()();

  // Provenance
  TextColumn get primaryProvider => text().nullable()();

  // External IDs
  TextColumn get googleBooksVolumeID => text().nullable()();
  TextColumn get openLibraryEditionID => text().nullable()();

  // Timestamps
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Authors table - Creator of Works
class Authors extends Table {
  // Primary Key
  TextColumn get id => text()();

  // Core Fields
  TextColumn get name => text()();
  IntColumn get gender => intEnum<AuthorGender>().withDefault(const Constant(3))(); // unknown
  IntColumn get culturalRegion => intEnum<CulturalRegion>().nullable()();

  // External IDs
  TextColumn get openLibraryAuthorID => text().nullable()();
  TextColumn get googleBooksAuthorID => text().nullable()();

  // Timestamps
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// WorkAuthors junction table (many-to-many relationship)
class WorkAuthors extends Table {
  TextColumn get workId => text().references(Works, #id, onDelete: KeyAction.cascade)();
  TextColumn get authorId => text().references(Authors, #id, onDelete: KeyAction.cascade)();
  IntColumn get authorOrder => integer().withDefault(const Constant(0))(); // For multi-author books

  @override
  Set<Column> get primaryKey => {workId, authorId};
}

/// Main database class
@DriftDatabase(tables: [Works, Editions, Authors, WorkAuthors])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'books_tracker_db');
  }

  // ==================== QUERIES ====================

  /// Get all works with their authors
  Stream<List<WorkWithAuthors>> watchAllWorks() {
    return (select(works)
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
      .watch()
      .asyncMap((worksList) async {
        final List<WorkWithAuthors> result = [];
        for (final work in worksList) {
          final authors = await _getAuthorsForWork(work.id);
          result.add(WorkWithAuthors(work: work, authors: authors));
        }
        return result;
      });
  }

  /// Get works that need review (low AI confidence)
  Stream<List<Work>> watchReviewQueue() {
    return (select(works)
      ..where((t) => t.reviewStatus.equals(ReviewStatus.needsReview.index))
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
      .watch();
  }

  /// Get authors for a specific work
  Future<List<Author>> _getAuthorsForWork(String workId) async {
    final query = select(authors).join([
      innerJoin(
        workAuthors,
        workAuthors.authorId.equalsExp(authors.id),
      ),
    ])..where(workAuthors.workId.equals(workId))
      ..orderBy([OrderingTerm.asc(workAuthors.authorOrder)]);

    final results = await query.get();
    return results.map((row) => row.readTable(authors)).toList();
  }

  /// Insert work with authors
  Future<void> insertWorkWithAuthors(
    WorksCompanion work,
    List<AuthorsCompanion> authorList,
  ) async {
    await transaction(() async {
      // Insert work
      final workId = work.id.value;
      await into(works).insert(work);

      // Insert authors and create relationships
      for (var i = 0; i < authorList.length; i++) {
        final author = authorList[i];
        final authorId = author.id.value;

        // Insert author (ignore if exists)
        await into(authors).insert(
          author,
          onConflict: DoNothing(),
        );

        // Create relationship
        await into(workAuthors).insert(
          WorkAuthorsCompanion.insert(
            workId: workId,
            authorId: authorId,
            authorOrder: Value(i),
          ),
        );
      }
    });
  }

  /// Search works by title or author
  Future<List<WorkWithAuthors>> searchWorks(String query) async {
    final lowercaseQuery = query.toLowerCase();

    final worksList = await (select(works)
      ..where((t) =>
        t.title.lower().like('%$lowercaseQuery%') |
        t.author.lower().like('%$lowercaseQuery%'),
      ))
      .get();

    final List<WorkWithAuthors> result = [];
    for (final work in worksList) {
      final authors = await _getAuthorsForWork(work.id);
      result.add(WorkWithAuthors(work: work, authors: authors));
    }
    return result;
  }
}

/// Helper class to combine Work with its Authors
class WorkWithAuthors {
  final Work work;
  final List<Author> authors;

  WorkWithAuthors({required this.work, required this.authors});
}
