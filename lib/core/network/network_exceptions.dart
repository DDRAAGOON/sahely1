import 'package:dio/dio.dart';
import 'package:sahely/core/errors/exceptions.dart';

/// Helper to map DioExceptions to Core Exceptions.
class DioExceptionHandler {
  static Exception fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.cancel:
        return const UnknownException('Request to API server was cancelled');
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return const TimeoutException('Connection timeout with API server');
      case DioExceptionType.connectionError:
        return const NetworkException('No internet connection');
      case DioExceptionType.badResponse:
        return _handleError(
          dioError.response?.statusCode,
          dioError.response?.data,
        );
      case DioExceptionType.unknown:
        if (dioError.message?.contains('SocketException') ?? false) {
          return const NetworkException('No internet connection');
        }
        return const UnknownException('Unexpected error occurred');
      default:
        return const UnknownException('Something went wrong');
    }
  }

  static Exception _handleError(int? statusCode, dynamic error) {
    String message = 'Oops something went wrong';
    if (error is Map && error.containsKey('message')) {
      message = error['message'];
    }

    switch (statusCode) {
      case 400:
        return ValidationException(message);
      case 401:
        return UnauthorizedException(message);
      case 403:
        return ForbiddenException(message);
      case 404:
        return NotFoundException(message);
      case 500:
        return const ServerException('Internal server error', statusCode: 500);
      default:
        return ServerException(message, statusCode: statusCode);
    }
  }
}
