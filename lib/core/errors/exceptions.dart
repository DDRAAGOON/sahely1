/// Base for every exception raised by the data layer.
///
/// [code] mirrors the backend's machine-readable `error.code` and [field] the
/// offending form field, so blocs can branch on the code (session expired,
/// KYC required, ...) and forms can highlight the right input.
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final String? field;

  const AppException(this.message, {this.code, this.field});

  @override
  String toString() => '$runtimeType(${code ?? '-'}): $message';
}

class ServerException extends AppException {
  final int? statusCode;

  const ServerException(
    super.message, {
    this.statusCode,
    super.code,
    super.field,
  });
}

class NetworkException extends AppException {
  const NetworkException(super.message, {super.code});
}

class CacheException extends AppException {
  const CacheException(super.message);
}

class ValidationException extends AppException {
  final Map<String, dynamic>? errors;

  const ValidationException(
    super.message, {
    this.errors,
    super.code,
    super.field,
  });
}

class UnauthorizedException extends AppException {
  const UnauthorizedException(super.message, {super.code, super.field});
}

class ForbiddenException extends AppException {
  const ForbiddenException(super.message, {super.code, super.field});
}

class NotFoundException extends AppException {
  const NotFoundException(super.message, {super.code});
}

class TimeoutException extends AppException {
  const TimeoutException(super.message, {super.code});
}

class UnknownException extends AppException {
  const UnknownException(super.message, {super.code});
}
