import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:books_flutter/core/data/database/database.dart';
import 'package:books_flutter/shared/widgets/cards/book_card.dart';
import 'package:books_flutter/shared/widgets/cards/book_grid_card.dart';
import '../providers/library_providers.dart';

/// Library Screen - Main screen showing user's book collection
class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  bool _isGridView = false;

  @override
  Widget build(BuildContext context) {
    final libraryWorks = ref.watch(watchLibraryWorksProvider);
    final currentFilter = ref.watch(libraryFilterProvider);
    final currentSort = ref.watch(librarySortOptionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
        actions: [
          // View toggle
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
            tooltip: _isGridView ? 'List view' : 'Grid view',
          ),
          // Sort menu
          _buildSortMenu(currentSort),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: _buildFilterChips(currentFilter),
        ),
      ),
      body: libraryWorks.when(
        data: (books) {
          if (books.isEmpty) {
            return _buildEmptyState();
          }

          return _isGridView
              ? _buildGridView(books)
              : _buildListView(books);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error loading library: $error'),
        ),
      ),
    );
  }

  Widget _buildSortMenu(SortBy currentSort) {
    return PopupMenuButton<SortBy>(
      icon: const Icon(Icons.sort),
      tooltip: 'Sort by',
      onSelected: (sortBy) {
        ref.read(librarySortOptionProvider.notifier).setSort(sortBy);
      },
      itemBuilder: (context) => [
        _buildSortMenuItem(SortBy.recentlyAdded, 'Recently Added', currentSort),
        _buildSortMenuItem(SortBy.title, 'Title', currentSort),
        _buildSortMenuItem(SortBy.author, 'Author', currentSort),
        _buildSortMenuItem(SortBy.recentlyRead, 'Recently Read', currentSort),
        _buildSortMenuItem(SortBy.rating, 'Rating', currentSort),
      ],
    );
  }

  PopupMenuItem<SortBy> _buildSortMenuItem(
    SortBy value,
    String label,
    SortBy currentSort,
  ) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(
            currentSort == value
                ? Icons.check_circle
                : Icons.circle_outlined,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }

  Widget _buildFilterChips(ReadingStatus? currentFilter) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip(
              label: 'All',
              isSelected: currentFilter == null,
              onSelected: () {
                ref.read(libraryFilterProvider.notifier).clearFilter();
              },
            ),
            const SizedBox(width: 8),
            _buildFilterChip(
              label: 'Wishlist',
              isSelected: currentFilter == ReadingStatus.wishlist,
              onSelected: () {
                ref
                    .read(libraryFilterProvider.notifier)
                    .setFilter(ReadingStatus.wishlist);
              },
              icon: Icons.bookmark_border,
            ),
            const SizedBox(width: 8),
            _buildFilterChip(
              label: 'To Read',
              isSelected: currentFilter == ReadingStatus.toRead,
              onSelected: () {
                ref
                    .read(libraryFilterProvider.notifier)
                    .setFilter(ReadingStatus.toRead);
              },
              icon: Icons.book_outlined,
            ),
            const SizedBox(width: 8),
            _buildFilterChip(
              label: 'Reading',
              isSelected: currentFilter == ReadingStatus.reading,
              onSelected: () {
                ref
                    .read(libraryFilterProvider.notifier)
                    .setFilter(ReadingStatus.reading);
              },
              icon: Icons.auto_stories,
            ),
            const SizedBox(width: 8),
            _buildFilterChip(
              label: 'Read',
              isSelected: currentFilter == ReadingStatus.read,
              onSelected: () {
                ref
                    .read(libraryFilterProvider.notifier)
                    .setFilter(ReadingStatus.read);
              },
              icon: Icons.check_circle_outline,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onSelected,
    IconData? icon,
  }) {
    final theme = Theme.of(context);

    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16),
            const SizedBox(width: 4),
          ],
          Text(label),
        ],
      ),
      selected: isSelected,
      onSelected: (_) => onSelected(),
      selectedColor: theme.colorScheme.primaryContainer,
    );
  }

  Widget _buildListView(List<WorkWithLibraryStatus> books) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: BookCard(
            bookData: book,
            onTap: () {
              // TODO: Navigate to book detail screen
            },
          ),
        );
      },
    );
  }

  Widget _buildGridView(List<WorkWithLibraryStatus> books) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        return BookGridCard(
          bookData: book,
          onTap: () {
            // TODO: Navigate to book detail screen
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_stories_outlined,
              size: 80,
              color: theme.colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Your library is empty',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Start adding books to track your reading journey',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                // TODO: Navigate to search/scanner
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Books'),
            ),
          ],
        ),
      ),
    );
  }

}
