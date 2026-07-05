import 'package:flutter/material.dart';

class NavigationProvider extends ChangeNotifier {
  int _currentTabIndex = 0;

  int get currentTabIndex => _currentTabIndex;

  void setTab(int index) {
    _currentTabIndex = index;
    notifyListeners();
  }
}
