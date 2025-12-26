# 02 - Search Feature Implementation

**Priority:** P0 - Core Feature
**Estimated Effort:** 1-2 days
**Prerequisites:** 01-CRITICAL-FIXES.md completed
**PRD Reference:** `product/Search-PRD-Flutter.md`

---

## Overview

The Search feature enables users to find books via:
1. **Title Search** - Fuzzy matching, partial titles
2. **Author Search** - Find all works by author
3. **ISBN Search** - Exact match (manual entry or barcode scan)
4. **Advanced Search** - Combined title + author filters

---

## Current State

| Component | Status | Notes |
|-----------|--------|-------|
| `SearchService` | Complete | 3 endpoints ready in `lib/core/services/api/` |
| `SearchScreen` | Placeholder | Shows "Coming soon" message |
| Search Providers | Missing | No state management |
| Search UI | Missing | No TextField, results, etc. |

---

## Target State

```
SearchScreen
├── AppBar with SearchBar (Material 3)
├── Scope Chips (Title, Author, ISBN)
├── Results ListView
│   └── BookSearchResultCard
├── Empty State (trending books)
├── Loading State (shimmer)
├── Error State (retry button)
└── FAB for barcode scanner
```

---

## Implementation Plan

### Step 1: Create Search State Model

**File:** `lib/features/search/models/search_state.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../core/data/models/dtos/work_dto.dart';

part 'search_state.freezed.dart';

enum SearchScope { title, author, isbn }

@freezed
class SearchState with _$SearchState {
  const factory SearchState.initial() = SearchStateInitial;
  const factory SearchState.loading({
    required String query,
    required SearchScope scope,
  }) = SearchStateLoading;
  const factory SearchState.results({
    required String query,
    required SearchScope scope,
    required List<WorkDTO> works,
    required List<EditionDTO> editions,
    required List<AuthorDTO> authors,
    required bool cached,
  }) = SearchStateResults;
  const factory SearchState.empty({
    required String query,
    required SearchScope scope,
  }) = SearchStateEmpty;
  const factory SearchState.error({
    required String query,
    required SearchScope scope,
    required String message,
  }) = SearchStateError;
}
```

---

### Step 2: Create Search Provider

**File:** `lib/features/search/providers/search_provider.dart`

```dart
import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/services/api/search_service.dart';
import '../../../core/providers/api_client_provider.dart';
import '../models/search_state.dart';

part 'search_provider.g.dart';

@riverpod
class SearchNotifier extends _$SearchNotifier {
  Timer? _debounceTimer;

  @override
  SearchState build() => const SearchState.initial();

  void updateQuery(String query, SearchScope scope) {
    // Cancel existing timer
    _debounceTimer?.cancel();

    // Don't search if query too short
    if (query.trim().length < 2) {
      state = const SearchState.initial();
      return;
    }

    // Debounce 300ms
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _performSearch(query.trim(), scope);
    });
  }

  Future<void> _performSearch(String query, SearchScope scope) async {
    state = SearchState.loading(query: query, scope: scope);

    try {
      final searchService = ref.read(searchServiceProvider);

      final response = switch (scope) {
        SearchScope.title => await searchService.searchByTitle(query),
        SearchScope.author => await searchService.searchAdvanced(author: query),
        SearchScope.isbn => await searchService.searchByIsbn(query),
      };

      if (response.data == null || response.data!.works.isEmpty) {
        state = SearchState.empty(query: query, scope: scope);
      } else {
        state = SearchState.results(
          query: query,
          scope: scope,
          works: response.data!.works,
          editions: response.data!.editions,
          authors: response.data!.authors,
          cached: response.meta.cached,
        );
      }
    } catch (e) {
      state = SearchState.error(
        query: query,
        scope: scope,
        message: e.toString(),
      );
    }
  }

  void searchByISBN(String isbn) {
    _performSearch(isbn, SearchScope.isbn);
  }

  void retry() {
    final current = state;
    if (current is SearchStateError) {
      _performSearch(current.query, current.scope);
    }
  }

  void clear() {
    _debounceTimer?.cancel();
    state = const SearchState.initial();
  }
}

@riverpod
class SearchScope extends _$SearchScope {
  @override
  SearchScope build() => SearchScope.title;

  void setScope(SearchScope scope) => state = scope;
}
```

---

### Step 3: Implement Search Screen

