import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _storage;

  AuthInterceptor({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _storage.read(key: 'auth_token');

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    super.onRequest(options, handler);
  }
}

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('--> ${options.method.toUpperCase()} ${options.baseUrl}${options.path}');
      debugPrint('Headers: ${options.headers}');
      debugPrint('Query Parameters: ${options.queryParameters}');
      if (options.data != null) {
        debugPrint('Body: ${options.data}');
      }
      debugPrint('--> END ${options.method.toUpperCase()}');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('<-- ${response.statusCode} ${response.requestOptions.baseUrl}${response.requestOptions.path}');
      debugPrint('Headers: ${response.headers}');
      debugPrint('Response: ${response.data}');
      debugPrint('<-- END HTTP');
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('<-- ERROR ${err.response?.statusCode} ${err.requestOptions.baseUrl}${err.requestOptions.path}');
      debugPrint('Message: ${err.message}');
      debugPrint('Error Data: ${err.response?.data}');
      debugPrint('<-- END ERROR');
    }
    super.onError(err, handler);
  }
}
