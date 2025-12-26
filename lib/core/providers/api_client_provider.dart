import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/api/search_service.dart';

part 'api_client_provider.g.dart';

@riverpod
Dio apiClient(ApiClientRef ref) {
  final dio = Dio();
  dio.options.baseUrl = 'https://api.oooefam.net';
  dio.options.connectTimeout = const Duration(seconds: 30);
  dio.options.receiveTimeout = const Duration(seconds: 60);
  return dio;
}

@riverpod
SearchService searchService(SearchServiceRef ref) {
  final dio = ref.watch(apiClientProvider);
  return SearchService(dio);
}
