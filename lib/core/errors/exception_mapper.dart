import 'package:dio/dio.dart';

import 'package:sahely/core/network/network_exceptions.dart';

import 'exceptions.dart';
import 'failures.dart';

/// Converts anything thrown by the data layer into a domain [Failure],
/// preserving the backend's `error.code` and `error.field`.
///
/// This is the single place that does the translation - repositories and data
/// sources call [ExceptionMapper.map] instead of each hand-rolling a mapper.
class ExceptionMapper {
  ExceptionMapper._();

  static Failure map(Object error) {
    // A raw DioException can still surface from code paths that bypass
    // ApiClient (e.g. FormData uploads); normalise it first.
    final exception =
        error is DioException ? DioExceptionHandler.fromDioError(error) : error;

    if (exception is ServerException) {
      return ServerFailure(
        exception.message,
        statusCode: exception.statusCode,
        code: exception.code,
        field: exception.field,
      );
    }
    if (exception is NetworkException) {
      return NetworkFailure(exception.message, code: exception.code);
    }
    if (exception is CacheException) {
      return CacheFailure(exception.message);
    }
    if (exception is ValidationException) {
      return ValidationFailure(
        exception.message,
        errors: exception.errors,
        code: exception.code,
        field: exception.field,
      );
    }
    if (exception is UnauthorizedException) {
      return UnauthorizedFailure(
        exception.message,
        code: exception.code,
        field: exception.field,
      );
    }
    if (exception is ForbiddenException) {
      return ForbiddenFailure(
        exception.message,
        code: exception.code,
        field: exception.field,
      );
    }
    if (exception is NotFoundException) {
      return NotFoundFailure(exception.message, code: exception.code);
    }
    if (exception is TimeoutException) {
      return TimeoutFailure(exception.message, code: exception.code);
    }
    if (exception is UnknownException) {
      return UnknownFailure(exception.message, code: exception.code);
    }
    return UnknownFailure(exception.toString());
  }
}
