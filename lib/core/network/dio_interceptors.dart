import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:sahely/core/auth/auth_token_keys.dart';
import 'package:sahely/core/network/public_endpoints.dart';

/// Injects `Authorization: Bearer <accessToken>` into requests to protected
/// endpoints.
///
/// [PublicEndpoints] (login, registration, OTP, refresh, KYC) go out without
/// the header: a leftover token from an earlier session has no business on a
/// login or registration call.
class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _storage;

  AuthInterceptor({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // A retried request already carries the freshly refreshed token.
    if (options.headers.containsKey('Authorization') ||
        PublicEndpoints.isPublic(options.path)) {
      return handler.next(options);
    }

    try {
      final token = await _storage.read(key: AuthTokenKeys.accessToken);
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (_) {
      // Storage unavailable (e.g. locked keystore) - continue unauthenticated
      // and let the backend answer with 401.
    }

    handler.next(options);
  }
}
