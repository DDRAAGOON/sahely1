import 'package:intl/intl.dart';

/// Utility for all monetary display in the Sahely app.
///
/// ⚠️ IMPORTANT: The API returns ALL amounts in **piastres** (1/100 EGP).
/// Always call [fromPiastres] before displaying any amount from the API.
///
/// Currency always uses WESTERN numerals (0-9) even in Arabic locale.
class CurrencyFormatter {
  CurrencyFormatter._();

  static const String _symbol = 'EGP';

  /// Alias kept for backward compatibility.
  static const String defaultSymbol = 'EGP';

  // ── Primary API method ────────────────────────────────────────────────────

  /// Converts a piastres integer from the API to a display string.
  ///
  /// Example: 15000 piastres → "EGP 150"
  /// Example: 150050 piastres → "EGP 1,500.50"
  static String fromPiastres(int piastres) {
    final egp = piastres / 100.0;
    return _format(egp);
  }

  /// Converts piastres and returns just the numeric part (no symbol).
  static String numericFromPiastres(int piastres) {
    final egp = piastres / 100.0;
    return _formatNumber(egp);
  }

  /// Converts piastres to a double EGP value (for calculations).
  static double toEgp(int piastres) => piastres / 100.0;

  // ── Legacy / direct EGP methods ───────────────────────────────────────────

  /// Format an already-converted EGP amount.
  static String format(num egpAmount) => _format(egpAmount);

  static String formatNumber(num egpAmount) => _formatNumber(egpAmount);

  // ── Per-night shorthand ───────────────────────────────────────────────────

  /// "EGP 1,500 / night" — used on property cards.
  static String perNightFromPiastres(int piastres) {
    return '${fromPiastres(piastres)} / night';
  }

  /// "EGP 1,500 / night" — Arabic version (same numerals per spec).
  static String perNightFromPiastresAr(int piastres) {
    return '${fromPiastres(piastres)} / ليلة';
  }

  // ── Internals ─────────────────────────────────────────────────────────────

  static String _format(num amount) {
    return '$_symbol ${_formatNumber(amount)}';
  }

  static String _formatNumber(num amount) {
    // Always use western numerals for currency (spec §1.9)
    final formatter = NumberFormat('#,##0.##', 'en_US');
    return formatter.format(amount);
  }
}
