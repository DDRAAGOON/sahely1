import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Detects offline state before each request and throws a DioException
/// with [DioExceptionType.connectionError] if there is no internet.
///
/// This is checked via socket lookup so it works even when WiFi is connected
/// but there's no actual internet (captive portal, etc.).
class ConnectivityInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final hasConnection = await _checkConnectivity();

    if (!hasConnection) {
      if (kDebugMode) {
        debugPrint(
            '[SAHELY-NET] 📵 Device is OFFLINE — request blocked: ${options.path}');
      }
      return handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
          error: const SocketException('No internet connection'),
        ),
      );
    }

    handler.next(options);
  }

  Future<bool> _checkConnectivity() async {
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 3));
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    } catch (_) {
      return false;
    }
  }
}
