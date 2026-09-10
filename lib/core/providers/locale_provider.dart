import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocaleProvider extends ChangeNotifier {
  Locale? _locale;
  final _storage = const FlutterSecureStorage();

  Locale? get locale => _locale;

  Future<void> loadLocale() async {
    final savedLanguage = await _storage.read(key: 'app_language');
    if (savedLanguage != null) {
      _locale = Locale(savedLanguage);
    } else {
      _locale = null; // null means use device system language
    }
    notifyListeners();
  }

  Future<void> setLocale(String? languageCode) async {
    if (languageCode == null) {
      await _storage.delete(key: 'app_language');
      _locale = null;
    } else {
      await _storage.write(key: 'app_language', value: languageCode);
      _locale = Locale(languageCode);
    }
    notifyListeners();
  }
}
