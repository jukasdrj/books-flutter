import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../core/data/models/dtos/work_dto.dart';
import '../../../core/data/models/dtos/edition_dto.dart';
import '../../../core/data/models/dtos/author_dto.dart';

part 'search_state.freezed.dart';

enum SearchScope {
  title,
  author,
  isbn,
  advanced
}

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
    required int totalResults,
  }) = SearchStateResults;

  const factory SearchState.empty({
    required String query,
    required SearchScope scope,
    required String message,
  }) = SearchStateEmpty;

  const factory SearchState.error({
    required String query,
    required SearchScope scope,
    required String message,
    String? errorCode,
  }) = SearchStateError;
}

extension SearchStateExtensions on SearchState {
  bool get isLoading => this is SearchStateLoading;
  bool get hasResults => this is SearchStateResults;
  bool get isEmpty => this is SearchStateEmpty;
  bool get hasError => this is SearchStateError;

  String get currentQuery => when(
    initial: () => '',
    loading: (query, _) => query,
    results: (query, _, __, ___, ____, _____, ______) => query,
    empty: (query, _, __) => query,
    error: (query, _, __, ___) => query,
  );

  SearchScope get currentScope => when(
    initial: () => SearchScope.title,
    loading: (_, scope) => scope,
    results: (_, scope, __, ___, ____, _____, ______) => scope,
    empty: (_, scope, __) => scope,
    error: (_, scope, __, ___) => scope,
  );
}