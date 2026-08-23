import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sahely/data/models.dart';

class RoleState extends ChangeNotifier {
  static final RoleState _instance = RoleState._internal();

  factory RoleState() => _instance;

  RoleState._internal();

  Role _currentRole = Role.renter;

  Role get currentRole => _currentRole;

  static const String _rolePersistenceKey = 'persisted_user_role';

  /// Initializes the role from persistent storage.
  Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedRole = prefs.getString(_rolePersistenceKey);
      if (savedRole != null) {
        _currentRole = Role.values.firstWhere(
          (e) => e.name == savedRole,
          orElse: () => Role.renter,
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading persisted role: $e');
    }
  }

  Future<void> setRole(Role role) async {
    _currentRole = role;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_rolePersistenceKey, role.name);
    } catch (e) {
      debugPrint('Error saving persisted role: $e');
    }
  }

  Future<void> clearPersistedRole() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_rolePersistenceKey);
    } catch (e) {
      debugPrint('Error clearing persisted role: $e');
    }
  }

  void setRoleFromString(String? roleStr) {
    if (roleStr == 'Property Owner') {
      setRole(Role.owner);
    } else if (roleStr == 'Broker') {
      setRole(Role.broker);
    } else {
      setRole(Role.renter);
    }
  }
}
