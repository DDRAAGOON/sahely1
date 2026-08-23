class ServerException implements Exception {
  final String message;
  final int? statusCode;
  const ServerException(this.message, {this.statusCode});
}

class NetworkException implements Exception {
  final String message;
  const NetworkException(this.message);
}

class CacheException implements Exception {
  final String message;
  const CacheException(this.message);
}

class ValidationException implements Exception {
  final String message;
  final Map<String, dynamic>? errors;
  const ValidationException(this.message, {this.errors});
}

class UnauthorizedException implements Exception {
  final String message;
  const UnauthorizedException(this.message);
}

class ForbiddenException implements Exception {
  final String message;
  const ForbiddenException(this.message);
}

class NotFoundException implements Exception {
  final String message;
  const NotFoundException(this.message);
}

class TimeoutException implements Exception {
  final String message;
  const TimeoutException(this.message);
}

class UnknownException implements Exception {
  final String message;
  const UnknownException(this.message);
}
