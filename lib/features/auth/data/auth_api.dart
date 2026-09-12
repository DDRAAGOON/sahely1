import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:sahely/core/auth/auth_token_keys.dart';
import 'package:sahely/core/errors/exceptions.dart';
import 'package:sahely/core/network/api_client.dart';
import 'package:sahely/core/network/api_endpoints.dart';
import 'package:sahely/core/network/api_envelope.dart';
import 'package:sahely/data/models.dart';

/// Result of a successful sign-in: the access token and the account role.
class AuthResponse {
  final String token;
  final Role role;

  AuthResponse({required this.token, required this.role});
}

/// Error raised by [AuthApiService], carrying the backend's machine-readable
/// `error.code` and the offending `field` for inline form highlighting.
class AuthApiException implements Exception {
  final String message;
  final String? code;
  final String? field;
  final Map<String, dynamic>? data;
  final int? statusCode;

  const AuthApiException(
    this.message, {
    this.code,
    this.field,
    this.data,
    this.statusCode,
  });

  @override
  String toString() => message;
}

/// Full client for the `auth` module.
///
/// Covers login, the eight-step registration flow, OTP, password management,
/// Google sign-in and the post-login verification submissions. The Google
/// *callback* is a browser redirect handled by the backend and is never
/// called from here.
class AuthApiService {
  final ApiClient _api;
  final FlutterSecureStorage _storage;

  AuthApiService({ApiClient? apiClient, FlutterSecureStorage? storage})
      : _api = apiClient ?? ApiClient(),
        _storage = storage ?? const FlutterSecureStorage();

  // -- Login / session --------------------------------------------------------

  Future<AuthResponse> login(String email, String password) async {
    final session = await loginDetailed(email, password);
    return AuthResponse(
      token: '${session['accessToken'] ?? session['access_token'] ?? ''}',
      role: _role('${asMap(session['user'])['role'] ?? session['role'] ?? ''}'),
    );
  }

