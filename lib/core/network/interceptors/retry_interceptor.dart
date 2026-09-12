import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Retries failed requests up to [maxRetries] times with exponential back-off.
///
/// Retries only on transient errors: connection timeout, receive timeout,
/// server errors (5xx). Does NOT retry on client errors (4xx) or cancellations.
class RetryInterceptor extends Interceptor {
  final Dio _dio;
  final int maxRetries;
  final Duration baseDelay;

  RetryInterceptor({
    required Dio dio,
    this.maxRetries = 3,
    this.baseDelay = const Duration(seconds: 1),
  }) : _dio = dio;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final attempt = err.requestOptions.extra['_retryCount'] as int? ?? 0;

    final shouldRetry = _isRetryable(err) && attempt < maxRetries;

    if (!shouldRetry) return handler.next(err);

    final delay = baseDelay * (1 << attempt); // 1s, 2s, 4s

    if (kDebugMode) {
      debugPrint(
          '[SAHELY-RETRY] ⟳ Attempt ${attempt + 1}/$maxRetries for ${err.requestOptions.path} (delay: ${delay.inSeconds}s)');
    }

    await Future.delayed(delay);

    // Increment retry count in options extra
    final options = err.requestOptions;
    options.extra['_retryCount'] = attempt + 1;

    try {
      final response = await _dio.fetch(options);
      return handler.resolve(response);
    } on DioException catch (retryErr) {
      return handler.next(retryErr);
    }
  }

  bool _isRetryable(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.connectionError:
        return true;
      case DioExceptionType.badResponse:
        final status = err.response?.statusCode ?? 0;
        return status >= 500 && status < 600;
      default:
        return false;
    }
  }
}
