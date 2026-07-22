import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:sahely/data/models.dart';
import 'package:sahely/data/role_state.dart';

class AuthProvider extends ChangeNotifier {
  static const _tokenKey = 'auth_token';
  static const _roleKey = 'user_role';
  static const _verifiedKey = 'is_verified';

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  /// True once the user has completed all 4 verification steps
  /// (email, phone, ID, payment card). Persisted in secure storage.
  bool _isVerified = false;

  bool get isVerified => _isVerified;

  String? _token;

  String? get token => _token;

  /// Reads token+role from secure storage and updates local state.
  Future<void> checkAuthStatus() async {
    try {
      final storedToken = await _secureStorage.read(key: _tokenKey);
      final storedRole = await _secureStorage.read(key: _roleKey);

      final storedVerified = await _secureStorage.read(key: _verifiedKey);

      if (storedToken != null && storedToken.isNotEmpty) {
        _token = storedToken;
        _isAuthenticated = true;
        _isVerified = storedVerified == 'true';
        // Restore role if present
        if (storedRole != null) {
          RoleState().setRoleFromString(storedRole);
        }
      } else {
        _token = null;
        _isAuthenticated = false;
        _isVerified = false;
      }
    } catch (e) {
      // On any error, treat as not authenticated
      _token = null;
      _isAuthenticated = false;
      _isVerified = false;
    }

    notifyListeners();
  }

  /// Stores token and role in secure storage and marks user as authenticated.
  Future<void> login({required String token, Role role = Role.renter}) async {
    _token = token;
    _isAuthenticated = true;

    try {
      await _secureStorage.write(key: _tokenKey, value: token);
      await _secureStorage.write(key: _roleKey, value: role.label);
    } catch (e) {
      // ignore write errors for now (but still mark authenticated in-memory)
    }

    // Update global role state
    RoleState().setRole(role);

    notifyListeners();
  }

  /// Marks the user as fully verified (all 4 steps complete).
  /// Called by [VerificationCubit] once [VerificationState.isComplete] is true.
  Future<void> setVerified(bool value) async {
    if (_isVerified == value) return;
    _isVerified = value;
    try {
      await _secureStorage.write(key: _verifiedKey, value: value.toString());
    } catch (_) {}
    notifyListeners();
  }

  /// Clears stored token and role and marks user as logged out.
  Future<void> logout() async {
    _token = null;
    _isAuthenticated = false;

    try {
      await _secureStorage.delete(key: _tokenKey);
      await _secureStorage.delete(key: _roleKey);
      await _secureStorage.delete(key: _verifiedKey);
    } catch (e) {
      // ignore
    }

    // Reset role to default (renter)
    RoleState().setRole(Role.renter);

    notifyListeners();
  }
}
