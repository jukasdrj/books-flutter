import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:books_flutter/core/data/database/database.dart';
import '../../../core/providers/database_provider.dart';

part 'book_actions_provider.g.dart';

const _uuid = Uuid();

/// Provider for book-related actions (add, update status, delete, etc.)
@riverpod
class BookActions extends _$BookActions {
  @override
  FutureOr<void> build() {}

  /// Add a book to the library
  Future<String> addToLibrary({
    required String workId,
    String? editionId,
    ReadingStatus status = ReadingStatus.wishlist,
  }) async {
    final database = ref.read(databaseProvider);
    final entryId = _uuid.v4();

    final entry = UserLibraryEntriesCompanion.insert(
      id: entryId,
      workId: workId,
      editionId: Value(editionId),
      status: Value(status),
    );

    await database.upsertLibraryEntry(entry);
    return entryId;
  }

  /// Update reading status
  Future<void> updateReadingStatus(
    String entryId,
    ReadingStatus newStatus,
  ) async {
    final database = ref.read(databaseProvider);
    await database.updateReadingStatus(entryId, newStatus);
  }

  /// Update current page
  Future<void> updateCurrentPage(String entryId, int page) async {
    final database = ref.read(databaseProvider);
    await database.updateCurrentPage(entryId, page);
  }

  /// Update personal rating (1-5 stars)
  Future<void> updateRating(String entryId, int rating) async {
    if (rating < 1 || rating > 5) {
      throw ArgumentError('Rating must be between 1 and 5');
    }
    final database = ref.read(databaseProvider);
    await database.updateRating(entryId, rating);
  }

  /// Update notes
  Future<void> updateNotes(String entryId, String notes) async {
    final database = ref.read(databaseProvider);
    final update = UserLibraryEntriesCompanion(
      id: Value(entryId),
      notes: Value(notes),
      updatedAt: Value(DateTime.now()),
    );
    await database.upsertLibraryEntry(update);
  }

  /// Delete from library
  Future<void> deleteFromLibrary(String entryId) async {
    final database = ref.read(databaseProvider);
    await database.deleteLibraryEntry(entryId);
  }
}
