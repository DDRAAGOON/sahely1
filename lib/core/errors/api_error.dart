/// Structured API error returned by the Sahely backend.
///
/// Backend error envelope:
/// { "success": false, "error": { "code": "...", "message": "...", "field": "...", "metadata": {...} } }
class ApiError {
  /// Machine-readable error code (e.g. "ERR_AUTH_INVALID_CREDENTIALS")
  final String code;

  /// Human-readable message from the server (we replace this with i18n)
  final String message;

  /// Which form field caused the error (for inline field highlighting)
  final String? field;

  /// Extra dynamic data (e.g. { "date": "2026-10-15", "attempts": 2 })
  final Map<String, dynamic>? metadata;

  const ApiError({
    required this.code,
    required this.message,
    this.field,
    this.metadata,
  });

  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      code: json['code'] as String? ?? 'ERR_SERVER_INTERNAL',
      message: json['message'] as String? ?? 'An unexpected error occurred',
      field: json['field'] as String?,
      metadata: json['metadata'] is Map
          ? Map<String, dynamic>.from(json['metadata'] as Map)
          : null,
    );
  }

  /// Safely parse from a nullable raw response body.
  /// Returns null if the data is not a valid error envelope.
  static ApiError? tryParse(dynamic responseData) {
    if (responseData is! Map<String, dynamic>) return null;
    final error = responseData['error'];
    if (error is! Map<String, dynamic>) return null;
    return ApiError.fromJson(error);
  }

  @override
  String toString() =>
      'ApiError(code: $code, field: $field, message: $message)';
}
