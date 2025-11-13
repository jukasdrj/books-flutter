import 'package:dio/dio.dart';
import '../../data/models/dtos/work_dto.dart';

/// SearchService - Handles all book search operations
/// Integrates with canonical BooksTrack API v1.0.0
class SearchService {
  final Dio dio;

  SearchService(this.dio);

  /// Search books by title
  ///
  /// GET /v1/search/title?q={query}
  /// Cached for 6 hours per canonical spec
  ///
  /// Throws:
  /// - DioException if network error
  /// - ApiException if API returns error
  Future<ResponseEnvelope<SearchResponseData>> searchByTitle(String query) async {
    if (query.trim().isEmpty) {
      throw DioException(
        requestOptions: RequestOptions(path: ''),
        error: 'Query cannot be empty',
        type: DioExceptionType.badRequest,
      );
    }

    try {
      final response = await dio.get<Map<String, dynamic>>(
        '/v1/search/title',
        queryParameters: {'q': query},
      );

      // Parse ResponseEnvelope
      final envelope = ResponseEnvelope.fromJson(
        response.data!,
        (json) => SearchResponseData.fromJson(json as Map<String, dynamic>),
      );

      return envelope;
    } on DioException {
      rethrow;
    }
  }

  /// Search books by ISBN
  ///
  /// GET /v1/search/isbn?isbn={isbn}
  /// Cached for 7 days per canonical spec
  /// Supports ISBN-10 and ISBN-13 formats
  ///
  /// Throws:
  /// - DioException if network error
  /// - ApiException if API returns error (invalid ISBN, etc)
  Future<ResponseEnvelope<SearchResponseData>> searchByIsbn(String isbn) async {
    final cleanIsbn = isbn.replaceAll(RegExp(r'[^0-9X]'), '');

    if (cleanIsbn.isEmpty || (cleanIsbn.length != 10 && cleanIsbn.length != 13)) {
      throw DioException(
        requestOptions: RequestOptions(path: ''),
        error: 'Invalid ISBN format (must be 10 or 13 digits)',
        type: DioExceptionType.badRequest,
      );
    }

    try {
      final response = await dio.get<Map<String, dynamic>>(
        '/v1/search/isbn',
        queryParameters: {'isbn': cleanIsbn},
      );

      // Parse ResponseEnvelope
      final envelope = ResponseEnvelope.fromJson(
        response.data!,
        (json) => SearchResponseData.fromJson(json as Map<String, dynamic>),
      );

      return envelope;
    } on DioException {
      rethrow;
    }
  }

  /// Advanced search - search by title and/or author
  ///
  /// GET /v1/search/advanced?title={title}&author={author}
  /// Cached for 6 hours per canonical spec
  /// Either title or author (or both) must be provided
  ///
  /// Throws:
  /// - DioException if network error
  /// - ApiException if API returns error
  Future<ResponseEnvelope<SearchResponseData>> searchAdvanced({
    String? title,
    String? author,
  }) async {
    if ((title?.isEmpty ?? true) && (author?.isEmpty ?? true)) {
      throw DioException(
        requestOptions: RequestOptions(path: ''),
        error: 'At least one of title or author must be provided',
        type: DioExceptionType.badRequest,
      );
    }

    try {
      final queryParams = <String, String>{};
      if (title != null && title.isNotEmpty) {
        queryParams['title'] = title;
      }
      if (author != null && author.isNotEmpty) {
        queryParams['author'] = author;
      }

      final response = await dio.get<Map<String, dynamic>>(
        '/v1/search/advanced',
        queryParameters: queryParams,
      );

      // Parse ResponseEnvelope
      final envelope = ResponseEnvelope.fromJson(
        response.data!,
        (json) => SearchResponseData.fromJson(json as Map<String, dynamic>),
      );

      return envelope;
    } on DioException {
      rethrow;
    }
  }
}
