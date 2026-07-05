import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  Future<void> checkAuthStatus() async {
    // TODO: Check if user is logged in via token storage
    // _isAuthenticated = await tokenStorage.hasValidToken();
    notifyListeners();
  }

  Future<void> login() async {
    // TODO: Implement login logic
    _isAuthenticated = true;
    notifyListeners();
  }

  Future<void> logout() async {
    // TODO: Implement logout logic
    _isAuthenticated = false;
    notifyListeners();
  }
}
