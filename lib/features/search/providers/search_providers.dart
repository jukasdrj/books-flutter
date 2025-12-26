import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dio/dio.dart';
import '../../../core/providers/api_client_provider.dart';
import '../../../core/services/api/search_service.dart';
import '../../../core/models/exceptions/api_exception.dart';
import '../models/search_state.dart';

part 'search_providers.g.dart';

/// Current search scope (Title, Author, ISBN, Advanced)
@riverpod
class SearchScopeNotifier extends _$SearchScopeNotifier {
  @override
  SearchScope build() => SearchScope.title;

  void setScope(SearchScope scope) => state = scope;
}

/// Current search query text
@riverpod
class SearchQuery extends _$SearchQuery {
  @override
  String build() => '';

  void setQuery(String query) => state = query.trim();
  void clear() => state = '';
}

/// Search state notifier - handles all search operations
@riverpod
class Search extends _$Search {
  @override
  SearchState build() => const SearchState.initial();

  /// Performs search based on current scope and query
  Future<void> search({
    required String query,
    required SearchScope scope,
  }) async {
    if (query.trim().isEmpty) {
      state = const SearchState.initial();
      return;
    }

    final trimmedQuery = query.trim();

    // Set loading state
    state = SearchState.loading(
      query: trimmedQuery,
      scope: scope,
    );

    try {
      final searchService = ref.read(searchServiceProvider);

      switch (scope) {
        case SearchScope.title:
          await _searchByTitle(searchService, trimmedQuery);
          break;
        case SearchScope.author:
          await _searchByAuthor(searchService, trimmedQuery);
          break;
        case SearchScope.isbn:
          await _searchByISBN(searchService, trimmedQuery);
          break;
        case SearchScope.advanced:
          // For now, treat advanced as title search
          // TODO: Implement combined title + author search
          await _searchByTitle(searchService, trimmedQuery);
          break;
      }
    } on ApiException catch (e) {
      state = SearchState.error(
        query: trimmedQuery,
        scope: scope,
        message: e.message,
        errorCode: e.code,
      );
    } on DioException catch (e) {
      String message = 'Network error. Please check your connection.';
      if (e.type == DioExceptionType.receiveTimeout) {
        message = 'Request timed out. Please try again.';
      } else if (e.type == DioExceptionType.cancel) {
        message = 'Search cancelled.';
      }

      state = SearchState.error(
        query: trimmedQuery,
        scope: scope,
        message: message,
      );
    } catch (e) {
      state = SearchState.error(
        query: trimmedQuery,
        scope: scope,
        message: 'An unexpected error occurred. Please try again.',
      );
    }
  }

  Future<void> _searchByTitle(SearchService service, String query) async {
    final response = await service.searchByTitle(query);

    if (response.data?.works.isEmpty ?? true) {
      state = SearchState.empty(
        query: query,
        scope: SearchScope.title,
        message: 'No books found for "$query". Try a different search term.',
      );
    } else {
      final data = response.data!;
      state = SearchState.results(
        query: query,
        scope: SearchScope.title,
        works: data.works,
        editions: data.editions,
        authors: data.authors,
        cached: response.meta.cached,
        totalResults: data.works.length,
      );
    }
  }

  Future<void> _searchByAuthor(SearchService service, String query) async {
    final response = await service.searchByAuthor(query);

    if (response.data?.works.isEmpty ?? true) {
      state = SearchState.empty(
        query: query,
        scope: SearchScope.author,
        message: 'No books found by author "$query". Check the spelling or try a different author.',
      );
    } else {
      final data = response.data!;
      state = SearchState.results(
        query: query,
        scope: SearchScope.author,
        works: data.works,
        editions: data.editions,
        authors: data.authors,
        cached: response.meta.cached,
        totalResults: data.works.length,
      );
    }
  }

  Future<void> _searchByISBN(SearchService service, String query) async {
    // Clean ISBN (remove spaces, dashes)
    final cleanISBN = query.replaceAll(RegExp(r'[^0-9X]'), '');

    if (cleanISBN.length < 10) {
      state = SearchState.error(
        query: query,
        scope: SearchScope.isbn,
        message: 'ISBN must be at least 10 digits. Please enter a valid ISBN.',
      );
      return;
    }

    final response = await service.searchByISBN(cleanISBN);

    if (response.data?.works.isEmpty ?? true) {
      state = SearchState.empty(
        query: query,
        scope: SearchScope.isbn,
        message: 'No book found with ISBN "$query". Please check the ISBN and try again.',
      );
    } else {
      final data = response.data!;
      state = SearchState.results(
        query: query,
        scope: SearchScope.isbn,
        works: data.works,
        editions: data.editions,
        authors: data.authors,
        cached: response.meta.cached,
        totalResults: data.works.length,
      );
    }
  }

  /// Clears search results and returns to initial state
  void clear() {
    state = const SearchState.initial();
  }

  /// Retries the last search
  void retry() {
    final currentState = state;
    if (currentState is SearchStateError) {
      search(
        query: currentState.query,
        scope: currentState.scope,
      );
    }
  }
}

/// Combined search state provider for UI convenience
@riverpod
SearchState searchWithQuery(SearchWithQueryRef ref) {
  final query = ref.watch(searchQueryProvider);
  final scope = ref.watch(searchScopeNotifierProvider);
  final searchState = ref.watch(searchProvider);

  // Auto-trigger search when query changes (with debouncing)
  ref.listen(searchQueryProvider, (previous, next) {
    if (next.isNotEmpty && next != previous) {
      // Simple debouncing - cancel previous search
      Future.delayed(const Duration(milliseconds: 300), () {
        if (ref.read(searchQueryProvider) == next) {
          ref.read(searchProvider.notifier).search(
            query: next,
            scope: ref.read(searchScopeNotifierProvider),
          );
        }
      });
    }
  });

  return searchState;
}