class CurrencyFormatter {
  static String format(int piastres) {
    final egp = piastres / 100;
    return 'EGP ${egp.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    )}';
  }
}
