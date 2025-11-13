import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/api/api_client.dart';
import '../services/api/search_service.dart';

part 'api_client_provider.g.dart';

/// Provider for the global Dio HTTP client instance
///
/// Creates and configures the API client with:
/// - Base URL: https://api.oooefam.net (production)
/// - Interceptors: logging, error handling, retry
/// - Timeouts: 10s connect, 60s receive
@riverpod
Dio apiClient(ApiClientRef ref) {
  return ApiClient.create();
}

/// Provider for the SearchService
///
/// Uses the apiClient to make search requests to:
/// - GET /v1/search/title?q={query}
/// - GET /v1/search/isbn?isbn={isbn}
/// - GET /v1/search/advanced?title={title}&author={author}
@riverpod
SearchService searchService(SearchServiceRef ref) {
  final dio = ref.watch(apiClientProvider);
  return SearchService(dio);
}
