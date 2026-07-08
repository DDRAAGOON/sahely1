import 'package:intl/intl.dart';

/// Utility class for date and time manipulations.
class AppDateUtils {
  AppDateUtils._();

  /// Returns a formatted date string (e.g., Jun 21, 2026).
  static String formatDate(DateTime date) {
    return DateFormat.yMMMd().format(date);
  }

  /// Returns a formatted range of dates (e.g., Jun 21 – 25).
  static String formatDateRange(DateTime start, DateTime end) {
    final startMonth = DateFormat.MMM().format(start);
    final endMonth = DateFormat.MMM().format(end);
    
    if (startMonth == endMonth) {
      return '$startMonth ${start.day} – ${end.day}';
    } else {
      return '$startMonth ${start.day} – $endMonth ${end.day}';
    }
  }

  /// Checks if a date is today.
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }
}
