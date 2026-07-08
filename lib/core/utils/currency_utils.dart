import 'package:intl/intl.dart';

/// Utility class for currency formatting and calculations.
class CurrencyUtils {
  CurrencyUtils._();

  /// Formats a numeric value to EGP currency string (e.g., 4500 -> EGP 4,500).
  static String formatEGP(num amount) {
    return NumberFormat.currency(
      symbol: 'EGP ',
      decimalDigits: 0,
      locale: 'en_US',
    ).format(amount);
  }

  /// Formats a value representing piastres (subunit) to EGP (e.g., 450000 -> EGP 4,500).
  static String formatPiastresToEGP(int piastres) {
    return formatEGP(piastres / 100);
  }

  /// Extracts the numeric value from a currency string.
  static double parseCurrency(String amount) {
    return double.tryParse(amount.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
  }
}
