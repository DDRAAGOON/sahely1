import 'package:flutter/material.dart';

import 'models.dart';

class RoleState extends ChangeNotifier {
  static final RoleState _instance = RoleState._internal();

  factory RoleState() => _instance;

  RoleState._internal();

  Role _currentRole = Role.renter;

  Role get currentRole => _currentRole;

  void setRole(Role role) {
    _currentRole = role;
    notifyListeners();
  }

  void setRoleFromString(String? roleStr) {
    if (roleStr == 'Property Owner') {
      _currentRole = Role.owner;
    } else if (roleStr == 'Broker') {
      _currentRole = Role.broker;
    } else {
      _currentRole = Role.renter;
    }
    notifyListeners();
  }
}
