import 'package:sahely/core/auth/auth_token_keys.dart';
import 'package:sahely/core/security/storage/secure_storage_service.dart';

/// DI-friendly wrapper around the session tokens.
///
/// The key names come from [AuthTokenKeys] so this and the Dio interceptors
/// can never drift apart.
class TokenStorage {
  final SecureStorageService _secureStorage;

  TokenStorage(this._secureStorage);

  static const String _keyAccessToken = AuthTokenKeys.accessToken;
  static const String _keyRefreshToken = AuthTokenKeys.refreshToken;

  /// Save access token
  Future<void> saveAccessToken(String token) async {
    await _secureStorage.write(key: _keyAccessToken, value: token);
  }

  /// Save refresh token
  Future<void> saveRefreshToken(String token) async {
    await _secureStorage.write(key: _keyRefreshToken, value: token);
  }

  /// Save both tokens at once
  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await Future.wait([
      saveAccessToken(accessToken),
      saveRefreshToken(refreshToken),
    ]);
  }

  /// Get access token
  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: _keyAccessToken);
  }

  /// Get refresh token
  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: _keyRefreshToken);
  }

  /// Check if access token exists
  Future<bool> hasAccessToken() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  /// Check if refresh token exists
  Future<bool> hasRefreshToken() async {
    final token = await getRefreshToken();
    return token != null && token.isNotEmpty;
  }

  /// Clear access token
  Future<void> clearAccessToken() async {
    await _secureStorage.delete(key: _keyAccessToken);
  }

  /// Clear refresh token
  Future<void> clearRefreshToken() async {
    await _secureStorage.delete(key: _keyRefreshToken);
  }

  /// Clear all tokens
  Future<void> clearAll() async {
    await Future.wait([
      clearAccessToken(),
      clearRefreshToken(),
    ]);
  }

  /// Get both tokens as a map
  Future<Map<String, String?>> getAllTokens() async {
    return {
      'access_token': await getAccessToken(),
      'refresh_token': await getRefreshToken(),
    };
  }
}