  /// Same call as [login] but returns the whole session payload
  /// (tokens **and** the user object), which the repository layer needs to
  /// build a complete [AuthEntity]. Tokens are persisted either way.
  Future<Map<String, dynamic>> loginDetailed(
    String email,
    String password,
  ) async {
    try {
      final res = await _api.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );
      final data = asMap(unwrapData(res.data));
      await _handleSession(data);
      return data;
    } catch (e) {
      throw _guard(e);
    }
  }

  /// Google sign-in for mobile: the ID token comes from the native SDK.
  Future<AuthResponse> loginWithGoogle({
    required String idToken,
    required String platform,
    String? sessionId,
  }) async {
    try {
      final res = await _api.post(
        ApiEndpoints.googleMobile,
        data: {
          'idToken': idToken,
          'platform': platform,
          if (sessionId != null) 'session_id': sessionId,
        },
      );
      return _handleSession(asMap(unwrapData(res.data)));
    } catch (e) {
      throw _guard(e);
    }
  }

  /// Ends this session. Tokens are cleared locally even if the call fails, so
  /// the user is never left signed in against a revoked session.
  Future<void> logout([String? refreshToken]) async {
    try {
      final token =
          refreshToken ?? await _storage.read(key: AuthTokenKeys.refreshToken);
      if (token != null && token.isNotEmpty) {
        await _api.post(ApiEndpoints.logout, data: {'refresh_token': token});
      }
    } catch (_) {
      // Already signed out server-side, or offline - fall through to clearing.
    } finally {
      await clearTokens();
    }
  }

  /// Ends every session on every device.
  Future<void> logoutAll() async {
    try {
      await _api.post(ApiEndpoints.logoutAll);
    } catch (e) {
      throw _guard(e);
    } finally {
      await clearTokens();
    }
  }

  // -- Registration (session based, run in order) -----------------------------

  /// Step 1 - pick a role; opens a registration session.
  Future<String> registerStep1(Role role) async {
    try {
      final res = await _api.post(
        ApiEndpoints.registerStep1,
        data: {'role': role.name},
      );
      final data = asMap(unwrapData(res.data));
      return '${data['session_id'] ?? data['sessionId'] ?? ''}';
    } catch (e) {
      throw _guard(e);
    }
  }

  /// Step 2 - account details; the backend emails the verification OTP.
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
        queryParameters: _session(sessionId),
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
      throw _guard(e);
    }
  }

  /// Step 3 - verify the emailed OTP.
  Future<void> verifyEmailOtp(String sessionId, String otp) async {
    try {
      final res = await _api.post(
        ApiEndpoints.registerStep3Verify,
        queryParameters: _session(sessionId),
        data: {'otp': otp},
      );
      unwrapData(res.data);
    } catch (e) {
      throw _guard(e);
    }
  }

  /// Step 4a - send the phone OTP. This step cannot be skipped.
  Future<String> sendPhoneOtp(String sessionId) async {
    try {
      final res = await _api.post(
        ApiEndpoints.registerStep4SendPhoneOtp,
        queryParameters: _session(sessionId),
      );
      final data = asMap(unwrapData(res.data));
      return '${data['test_hint'] ?? ''}';
    } catch (e) {
      throw _guard(e);
    }
  }

  /// Step 4b - verify the phone OTP.
  Future<void> verifyPhoneOtp(String sessionId, String otp) async {
    try {
      final res = await _api.post(
        ApiEndpoints.registerStep4VerifyPhone,
        queryParameters: _session(sessionId),
        data: {'otp': otp},
      );
      unwrapData(res.data);
    } catch (e) {
      throw _guard(e);
    }
  }

  // -- Standalone OTP ---------------------------------------------------------

  /// Generic OTP for a signed-in user. [channel] is `sms` or `email`.
  Future<void> sendOtp({required String channel, required String purpose}) =>
      _call(
        () => _api.post(
          ApiEndpoints.otpSend,
          data: {'channel': channel, 'purpose': purpose},
        ),
      );

  Future<void> verifyOtp({required String code, required String purpose}) =>
      _call(
        () => _api.post(
          ApiEndpoints.otpVerify,
          data: {'code': code, 'purpose': purpose},
        ),
      );

  /// Phone OTP addressed by number (used when changing a phone number).
  Future<void> sendOtpToPhone(String phoneNumber) => _call(
        () => _api.post(
          ApiEndpoints.sendOtpOnPhoneNumber,
          data: {'phoneNumber': phoneNumber},
        ),
      );

  Future<void> verifyOtpOnPhone({
    required String phoneNumber,
    required String code,
  }) =>
      _call(
        () => _api.post(
          ApiEndpoints.verifyOtpOnPhoneNumber,
          data: {'phoneNumber': phoneNumber, 'code': code},
        ),
      );

  // -- Passwords --------------------------------------------------------------

  /// Sends a reset code to the address, if an account exists.
  Future<void> requestPasswordReset(String email) => _call(
        () => _api.post(
          ApiEndpoints.passwordResetRequest,
          data: {'email': email},
        ),
      );

  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) =>
      _call(
        () => _api.post(
          ApiEndpoints.passwordReset,
          data: {
            'email': email,
            'code': code,
            'new_password': newPassword,
          },
        ),
      );

  /// Changing the password signs every other device out.
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) =>
      _call(
        () => _api.post(
          ApiEndpoints.passwordChange,
          data: {
            'current_password': currentPassword,
            'new_password': newPassword,
          },
        ),
      );

  // -- Token helpers ----------------------------------------------------------

  Future<String?> readAccessToken() =>
      _storage.read(key: AuthTokenKeys.accessToken);

  Future<String?> readRefreshToken() =>
      _storage.read(key: AuthTokenKeys.refreshToken);

  Future<bool> get isSignedIn async {
    final token = await readAccessToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> clearTokens() async {
    try {
      await Future.wait([
        _storage.delete(key: AuthTokenKeys.accessToken),
        _storage.delete(key: AuthTokenKeys.refreshToken),
      ]);
    } catch (_) {
      // Keystore unavailable - nothing more we can do locally.
    }
  }

  // -- Internals --------------------------------------------------------------

  /// Persists the token pair and maps the payload onto [AuthResponse].
  Future<AuthResponse> _handleSession(Map<String, dynamic> data) async {
    final accessToken = '${data['accessToken'] ?? data['access_token'] ?? ''}';
    final refreshToken =
        '${data['refreshToken'] ?? data['refresh_token'] ?? ''}';

    if (accessToken.isEmpty) {
      throw const AuthApiException(
        'Sign-in succeeded but no session token was returned.',
        code: 'ERR_AUTH_NO_TOKEN',
      );
    }

    await _persistTokens(accessToken, refreshToken);

    final user = asMap(data['user']);
    return AuthResponse(
      token: accessToken,
      role: _role('${user['role'] ?? data['role'] ?? ''}'),
    );
  }

  Future<void> _persistTokens(String access, String refresh) async {
    try {
      if (access.isNotEmpty) {
        await _storage.write(key: AuthTokenKeys.accessToken, value: access);
      }
      if (refresh.isNotEmpty) {
        await _storage.write(key: AuthTokenKeys.refreshToken, value: refresh);
      }
    } catch (_) {
      // Writing failed (locked keystore); the session lives for this run only.
    }
  }

  static Role _role(String backendRole) => switch (backendRole.toLowerCase()) {
        'owner' => Role.owner,
        'broker' => Role.broker,
        _ => Role.renter,
      };

  /// The registration session id travels as a query parameter on every step,
  /// which is how the backend correlates the eight-step flow.
  static Map<String, dynamic> _session(String sessionId) =>
      sessionId.isEmpty ? const {} : {'sessionId': sessionId};

  Future<void> _call(Future<dynamic> Function() request) async {
    try {
      final res = await request();
      unwrapData(res.data);
    } catch (e) {
      throw _guard(e);
    }
  }

  /// Normalises anything thrown into an [AuthApiException] with a message the
  /// UI can show and a code it can branch on.
  AuthApiException _guard(Object e) {
    if (e is AuthApiException) return e;

    if (e is AppException) {
      final message = e is UnauthorizedException && e.code == null
          ? 'Incorrect email or password.'
          : e.message;
      final code = e.code ??
          (e is UnauthorizedException ? 'ERR_AUTH_INVALID_CREDENTIALS' : null);
      return AuthApiException(
        message,
        code: code,
        field: e.field,
        statusCode: e is ServerException ? e.statusCode : null,
      );
    }

    if (e is DioException) {
      return AuthApiException(
        e.message ?? 'Network error',
        code: 'ERR_NETWORK',
        statusCode: e.response?.statusCode,
      );
    }

    return const AuthApiException(
      'Something went wrong. Please try again.',
      code: 'ERR_UNKNOWN',
    );
  }
}
