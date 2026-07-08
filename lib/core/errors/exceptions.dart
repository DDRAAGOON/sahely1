/// Base class for all custom exceptions in the application.
/// Exceptions are typically thrown in the [Data Layer] (DataSources) when a
/// request or operation fails.
class ServerException implements Exception {
  final String? message;
  final int? statusCode;

  ServerException({this.message, this.statusCode});

  @override
  String toString() => 'ServerException: $message (Status: $statusCode)';
}

/// Thrown when a local database or cache operation fails.
class CacheException implements Exception {
  final String? message;
  CacheException([this.message]);
}

/// Thrown when there is no internet connection during a network request.
class NetworkException implements Exception {
  final String? message;
  NetworkException([this.message]);
}

/// Thrown during authentication failures (e.g., invalid credentials).
class AuthException implements Exception {
  final String? message;
  AuthException([this.message]);
}

/// Thrown when the server returns a 422 or validation error.
class ValidationException implements Exception {
  final Map<String, dynamic> errors;
  ValidationException(this.errors);
}
