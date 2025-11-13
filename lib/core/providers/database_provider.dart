import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../database/database.dart';

part 'database_provider.g.dart';

/// Provider for the app database instance
@riverpod
AppDatabase database(DatabaseRef ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
}

/// Provider that watches all works with their authors
@riverpod
Stream<List<WorkWithAuthors>> watchWorks(WatchWorksRef ref) {
  final db = ref.watch(databaseProvider);
  return db.watchAllWorks();
}

/// Provider that watches the review queue (works needing review)
@riverpod
Stream<List<Work>> watchReviewQueue(WatchReviewQueueRef ref) {
  final db = ref.watch(databaseProvider);
  return db.watchReviewQueue();
}

/// Provider for searching works
@riverpod
Future<List<WorkWithAuthors>> searchWorks(
  SearchWorksRef ref,
  String query,
) async {
  final db = ref.watch(databaseProvider);
  return await db.searchWorks(query);
}
