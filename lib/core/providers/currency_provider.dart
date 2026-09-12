import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sahely/core/utils/currency_formatter.dart';
import 'package:sahely/core/providers/safe_notifier.dart';

class CurrencyProvider extends ChangeNotifier with SafeNotifier {
  String _selectedCurrency = 'EGP';
  String _symbol = 'EGP';
  final _storage = const FlutterSecureStorage();

  String get selectedCurrency => _selectedCurrency;

  String get symbol => _symbol;

  static const Map<String, String> _symbols = {
    'EGP': 'EGP',
    'USD': '\$',
    'EUR': '€',
    'GBP': '£',
    'SAR': 'ريال',
    'AED': 'د.إ',
  };

  Future<void> loadCurrency() async {
    _selectedCurrency = await _storage.read(key: 'app_currency') ?? 'EGP';
    _symbol = _symbols[_selectedCurrency] ?? 'EGP';
    notifyListeners();
  }

  Future<void> setCurrency(String currencyCode) async {
    await _storage.write(key: 'app_currency', value: currencyCode);
    _selectedCurrency = currencyCode;
    _symbol = _symbols[currencyCode] ?? '';
    notifyListeners();
  }

  // Helper to format price
  String formatPrice(double priceInEGP) {
    // In a real app, you'd have exchange rates here
    // For now, we'll just show the symbol and the value
    double convertedPrice = priceInEGP;
    if (_selectedCurrency == 'USD') convertedPrice = priceInEGP / 50;
    if (_selectedCurrency == 'EUR') convertedPrice = priceInEGP / 54;

    return '$symbol ${CurrencyFormatter.formatNumber(convertedPrice.round())}';
  }
}
