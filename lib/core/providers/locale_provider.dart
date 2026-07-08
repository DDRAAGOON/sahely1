import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');
  final _storage = const FlutterSecureStorage();

  Locale get locale => _locale;

  Future<void> loadLocale() async {
    final savedLanguage = await _storage.read(key: 'app_language') ?? 'en';
    _locale = Locale(savedLanguage);
    notifyListeners();
  }

  Future<void> setLocale(String languageCode) async {
    await _storage.write(key: 'app_language', value: languageCode);
    _locale = Locale(languageCode);
    notifyListeners();
  }
}
