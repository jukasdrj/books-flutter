import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:books_flutter/core/data/database/database.dart';
import '../../../core/providers/database_provider.dart';

part 'library_providers.g.dart';

/// Sort options for library
enum SortBy {
  recentlyAdded,
  title,
  author,
  recentlyRead,
  rating,
}

/// Filter by reading status
@riverpod
class LibraryFilter extends _$LibraryFilter {
  @override
  ReadingStatus? build() => null; // Show all by default

  void setFilter(ReadingStatus? status) {
    state = status;
  }

  void clearFilter() {
    state = null;
  }
}

/// Sort option for library
@riverpod
class LibrarySortOption extends _$LibrarySortOption {
  @override
  SortBy build() => SortBy.recentlyAdded;

  void setSort(SortBy sortBy) {
    state = sortBy;
  }
}

/// Watch library works with filtering and sorting
@riverpod
Stream<List<WorkWithLibraryStatus>> watchLibraryWorks(WatchLibraryWorksRef ref) {
  final database = ref.watch(databaseProvider);
  final filter = ref.watch(libraryFilterProvider);
  final sortBy = ref.watch(librarySortOptionProvider);

  return database
      .watchLibrary(filterStatus: filter)
      .map((works) => _sortWorks(works, sortBy));
}

/// Helper function to sort works
List<WorkWithLibraryStatus> _sortWorks(
  List<WorkWithLibraryStatus> works,
  SortBy sortBy,
) {
  final sorted = List<WorkWithLibraryStatus>.from(works);

  switch (sortBy) {
    case SortBy.recentlyAdded:
      sorted.sort((a, b) =>
          b.libraryEntry.createdAt.compareTo(a.libraryEntry.createdAt));
      break;
    case SortBy.title:
      sorted.sort((a, b) => a.work.title.compareTo(b.work.title));
      break;
    case SortBy.author:
      sorted.sort((a, b) => a.displayAuthor.compareTo(b.displayAuthor));
      break;
    case SortBy.recentlyRead:
      sorted.sort((a, b) {
        final aDate = a.libraryEntry.completionDate;
        final bDate = b.libraryEntry.completionDate;
        if (aDate == null && bDate == null) return 0;
        if (aDate == null) return 1;
        if (bDate == null) return -1;
        return bDate.compareTo(aDate);
      });
      break;
    case SortBy.rating:
      sorted.sort((a, b) {
        final aRating = a.libraryEntry.personalRating ?? 0;
        final bRating = b.libraryEntry.personalRating ?? 0;
        return bRating.compareTo(aRating);
      });
      break;
  }

  return sorted;
}

/// Get reading statistics
@riverpod
Future<ReadingStatistics> readingStatistics(ReadingStatisticsRef ref) async {
  final database = ref.watch(databaseProvider);
  return database.getReadingStatistics();
}
