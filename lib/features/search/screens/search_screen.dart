import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/search_state.dart';
import '../providers/search_providers.dart';
import '../widgets/book_search_result_card.dart';

/// Search Screen with multi-mode search capabilities
/// Supports: Title, Author, ISBN search with barcode scanner integration
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late final TextEditingController _searchController;
  late final FocusNode _searchFocusNode;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchProvider);
    final currentScope = ref.watch(searchScopeNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Search Bar
                SearchBar(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  hintText: _getHintText(currentScope),
                  leading: Icon(
                    _getScopeIcon(currentScope),
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  trailing: [
                    if (_searchController.text.isNotEmpty)
                      IconButton(
                        onPressed: _clearSearch,
                        icon: const Icon(Icons.clear),
                        tooltip: 'Clear search',
                      ),
                  ],
                  onChanged: _onSearchChanged,
                  onSubmitted: _onSearchSubmitted,
                ),
                const SizedBox(height: 12),

                // Scope Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: SearchScope.values.map((scope) {
                      final isSelected = currentScope == scope;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(_getScopeLabel(scope)),
                          selected: isSelected,
                          onSelected: (_) => _onScopeSelected(scope),
                          avatar: !isSelected ? Icon(
                            _getScopeIcon(scope),
                            size: 18,
                          ) : null,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: _buildBody(searchState),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openBarcodeScanner,
        icon: const Icon(Icons.qr_code_scanner),
        label: const Text('Scan ISBN'),
      ),
    );
  }

  Widget _buildBody(SearchState searchState) {
    return searchState.when(
      initial: () => _buildInitialState(),
      loading: (query, scope) => _buildLoadingState(query, scope),
      results: (query, scope, works, editions, authors, cached, totalResults) =>
          _buildResultsState(query, scope, works, editions, authors, cached, totalResults),
      empty: (query, scope, message) => _buildEmptyState(query, scope, message),
      error: (query, scope, message, errorCode) => _buildErrorState(query, scope, message),
    );
  }

  Widget _buildInitialState() {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 80,
              color: theme.colorScheme.primary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Search for Books',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Search by title, author, or scan an ISBN barcode to find books',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState(String query, SearchScope scope) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'Searching ${_getScopeLabel(scope).toLowerCase()}...',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              '"$query"',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsState(
    String query,
    SearchScope scope,
    List works,
    List editions,
    List authors,
    bool cached,
    int totalResults,
  ) {
    return Column(
      children: [
        // Results Header
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '$totalResults result${totalResults == 1 ? '' : 's'} for "$query"',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              if (cached)
                Chip(
                  label: const Text('Cached'),
                  avatar: const Icon(Icons.offline_bolt, size: 16),
                  visualDensity: VisualDensity.compact,
                ),
            ],
          ),
        ),

        // Results List
        Expanded(
          child: ListView.builder(
            itemCount: works.length,
            itemBuilder: (context, index) {
              final work = works[index];

              // Find corresponding edition and authors for this work
              final edition = editions.cast().firstWhere(
                (e) => e.workId == work.id,
                orElse: () => null,
              );

              final workAuthors = authors.cast().where((a) =>
                work.authorIds?.contains(a.id) ?? false
              ).toList();

              return BookSearchResultCard(
                work: work,
                edition: edition,
                authors: workAuthors,
                onTap: () => _onBookTapped(work),
                onAddToLibrary: () => _onAddToLibrary(work, edition),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(String query, SearchScope scope, String message) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 80,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No Results Found',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => _clearSearch(),
              icon: const Icon(Icons.refresh),
              label: const Text('Try Different Search'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String query, SearchScope scope, String message) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: theme.colorScheme.error.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Search Error',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => ref.read(searchProvider.notifier).retry(),
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  // Event Handlers
  void _onSearchChanged(String value) {
    ref.read(searchQueryProvider.notifier).setQuery(value);
  }

  void _onSearchSubmitted(String value) {
    if (value.trim().isNotEmpty) {
      _performSearch(value.trim());
    }
  }

  void _onScopeSelected(SearchScope scope) {
    ref.read(searchScopeNotifierProvider.notifier).setScope(scope);
    final currentQuery = _searchController.text.trim();
    if (currentQuery.isNotEmpty) {
      _performSearch(currentQuery);
    }
  }

  void _performSearch(String query) {
    final scope = ref.read(searchScopeNotifierProvider);
    ref.read(searchProvider.notifier).search(query: query, scope: scope);
  }

  void _clearSearch() {
    _searchController.clear();
    ref.read(searchQueryProvider.notifier).clear();
    ref.read(searchProvider.notifier).clear();
    _searchFocusNode.requestFocus();
  }

  void _onBookTapped(dynamic work) {
    // TODO: Navigate to book detail screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Book details for "${work.title}" coming soon!')),
    );
  }

  void _onAddToLibrary(dynamic work, dynamic edition) {
    // TODO: Add book to user's library
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added "${work.title}" to library!'),
        action: SnackBarAction(
          label: 'View Library',
          onPressed: () {
            // TODO: Navigate to library
          },
        ),
      ),
    );
  }

  void _openBarcodeScanner() {
    // TODO: Integrate with scanner screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Barcode scanner coming soon!')),
    );
  }

  // Helper methods
  String _getHintText(SearchScope scope) {
    switch (scope) {
      case SearchScope.title:
        return 'Search by book title...';
      case SearchScope.author:
        return 'Search by author name...';
      case SearchScope.isbn:
        return 'Enter ISBN (10 or 13 digits)...';
      case SearchScope.advanced:
        return 'Search by title and author...';
    }
  }

  String _getScopeLabel(SearchScope scope) {
    switch (scope) {
      case SearchScope.title:
        return 'Title';
      case SearchScope.author:
        return 'Author';
      case SearchScope.isbn:
        return 'ISBN';
      case SearchScope.advanced:
        return 'Advanced';
    }
  }

  IconData _getScopeIcon(SearchScope scope) {
    switch (scope) {
      case SearchScope.title:
        return Icons.title;
      case SearchScope.author:
        return Icons.person;
      case SearchScope.isbn:
        return Icons.numbers;
      case SearchScope.advanced:
        return Icons.tune;
    }
  }
}