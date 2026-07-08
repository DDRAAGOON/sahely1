import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Extension for convenient access to MediaQuery and Theme from [BuildContext].
extension ContextExtensions on BuildContext {
  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colors => Theme.of(this).colorScheme;
  
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
  
  void showSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

/// Extension for formatting strings.
extension StringExtensions on String {
  String get capitalize => length > 0 ? "${this[0].toUpperCase()}${substring(1)}" : "";
  
  bool get isValidEmail => RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  ).hasMatch(this);
}

/// Extension for numeric formatting.
extension NumberExtensions on num {
  String get toCurrency => NumberFormat.currency(
    symbol: 'EGP ',
    decimalDigits: 0,
  ).format(this);
}
