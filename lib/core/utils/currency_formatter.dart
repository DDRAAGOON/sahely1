import 'package:intl/intl.dart';

class CurrencyFormatter {
  static const String defaultSymbol = 'EGP';

  static String format(int price) {
    return '$defaultSymbol ${formatNumber(price)}';
  }

  static String formatNumber(num number) {
    final formatter = NumberFormat.decimalPattern();
    return formatter.format(number);
  }
}
