import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// API Client - Centralized HTTP client with error handling
class ApiClient {
  static Dio create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.oooefam.net',  // Production BooksTrack API
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 60),  // Allow for AI processing (25-40s)
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    dio.interceptors.addAll([
      _LoggingInterceptor(),
      _ErrorInterceptor(),
      _RetryInterceptor(dio),
    ]);

    return dio;
  }
}

/// Logging Interceptor - Logs requests and responses
class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      print('🌐 REQUEST: ${options.method} ${options.uri}');
      if (options.data != null) {
        print('📤 DATA: ${options.data}');
      }
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      print('✅ RESPONSE: ${response.statusCode} ${response.requestOptions.uri}');
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      print('❌ ERROR: ${err.type} ${err.message}');
      if (err.response != null) {
        print('📥 RESPONSE: ${err.response?.statusCode} ${err.response?.data}');
      }
    }
    super.onError(err, handler);
  }
}

/// Error Interceptor - Handles common error scenarios
class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        err = DioException(
          requestOptions: err.requestOptions,
          error: 'Connection timeout. Please check your internet connection.',
          type: err.type,
        );
        break;
      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode;
        String message;
        switch (statusCode) {
          case 400:
            message = 'Bad request. Please check your input.';
            break;
          case 401:
            message = 'Unauthorized. Please log in again.';
            break;
          case 403:
            message = 'Forbidden. You don\'t have permission.';
            break;
          case 404:
            message = 'Resource not found.';
            break;
          case 500:
            message = 'Server error. Please try again later.';
            break;
          default:
            message = 'An error occurred. Please try again.';
        }
        err = DioException(
          requestOptions: err.requestOptions,
          error: message,
          type: err.type,
          response: err.response,
        );
        break;
      case DioExceptionType.cancel:
        err = DioException(
          requestOptions: err.requestOptions,
          error: 'Request cancelled.',
          type: err.type,
        );
        break;
      default:
        err = DioException(
          requestOptions: err.requestOptions,
          error: 'Network error. Please check your connection.',
          type: err.type,
        );
    }
    super.onError(err, handler);
  }
}

/// Retry Interceptor - Automatically retries failed requests
class _RetryInterceptor extends Interceptor {
  final Dio dio;
  static const int maxRetries = 3;

  _RetryInterceptor(this.dio);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err)) {
      final requestOptions = err.requestOptions;
      final retryCount = requestOptions.extra['retryCount'] ?? 0;

      if (retryCount < maxRetries) {
        requestOptions.extra['retryCount'] = retryCount + 1;

        // Exponential backoff
        final delay = Duration(milliseconds: (500 * (retryCount + 1)).toInt());

        await Future.delayed(delay);

        try {
          final response = await dio.request(
            requestOptions.path,
            data: requestOptions.data,
            queryParameters: requestOptions.queryParameters,
            options: Options(
              method: requestOptions.method,
              headers: requestOptions.headers,
              extra: requestOptions.extra,
            ),
          );
          return handler.resolve(response);
        } catch (e) {
          return handler.next(err);
        }
      }
    }
    super.onError(err, handler);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
           err.type == DioExceptionType.receiveTimeout ||
           err.type == DioExceptionType.sendTimeout ||
           (err.type == DioExceptionType.badResponse && err.response?.statusCode == 500);
  }
}