**File:** `lib/features/search/screens/search_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/search_provider.dart';
import '../widgets/search_result_card.dart';
import '../widgets/search_empty_state.dart';
import '../widgets/search_error_state.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchNotifierProvider);
    final currentScope = ref.watch(searchScopeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Column(
        children: [
          // Search Input
          Padding(
            padding: const EdgeInsets.all(16),
            child: SearchBar(
              controller: _searchController,
              focusNode: _focusNode,
              hintText: _getHintText(currentScope),
              leading: const Icon(Icons.search),
              trailing: [
                if (_searchController.text.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      ref.read(searchNotifierProvider.notifier).clear();
                    },
                  ),
              ],
              onChanged: (query) {
                ref.read(searchNotifierProvider.notifier)
                    .updateQuery(query, currentScope);
              },
            ),
          ),

          // Scope Chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildScopeChip(SearchScope.title, 'Title', currentScope),
                const SizedBox(width: 8),
                _buildScopeChip(SearchScope.author, 'Author', currentScope),
                const SizedBox(width: 8),
                _buildScopeChip(SearchScope.isbn, 'ISBN', currentScope),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Results
          Expanded(
            child: switch (searchState) {
              SearchStateInitial() => const SearchEmptyState(),
              SearchStateLoading() => const Center(
                  child: CircularProgressIndicator(),
                ),
              SearchStateResults(:final works, :final editions, :final authors) =>
                _buildResultsList(works, editions, authors),
              SearchStateEmpty() => const SearchNoResultsState(),
              SearchStateError(:final message) => SearchErrorState(
                  message: message,
                  onRetry: () {
                    ref.read(searchNotifierProvider.notifier).retry();
                  },
                ),
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openBarcodeScanner,
        child: const Icon(Icons.qr_code_scanner),
      ),
    );
  }

  Widget _buildScopeChip(SearchScope scope, String label, SearchScope current) {
    final isSelected = scope == current;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {
        ref.read(searchScopeProvider.notifier).setScope(scope);
        if (_searchController.text.isNotEmpty) {
          ref.read(searchNotifierProvider.notifier)
              .updateQuery(_searchController.text, scope);
        }
      },
    );
  }

  String _getHintText(SearchScope scope) {
    return switch (scope) {
      SearchScope.title => 'Search by book title...',
      SearchScope.author => 'Search by author name...',
      SearchScope.isbn => 'Enter ISBN (10 or 13 digits)...',
    };
  }

  Widget _buildResultsList(
    List<WorkDTO> works,
    List<EditionDTO> editions,
    List<AuthorDTO> authors,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: works.length,
      itemBuilder: (context, index) {
        final work = works[index];
        final workEditions = editions.where((e) => e.workId == work.id).toList();
        final workAuthors = authors.where((a) => work.authorIds.contains(a.id)).toList();

        return SearchResultCard(
          work: work,
          edition: workEditions.isNotEmpty ? workEditions.first : null,
          authors: workAuthors,
          onTap: () => _showBookDetail(work, workEditions, workAuthors),
          onAddToLibrary: () => _addToLibrary(work, workEditions, workAuthors),
        );
      },
    );
  }

  void _openBarcodeScanner() {
    // Navigate to ISBN scanner screen
    // Implementation in 03-SCANNER-FEATURE.md
  }

  void _showBookDetail(WorkDTO work, List<EditionDTO> editions, List<AuthorDTO> authors) {
    // Navigate to book detail
    // Implementation in 08-BOOK-DETAIL.md
  }

  void _addToLibrary(WorkDTO work, List<EditionDTO> editions, List<AuthorDTO> authors) async {
    // Use DTOMapper to save to database
    // Show success snackbar
  }
}
```

---

### Step 4: Create Search Result Card

**File:** `lib/features/search/widgets/search_result_card.dart`

```dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/data/models/dtos/work_dto.dart';

class SearchResultCard extends StatelessWidget {
  final WorkDTO work;
  final EditionDTO? edition;
  final List<AuthorDTO> authors;
  final VoidCallback onTap;
  final VoidCallback onAddToLibrary;

  const SearchResultCard({
    super.key,
    required this.work,
    this.edition,
    required this.authors,
    required this.onTap,
    required this.onAddToLibrary,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authorNames = authors.map((a) => a.name).join(', ');
    final coverUrl = edition?.coverImageUrl;

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cover Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: coverUrl != null
                    ? CachedNetworkImage(
                        imageUrl: coverUrl,
                        width: 60,
                        height: 90,
                        fit: BoxFit.cover,
                        memCacheWidth: 180,
                        memCacheHeight: 270,
                        placeholder: (_, __) => _buildPlaceholder(),
                        errorWidget: (_, __, ___) => _buildPlaceholder(),
                      )
                    : _buildPlaceholder(),
              ),

              const SizedBox(width: 12),

              // Book Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      work.title,
                      style: theme.textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (authorNames.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        authorNames,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (edition?.publishedYear != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        edition!.publishedYear.toString(),
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                    if (work.subjectTags.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: work.subjectTags.take(3).map((tag) {
                          return Chip(
                            label: Text(tag),
                            labelStyle: theme.textTheme.labelSmall,
                            padding: EdgeInsets.zero,
                            visualDensity: VisualDensity.compact,
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),

              // Add Button
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: onAddToLibrary,
                tooltip: 'Add to Library',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 60,
      height: 90,
      color: Colors.grey[300],
      child: const Icon(Icons.book, color: Colors.grey),
    );
  }
}
```

