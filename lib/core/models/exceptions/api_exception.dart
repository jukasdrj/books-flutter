/// ApiException - Represents API-level errors from ResponseEnvelope
///
/// Unlike DioException (network errors), ApiException represents
/// structured errors from the API response body with canonical error codes.
class ApiException implements Exception {
  /// Canonical error code from API (INVALID_QUERY, INVALID_ISBN, etc)
  final String code;

  /// User-friendly error message from API
  final String message;

  /// Additional error details (optional)
  final Map<String, dynamic>? details;

  ApiException({
    required this.code,
    required this.message,
    this.details,
  });

  @override
  String toString() => 'ApiException($code): $message';

  /// Check if this is a specific error code
  bool isCode(String errorCode) => code == errorCode;

  /// Check if this is a rate limit error
  bool isRateLimit() => code == 'RATE_LIMIT_EXCEEDED';

  /// Check if this is a validation error
  bool isValidationError() =>
    code == 'INVALID_QUERY' ||
    code == 'INVALID_ISBN';

  /// Check if this is a provider error
  bool isProviderError() => code == 'PROVIDER_ERROR';

  /// Check if this is an internal server error
  bool isInternalError() => code == 'INTERNAL_ERROR';
}
