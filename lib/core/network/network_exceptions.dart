import 'package:dio/dio.dart';

import 'package:sahely/core/errors/api_error.dart';
import 'package:sahely/core/errors/exceptions.dart';

/// Maps a [DioException] onto the app's typed exceptions, preserving the
/// backend's `error.code` / `error.field` so callers can branch on the code and
/// forms can highlight the offending input.
class DioExceptionHandler {
  DioExceptionHandler._();

  static AppException fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.cancel:
        return const UnknownException(
          'Request cancelled',
          code: 'ERR_CANCELLED',
        );

      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.transformTimeout:
        return const TimeoutException(
          'The server took too long to respond. Please try again.',
          code: 'ERR_TIMEOUT',
        );

      case DioExceptionType.connectionError:
        return const NetworkException(
          'No internet connection. Please check your network.',
          code: 'ERR_NETWORK',
        );

      case DioExceptionType.badCertificate:
        return const NetworkException(
          'Could not establish a secure connection.',
          code: 'ERR_SSL',
        );

      case DioExceptionType.badResponse:
        return _fromResponse(dioError.response);

      case DioExceptionType.unknown:
        if (dioError.error is AppException) {
          return dioError.error as AppException;
        }
        if (dioError.message?.contains('SocketException') ?? false) {
          return const NetworkException(
            'No internet connection. Please check your network.',
            code: 'ERR_NETWORK',
          );
        }
        return const UnknownException(
            'Something went wrong. Please try again.');
    }
  }

  static AppException _fromResponse(Response<dynamic>? response) {
    final statusCode = response?.statusCode;
    final apiError = ApiError.tryParse(response?.data);
    final message = apiError?.message ?? _fallbackMessage(response?.data);
    final code = apiError?.code;
    final field = apiError?.field;

    switch (statusCode) {
      case 400:
      case 409:
      case 422:
        return ValidationException(message, code: code, field: field);
      case 401:
        return UnauthorizedException(message, code: code, field: field);
      case 403:
        return ForbiddenException(message, code: code, field: field);
      case 404:
        return NotFoundException(message, code: code);
      case 429:
        return ServerException(
          message,
          statusCode: statusCode,
          code: code ?? 'ERR_RATE_LIMITED',
        );
      default:
        return ServerException(
          message,
          statusCode: statusCode,
          code: code,
          field: field,
        );
    }
  }

  static String _fallbackMessage(dynamic body) {
    if (body is Map) {
      final message = body['message'];
      if (message is List) return message.join(', ');
      if (message != null) return '$message';
    }
    return 'Something went wrong. Please try again.';
  }
}
