import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

/// ReviewStatus enum for tracking book verification state
enum ReviewStatus {
  verified,      // AI or user confirmed accurate
  needsReview,   // Low confidence (< 60%)
  userEdited,    // Human corrected AI result
}

/// ReadingStatus enum for tracking user's reading progress
enum ReadingStatus {
  wishlist,   // Want to read
  toRead,     // Owned but not started
  reading,    // Currently reading
  read,       // Finished reading
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

/// UserLibraryEntries table - Tracks user's reading status and progress
class UserLibraryEntries extends Table {
  // Primary Key
  TextColumn get id => text()();

  // Foreign Keys
  TextColumn get workId => text().references(Works, #id, onDelete: KeyAction.cascade)();
  TextColumn get editionId => text().references(Editions, #id, onDelete: KeyAction.setNull).nullable()();

  // Reading Status & Progress
  IntColumn get status => intEnum<ReadingStatus>().withDefault(const Constant(0))(); // wishlist
  IntColumn get currentPage => integer().nullable()();
  DateTimeColumn get completionDate => dateTime().nullable()();
  IntColumn get personalRating => integer().nullable()(); // 1-5 stars
  TextColumn get notes => text().nullable()();

  // Timestamps
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {workId},  // One library entry per work per user
  ];

  // Index for efficient keyset pagination queries
  @override
  List<Index> get indexes => [
    Index('idx_library_updated_id', [updatedAt, id]),
    Index('idx_library_status_updated', [status, updatedAt]),
  ];
}

/// Main database class
@DriftDatabase(tables: [Works, Editions, Authors, WorkAuthors, UserLibraryEntries])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;  // Added indexes for keyset pagination

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'books_tracker_db');
  }

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          // Add UserLibraryEntries table in version 2
          await m.createTable(userLibraryEntries);
        }
      },
    );
  }

  // ==================== QUERIES ====================

  /// Get all works with their authors
  Stream<List<WorkWithAuthors>> watchAllWorks() {
    return (select(works)
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
      .watch()
      .asyncMap((worksList) async {
        if (worksList.isEmpty) return [];

        // Batch fetch all authors for all works (eliminates N+1 query problem)
        final workIds = worksList.map((work) => work.id).toList();
        final authorsMap = await _getBatchAuthorsForWorks(workIds);

        final List<WorkWithAuthors> result = [];
        for (final work in worksList) {
          final workAuthors = authorsMap[work.id] ?? [];
          result.add(WorkWithAuthors(work: work, authors: workAuthors));
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

  /// Batch fetch authors for multiple works (eliminates N+1 query problem)
  Future<Map<String, List<Author>>> _getBatchAuthorsForWorks(List<String> workIds) async {
    if (workIds.isEmpty) return {};

    // Single query to fetch all work-author relationships for the given work IDs
    final query = select(authors).join([
      innerJoin(
        workAuthors,
        workAuthors.authorId.equalsExp(authors.id),
      ),
    ])..where(workAuthors.workId.isIn(workIds))
      ..orderBy([OrderingTerm.asc(workAuthors.authorOrder)]);

    final results = await query.get();

    // Group authors by work ID
    final Map<String, List<Author>> authorsMap = {};
    for (final row in results) {
      final author = row.readTable(authors);
      final workAuthor = row.readTable(workAuthors);
      authorsMap.putIfAbsent(workAuthor.workId, () => []).add(author);
    }

    return authorsMap;
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

  // ==================== LIBRARY QUERIES ====================

  /// Watch all library entries with optional status filter and keyset pagination
  Stream<List<WorkWithLibraryStatus>> watchLibrary({
    ReadingStatus? filterStatus,
    String? cursor,  // Last entry ID for keyset pagination
    int limit = 50,
  }) {
    final query = select(userLibraryEntries).join([
      innerJoin(works, works.id.equalsExp(userLibraryEntries.workId)),
      leftOuterJoin(editions, editions.id.equalsExp(userLibraryEntries.editionId)),
    ]);

    if (filterStatus != null) {
      query.where(userLibraryEntries.status.equals(filterStatus.index));
    }

    // Keyset pagination: fetch entries with ID smaller than cursor
    if (cursor != null) {
      query.where(userLibraryEntries.id.isSmallerThan(cursor));
    }

    query
      ..orderBy([OrderingTerm.desc(userLibraryEntries.updatedAt)])
      ..limit(limit);

    return query.watch().asyncMap((rows) async {
      if (rows.isEmpty) return [];

      // Batch fetch all authors for all works (eliminates N+1 query problem)
      final workIds = rows.map((row) => row.readTable(works).id).toList();
      final authorsMap = await _getBatchAuthorsForWorks(workIds);

      final List<WorkWithLibraryStatus> result = [];
      for (final row in rows) {
        final work = row.readTable(works);
        final entry = row.readTable(userLibraryEntries);
        final edition = row.readTableOrNull(editions);
        final workAuthors = authorsMap[work.id] ?? [];

        result.add(WorkWithLibraryStatus(
          work: work,
          authors: workAuthors,
          edition: edition,
          libraryEntry: entry,
        ));
      }
      return result;
    });
  }

  /// Add or update a library entry
  Future<void> upsertLibraryEntry(UserLibraryEntriesCompanion entry) async {
    await into(userLibraryEntries).insertOnConflictUpdate(entry);
  }

  /// Update reading status
  Future<void> updateReadingStatus(String entryId, ReadingStatus newStatus) async {
    final update = UserLibraryEntriesCompanion(
      id: Value(entryId),
      status: Value(newStatus),
      updatedAt: Value(DateTime.now()),
      completionDate: newStatus == ReadingStatus.read
        ? Value(DateTime.now())
        : const Value(null),
    );
    await upsertLibraryEntry(update);
  }

  /// Update current page
  Future<void> updateCurrentPage(String entryId, int page) async {
    final update = UserLibraryEntriesCompanion(
      id: Value(entryId),
      currentPage: Value(page),
      updatedAt: Value(DateTime.now()),
    );
    await upsertLibraryEntry(update);
  }

  /// Update personal rating
  Future<void> updateRating(String entryId, int rating) async {
    final update = UserLibraryEntriesCompanion(
      id: Value(entryId),
      personalRating: Value(rating),
      updatedAt: Value(DateTime.now()),
    );
    await upsertLibraryEntry(update);
  }

  /// Delete library entry
  Future<void> deleteLibraryEntry(String entryId) async {
    await (delete(userLibraryEntries)..where((t) => t.id.equals(entryId))).go();
  }

  /// Get reading statistics
  Future<ReadingStatistics> getReadingStatistics() async {
    final allEntries = await select(userLibraryEntries).get();

    final now = DateTime.now();
    final yearStart = DateTime(now.year, 1, 1);

    final booksReadThisYear = allEntries.where((e) =>
      e.status == ReadingStatus.read &&
      e.completionDate != null &&
      e.completionDate!.isAfter(yearStart)
    ).length;

    final statusDistribution = <ReadingStatus, int>{};
    for (final status in ReadingStatus.values) {
      statusDistribution[status] = allEntries.where((e) => e.status == status).length;
    }

    final currentlyReading = statusDistribution[ReadingStatus.reading] ?? 0;

    return ReadingStatistics(
      booksReadThisYear: booksReadThisYear,
      totalBooks: allEntries.length,
      currentlyReading: currentlyReading,
      statusDistribution: statusDistribution,
    );
  }
}

/// Helper class to combine Work with its Authors
class WorkWithAuthors {
  final Work work;
  final List<Author> authors;

  WorkWithAuthors({required this.work, required this.authors});
}

/// Helper class to combine Work with Library Status
class WorkWithLibraryStatus {
  final Work work;
  final List<Author> authors;
  final Edition? edition;
  final UserLibraryEntry libraryEntry;

  WorkWithLibraryStatus({
    required this.work,
    required this.authors,
    required this.edition,
    required this.libraryEntry,
  });

  String get displayAuthor => authors.isNotEmpty
      ? authors.map((a) => a.name).join(', ')
      : work.author ?? 'Unknown Author';

  ReadingStatus get status => libraryEntry.status;

  double? get readingProgress {
    if (libraryEntry.currentPage == null || edition?.pageCount == null) {
      return null;
    }
    return libraryEntry.currentPage! / edition!.pageCount!;
  }
}

/// Reading statistics data class
class ReadingStatistics {
  final int booksReadThisYear;
  final int totalBooks;
  final int currentlyReading;
  final Map<ReadingStatus, int> statusDistribution;

  ReadingStatistics({
    required this.booksReadThisYear,
    required this.totalBooks,
    required this.currentlyReading,
    required this.statusDistribution,
  });
}
