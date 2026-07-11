import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../data/models.dart';
import '../../data/role_state.dart';

class AuthProvider extends ChangeNotifier {
  static const _tokenKey = 'auth_token';
  static const _roleKey = 'user_role';

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  String? _token;
  String? get token => _token;

  /// Reads token+role from secure storage and updates local state.
  Future<void> checkAuthStatus() async {
    try {
      final storedToken = await _secureStorage.read(key: _tokenKey);
      final storedRole = await _secureStorage.read(key: _roleKey);

      if (storedToken != null && storedToken.isNotEmpty) {
        _token = storedToken;
        _isAuthenticated = true;
        // Restore role if present
        if (storedRole != null) {
          RoleState().setRoleFromString(storedRole);
        }
      } else {
        _token = null;
        _isAuthenticated = false;
      }
    } catch (e) {
      // On any error, treat as not authenticated
      _token = null;
      _isAuthenticated = false;
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

  /// Clears stored token and role and marks user as logged out.
  Future<void> logout() async {
    _token = null;
    _isAuthenticated = false;

    try {
      await _secureStorage.delete(key: _tokenKey);
      await _secureStorage.delete(key: _roleKey);
    } catch (e) {
      // ignore
    }

    // Reset role to default (renter)
    RoleState().setRole(Role.renter);

    notifyListeners();
  }
}
