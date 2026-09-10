import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sahely/core/network/api_client.dart';
import 'package:sahely/core/network/api_envelope.dart';
import 'package:sahely/core/network/api_endpoints.dart';
import 'package:dio/dio.dart';
import 'package:sahely/data/models.dart';
import '../mock_auth_service.dart' show AuthResponse;

class AuthApiException implements Exception {
  final String message;
  final String? code;
  final Map<String, dynamic>? data;
  final int? statusCode;
  AuthApiException(this.message, {this.code, this.data, this.statusCode});
  @override
  String toString() => message;
}

/// Real authentication service driving login AND the multi-step registration.
class AuthApiService {
  final ApiClient _api = ApiClient();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static String? _extractMessage(dynamic body) {
    if (body is Map) {
      final err = body['error'];
      if (err is Map && err['message'] != null) return '${err['message']}';
      if (body['message'] != null) return '${body['message']}';
    }
    return null;
  }

  AuthApiException _guard(Object e) {
    if (e is AuthApiException) return e;
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
    return AuthApiException(msg, code: code, data: data, statusCode: status);
  }

  // ── Login ────────────────────────────────────────────────────────────────

  Future<AuthResponse> login(String email, String password) async {
    try {
      final res = await _api.post(ApiEndpoints.login, data: {
        'email': email,
        'password': password,
      });
      final data = asMap(unwrapData(res.data));
      final accessToken = '${data['access_token'] ?? ''}';
      final user = asMap(data['user']);

      await _persistTokens(accessToken, '${data['refresh_token'] ?? ''}');

      final backendRole = '${user['role'] ?? data['role'] ?? 'renter'}'
          .toLowerCase();
      final role = switch (backendRole) {
        'owner' => Role.owner,
        'broker' => Role.broker,
        _ => Role.renter,
      };
      return AuthResponse(token: accessToken, role: role);
    } catch (e) {
      throw _guard(e);
    }
  }

  Future<void> logout(String refreshToken) async {
    try {
      await _api.post(ApiEndpoints.logout, data: {'refresh_token': refreshToken});
    } catch (_) {}
    await clearTokens();
  }

  // ── Registration (session-based, 5 steps) ───────────────────────────────

  /// Step 1 — pick a role, opens a registration session.
  Future<String> registerStep1(Role role) async {
    try {
      final res =
          await _api.post(ApiEndpoints.registerStep1, data: {'role': role.name});
      final data = asMap(unwrapData(res.data));
      return '${data['session_id']}';
    } catch (e) {
      throw _stepError(e);
    }
  }

  /// Step 2 — account details; backend emails the verification OTP.
  Future<void> registerStep2({
    required String sessionId,
    required String fullName,
    required String email,
    required String phone,
    required String dateOfBirth,
    required String password,
    required String confirmPassword,
    bool termsAccepted = true,
    String? referralCode,
  }) async {
    try {
      final res = await _api.post(
        ApiEndpoints.registerStep2,
        queryParameters: {'sessionId': sessionId},
        data: {
          'full_name': fullName,
          'email': email,
          'phone': phone,
          'date_of_birth': dateOfBirth,
          'password': password,
          'confirm_password': confirmPassword,
          'terms_accepted': termsAccepted,
          if (referralCode != null && referralCode.isNotEmpty)
            'referral_code': referralCode,
        },
      );
      unwrapData(res.data);
    } catch (e) {
      throw _stepError(e);
    }
  }

  /// Step 3 — verify the emailed OTP.
  Future<void> verifyEmailOtp(String sessionId, String otp) async {
    try {
      final res = await _api.post(
        ApiEndpoints.registerStep3Verify,
        queryParameters: {'sessionId': sessionId},
        data: {'otp': otp},
      );
      unwrapData(res.data);
    } catch (e) {
      throw _stepError(e);
    }
  }

  /// Step 4a — send the phone OTP (Twilio; dev test-mode accepts 000000).
  Future<String> sendPhoneOtp(String sessionId) async {
    try {
      final res = await _api.post(
        ApiEndpoints.registerStep4SendPhoneOtp,
        queryParameters: {'sessionId': sessionId},
      );
      final data = asMap(unwrapData(res.data));
      return '${data['test_hint'] ?? ''}';
    } catch (e) {
      throw _stepError(e);
    }
  }

  /// Step 4b — verify the phone OTP.
  Future<void> verifyPhoneOtp(String sessionId, String otp) async {
    try {
      final res = await _api.post(
        ApiEndpoints.registerStep4VerifyPhone,
        queryParameters: {'sessionId': sessionId},
        data: {'otp': otp},
      );
      unwrapData(res.data);
    } catch (e) {
      throw _stepError(e);
    }
  }

  // ── helpers ──────────────────────────────────────────────────────────────

  AuthApiException _stepError(Object e) {
    if (e is AuthApiException) return e;
    final msg = _extractMessage(
        (e as dynamic).response?.data ?? (e as dynamic).error?.data);
    final status = (e as dynamic).response?.statusCode as int?;
    return AuthApiException(
      msg ?? 'Something went wrong — please try again',
      statusCode: status,
    );
  }

  Future<void> _persistTokens(String access, String refresh) async {
    try {
      if (access.isNotEmpty) {
        await _storage.write(key: 'auth_token', value: access);
      }
      if (refresh.isNotEmpty) {
        await _storage.write(key: 'refresh_token', value: refresh);
      }
    } catch (_) {}
  }

  Future<void> clearTokens() async {
    try {
      await _storage.delete(key: 'auth_token');
      await _storage.delete(key: 'refresh_token');
    } catch (_) {}
  }
}
