import 'dart:core';

class SecurityUtil {
  SecurityUtil._();

  /// Sanitizes raw input to prevent HTML/Script XSS injections at the UI level.
  static String sanitizeInput(String input) {
    final htmlExp = RegExp(r'<[^>]*>', multiLine: true);
    return input.replaceAll(htmlExp, '').trim();
  }

  /// Strictly validates email formatting.
  static bool isValidEmail(String email) {
    final emailExp = RegExp(
      r'^[a-zA-Z0-9.!#$%&'r'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$',
    );
    return emailExp.hasMatch(email.trim());
  }

  /// Strictly validates Egyptian phone numbers (10 digits after +20 prefix, beginning with 10, 11, 12, or 15).
  static bool isValidEgyptianPhone(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'\D'), '');
    final phoneExp = RegExp(r'^(10|11|12|15)\d{8}$');
    return phoneExp.hasMatch(cleaned);
  }

  /// Validates password strength (min 8 characters with at least one number).
  static bool isValidPassword(String password) {
    if (password.length < 8) return false;
    final hasNum = password.contains(RegExp(r'\d'));
    return hasNum;
  }
}
