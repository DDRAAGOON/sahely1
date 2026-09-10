import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sahely/core/config/app_config.dart';
import 'package:sahely/core/network/api_client.dart';
import 'package:sahely/core/network/api_envelope.dart';
import 'package:sahely/core/network/api_endpoints.dart';
import 'package:sahely/data/models.dart';
import 'package:dio/dio.dart';
import 'package:sahely/features/auth/data/auth_api.dart' show AuthApiException;

class AuthResponse {
  final String token;
  final Role role;

  AuthResponse({required this.token, required this.role});
}

/// Auth service used by the sign-in screen.
///
/// With [AppConfig.useRemoteApi] enabled this hits the real backend
/// (`POST /auth/login`), persists the access/refresh tokens in secure storage
/// (the Dio `AuthInterceptor` reads `auth_token` on every request) and maps
/// the backend role to the app's [Role]. Otherwise it falls back to the
/// original offline mock behaviour.
class MockAuthService {
  final ApiClient _api = ApiClient();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<AuthResponse> signIn(String email, String password) async {
    if (!AppConfig.useRemoteApi) return _mockSignIn(email, password);

    try {
      final res = await _api.post(ApiEndpoints.login, data: {
        'email': email,
        'password': password,
      });
      final data = unwrapData(res.data) as Map<String, dynamic>;
      final accessToken = '${data['access_token'] ?? ''}';
      final user = (data['user'] as Map?) ?? const {};

      // Persist tokens — the interceptor picks auth_token up automatically.
      try {
        await _storage.write(key: 'auth_token', value: accessToken);
        if (data['refresh_token'] != null) {
          await _storage.write(
              key: 'refresh_token', value: '${data['refresh_token']}');
        }
      } catch (_) {}

      final backendRole =
          '${user['role'] ?? data['role'] ?? 'renter'}'.toLowerCase();
      final role = switch (backendRole) {
        'owner' => Role.owner,
        'broker' => Role.broker,
        _ => Role.renter,
      };
      return AuthResponse(token: accessToken, role: role);
    } catch (e) {
      if (e is AuthApiException) rethrow;
      int? status;
      String? code;
      Map<String, dynamic>? data;
      var msg = 'Something went wrong. Please try again.';
      
      if (e is DioException) {
        status = e.response?.statusCode;
        
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.sendTimeout ||
            e.type == DioExceptionType.connectionError) {
          msg = 'No internet connection — please check your network.';
          code = 'ERR_NETWORK';
        } else if (status == 401 || status == 403 || status == 404) {
          msg = 'Incorrect email or password.';
          code = 'ERR_AUTH_INVALID_CREDENTIALS';
        } else if (status != null && status >= 500) {
          msg = 'Something went wrong on our side. Please try again.';
          code = 'ERR_INTERNAL';
        }

        final body = e.response?.data;
        if (body is Map) {
          final err = body['error'];
          final serverMsg = (err is Map && err['message'] != null)
              ? '${err['message']}'
              : '${body['message'] ?? ''}';
          if (serverMsg.isNotEmpty && serverMsg != 'null') {
              msg = serverMsg;
          }
          
          // Extract error code from response
          if (err is Map) {
            code = err['code'] as String? ?? code;
            data = err['data'] as Map<String, dynamic>? ?? data;
          } else if (body['code'] != null) {
            code = body['code'] as String?;
          }
          
          // Extract additional data for suspension/ban details
          if (err is Map && err['data'] != null) {
            data = err['data'] as Map<String, dynamic>;
          }
        }
      }
      throw AuthApiException(msg, code: code, data: data, statusCode: status);
    }
  }

  Future<AuthResponse> _mockSignIn(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 250));
    
    if (email.isEmpty || password.isEmpty) {
      throw AuthApiException('Email and password cannot be empty.', 
          code: 'ERR_VALIDATION');
    }
    
    // Simulate invalid credentials in mock mode if it's not a common test password
    if (password != 'password123' && password != 'TestPess123!') {
      throw AuthApiException('Incorrect email or password.', 
          code: 'ERR_AUTH_INVALID_CREDENTIALS');
    }
    final lower = email.toLowerCase();
    final role = lower.contains('broker')
        ? Role.broker
        : (lower.contains('owner') ? Role.owner : Role.renter);
    return AuthResponse(token: 'mock-${role.name}-token', role: role);
  }

  /// Clears stored tokens (called on logout).
  Future<void> clearTokens() async {
    try {
      await _storage.delete(key: 'auth_token');
      await _storage.delete(key: 'refresh_token');
    } catch (_) {}
  }
}
