import 'package:dio/dio.dart';
import '../constants/app_constants.dart';
import '../storage/secure_storage.dart';

/// Interceptor for adding Auth tokens to requests and handling global errors.
class ApiInterceptor extends Interceptor {
  final SecureStorage _secureStorage;

  ApiInterceptor(this._secureStorage);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // 1. Get the cached token from secure storage
    final token = await _secureStorage.read(AppConstants.tokenKey);

    // 2. Add Authorization header if token exists
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // 3. Set common headers
    options.headers['Content-Type'] = 'application/json';
    options.headers['Accept'] = 'application/json';

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Global Error Handling Logic
    switch (err.response?.statusCode) {
      case 401:
        // Handle Unauthorized (e.g., Logout user or refresh token)
        break;
      case 403:
        break;
      case 500:
        break;
    }
    return handler.next(err);
  }
}