---

### Step 5: Create Supporting Widgets

**File:** `lib/features/search/widgets/search_empty_state.dart`

```dart
import 'package:flutter/material.dart';

class SearchEmptyState extends StatelessWidget {
  const SearchEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'Search for books',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Find books by title, author, or ISBN',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class SearchNoResultsState extends StatelessWidget {
  const SearchNoResultsState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'No books found',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Try a different search term',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
```

**File:** `lib/features/search/widgets/search_error_state.dart`

```dart
import 'package:flutter/material.dart';

class SearchErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const SearchErrorState({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Search failed',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

### Step 6: Update Barrel Export

**File:** `lib/features/search/search.dart`

```dart
// Screens
export 'screens/search_screen.dart';

// Providers
export 'providers/search_provider.dart';

// Models
export 'models/search_state.dart';

// Widgets
export 'widgets/search_result_card.dart';
export 'widgets/search_empty_state.dart';
export 'widgets/search_error_state.dart';
```

---

## Integration with Library

### Add to Library Flow

When user taps "Add to Library" on a search result:

1. Use `DTOMapper.mapAndInsertSearchResponse()` to save to database
2. Create `UserLibraryEntry` with default status (toRead)
3. Show success snackbar
4. Navigate to book detail (optional)

```dart
Future<void> _addToLibrary(
  WorkDTO work,
  List<EditionDTO> editions,
  List<AuthorDTO> authors,
) async {
  final database = ref.read(databaseProvider);

  try {
    // Create minimal search response for single book
    final data = SearchResponseData(
      works: [work],
      editions: editions,
      authors: authors,
    );

    // Map and insert
    await DTOMapper.mapAndInsertSearchResponse(data, database);

    // Create library entry
    await database.upsertLibraryEntry(
      workId: work.id,
      editionId: editions.isNotEmpty ? editions.first.id : null,
      status: ReadingStatus.toRead,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added "${work.title}" to library'),
          action: SnackBarAction(
            label: 'View',
            onPressed: () => _navigateToLibrary(),
          ),
        ),
      );
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add book: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }
}
```

---

## Testing Checklist

### Unit Tests
- [ ] SearchNotifier debounce timing (300ms)
- [ ] Query validation (min 2 characters)
- [ ] Scope switching updates search
- [ ] Error state handling

### Widget Tests
- [ ] SearchScreen renders correctly
- [ ] Scope chips toggle properly
- [ ] Results list populates
- [ ] Empty state shows for no results
- [ ] Error state shows retry button

### Integration Tests
- [ ] Type query → API call → Results display
- [ ] Add to library → Database updated → Snackbar shown
- [ ] Clear search → State resets

---

## Files to Create

| File | Type | Description |
|------|------|-------------|
| `lib/features/search/models/search_state.dart` | Model | Freezed state model |
| `lib/features/search/providers/search_provider.dart` | Provider | Search state management |
| `lib/features/search/screens/search_screen.dart` | Screen | Main search UI |
| `lib/features/search/widgets/search_result_card.dart` | Widget | Result item card |
| `lib/features/search/widgets/search_empty_state.dart` | Widget | Empty/no results state |
| `lib/features/search/widgets/search_error_state.dart` | Widget | Error with retry |
| `lib/features/search/search.dart` | Barrel | Feature exports |

---

## Dependencies

Existing packages (already in pubspec.yaml):
- `flutter_riverpod` - State management
- `freezed` - Immutable state models
- `dio` - HTTP client
- `cached_network_image` - Image caching

---

## Next Steps

After implementing Search:
1. **03-SCANNER-FEATURE.md** - Add barcode scanning (FAB functionality)
2. **08-BOOK-DETAIL.md** - Book detail screen for search results

---

**Document Status:** Ready for Implementation
**Last Updated:** December 26, 2025
