import 'package:flutter/material.dart';

class AppLocalizations {
  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  final Map<String, String> _localizedStrings;

  AppLocalizations(this._localizedStrings);

  String get language => _localizedStrings['language'] ?? 'Language';
  String get chooseLanguage => _localizedStrings['chooseLanguage'] ?? 'Choose your app language';
  String get save => _localizedStrings['save'] ?? 'Save';
  String get english => _localizedStrings['english'] ?? 'English';
  String get arabic => _localizedStrings['arabic'] ?? 'العربية';
  String get french => _localizedStrings['french'] ?? 'French';
  String get german => _localizedStrings['german'] ?? 'German';
  String get italian => _localizedStrings['italian'] ?? 'Italian';
  String get spanish => _localizedStrings['spanish'] ?? 'Spanish';
  String get russian => _localizedStrings['russian'] ?? 'Russian';
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    // In a real app, you would load the appropriate ARB file here
    // For now, we'll use a simple implementation
    Map<String, String> strings;
    if (locale.languageCode == 'ar') {
      strings = {
        "language": "اللغة",
        "chooseLanguage": "اختر لغة التطبيق",
        "save": "حفظ",
        "english": "English",
        "arabic": "العربية",
        "french": "Français",
        "german": "Deutsch",
        "italian": "Italiano",
        "spanish": "Español",
        "russian": "Русسي"
      };
    } else {
      strings = {
        "language": "Language",
        "chooseLanguage": "Choose your app language",
        "save": "Save",
        "english": "English",
        "arabic": "العربية",
        "french": "French",
        "german": "German",
        "italian": "Italian",
        "spanish": "Spanish",
        "russian": "Russian"
      };
    }
    return AppLocalizations(strings);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
