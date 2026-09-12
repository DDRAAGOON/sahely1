import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:sahely/core/auth/auth_token_keys.dart';
import 'package:sahely/core/errors/api_error.dart';
import 'package:sahely/core/network/api_endpoints.dart';
import 'package:sahely/core/network/public_endpoints.dart';

/// Handles `401` -> token refresh -> retry, **at most once per request**.
///
/// On a 401 from a protected endpoint:
///  1. calls `/auth/refresh` with the stored refresh token (concurrent 401s
///     share one in-flight refresh, since the backend rotates the token and a
///     second call would burn it),
///  2. rotates both tokens in secure storage,
///  3. retries the original request once with the new access token,
///  4. if the refresh fails, clears storage and rejects with
///     [RefreshTokenInvalidException] so the app can force a logout.
///
/// Two guards prevent the infinite login loop seen in production logs:
///  * 401s from [PublicEndpoints] (login, registration, OTP, refresh) are
///    passed straight through - there a 401 means wrong credentials or a bad
///    code, which no refresh can fix;
///  * a request that already went through one refresh is never refreshed
///    again; if it still 401s the error surfaces to the caller.
class AutoRefreshInterceptor extends Interceptor {
  /// Marks a request that has already been retried after a refresh.
  static const retriedFlag = 'sahely_auth_retried';

  final Dio _dio;
  final Dio _refreshDio;
  final FlutterSecureStorage _storage;

  Completer<String?>? _refreshCompleter;

  AutoRefreshInterceptor({
    required Dio dio,
    FlutterSecureStorage? storage,
    Dio? refreshDio,
  })  : _dio = dio,
        _storage = storage ?? const FlutterSecureStorage(),
        // A bare Dio so the refresh call skips the auth/refresh interceptors.
        _refreshDio = refreshDio ??
            Dio(
              BaseOptions(
                baseUrl: dio.options.baseUrl,
                connectTimeout: dio.options.connectTimeout,
                receiveTimeout: dio.options.receiveTimeout,
                headers: const {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                },
              ),
            );

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final request = err.requestOptions;

    if (err.response?.statusCode != 401 ||
        PublicEndpoints.isPublic(request.path) ||
        request.path.contains(ApiEndpoints.refresh) ||
        request.extra[retriedFlag] == true) {
      return handler.next(err);
    }

    // A few 401 codes describe a permission problem that a new token cannot
    // solve; everything else on a protected route (TOKEN_MISSING,
    // TOKEN_MALFORMED, TOKEN_EXPIRED, ...) gets exactly one refresh attempt.
    final apiError = ApiError.tryParse(err.response?.data);
    const notRefreshable = {
      'FORBIDDEN',
      'INSUFFICIENT_PERMISSIONS',
      'ACCOUNT_SUSPENDED',
      'ACCOUNT_BANNED',
      'KYC_REQUIRED',
    };
    if (apiError != null && notRefreshable.contains(apiError.code)) {
      return handler.next(err);
    }

    final newAccessToken = await _refreshTokens();
    if (newAccessToken == null) {
      return handler.reject(_buildLogoutError(err));
    }

    try {
      request.headers['Authorization'] = 'Bearer $newAccessToken';
      request.extra[retriedFlag] = true;
      return handler.resolve(await _dio.fetch(request));
    } on DioException catch (retryError) {
      return handler.next(retryError);
    }
  }

  /// Returns the new access token, or `null` when the session is unrecoverable.
  Future<String?> _refreshTokens() {
    final inFlight = _refreshCompleter;
    if (inFlight != null) return inFlight.future;

    final completer = Completer<String?>();
    _refreshCompleter = completer;

    _performRefresh().then((token) {
      _refreshCompleter = null;
      completer.complete(token);
    }).catchError((Object _) {
      _refreshCompleter = null;
      completer.complete(null);
    });

    return completer.future;
  }

  Future<String?> _performRefresh() async {
    final refreshToken = await _storage.read(key: AuthTokenKeys.refreshToken);
    if (refreshToken == null || refreshToken.isEmpty) {
      await _clearTokens();
      return null;
    }

    if (kDebugMode) {
      debugPrint('[SAHELY-AUTH] Access token rejected, refreshing...');
    }

    try {
      final response = await _refreshDio.post(
        ApiEndpoints.refresh,
        data: {'refresh_token': refreshToken},
      );

      final body = response.data;
      final data = body is Map && body['data'] is Map
          ? Map<String, dynamic>.from(body['data'] as Map)
          : (body is Map ? Map<String, dynamic>.from(body) : null);

      final newAccess = _readToken(data, 'access_token', 'accessToken');
      final newRefresh = _readToken(data, 'refresh_token', 'refreshToken');

      if (newAccess == null || newAccess.isEmpty) {
        await _clearTokens();
        return null;
      }

      await _storage.write(key: AuthTokenKeys.accessToken, value: newAccess);
      // The backend rotates refresh tokens; persist the new one or the next
      // refresh fails with an already-consumed token.
      if (newRefresh != null && newRefresh.isNotEmpty) {
        await _storage.write(
            key: AuthTokenKeys.refreshToken, value: newRefresh);
      }

      if (kDebugMode) {
        debugPrint('[SAHELY-AUTH] Token refreshed, retrying once.');
      }
      return newAccess;
    } on DioException catch (e) {
      if (kDebugMode) {
        debugPrint('[SAHELY-AUTH] Refresh failed (${e.response?.statusCode}); '
            'signing out.');
      }
      await _clearTokens();
      return null;
    }
  }

  String? _readToken(Map<String, dynamic>? data, String snake, String camel) {
    final value = data?[snake] ?? data?[camel];
    return value is String ? value : null;
  }

  Future<void> _clearTokens() async {
    await Future.wait([
      _storage.delete(key: AuthTokenKeys.accessToken),
      _storage.delete(key: AuthTokenKeys.refreshToken),
    ]);
  }

  DioException _buildLogoutError(DioException original) {
    return DioException(
      requestOptions: original.requestOptions,
      response: original.response,
      type: DioExceptionType.badResponse,
      error: const RefreshTokenInvalidException(),
    );
  }
}

/// Thrown when the refresh token is invalid or expired.
/// The auth layer catches this to force the user back to the login screen.
class RefreshTokenInvalidException implements Exception {
  const RefreshTokenInvalidException();

  @override
  String toString() => 'RefreshTokenInvalidException';
}
