import 'package:intl/intl.dart';

/// Utility class for formatting data types.
class AppFormatters {
  AppFormatters._();

  /// Formats a number as a human-readable string (e.g., 1000 -> 1,000).
  static String formatNumber(num number) {
    return NumberFormat('#,###').format(number);
  }

  /// Capitalizes the first letter of a string.
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return '${text[0].toUpperCase()}${text.substring(1)}';
  }

  /// Masks a phone number for privacy (e.g., +201234567890 -> +20*******890).
  static String maskPhone(String phone) {
    if (phone.length < 7) return phone;
    return '${phone.substring(0, 3)}*******${phone.substring(phone.length - 3)}';
  }
}
