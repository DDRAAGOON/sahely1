import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sahely/core/providers/locale_provider.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/ui.dart';
import 'package:sahely/core/widgets/sheet_handle.dart';
import 'package:sahely/l10n/app_localizations.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  late String _selectedLanguageCode;

  static const List<Map<String, String>> _languages = [
    {'name': 'English', 'code': 'en', 'flag': '🇺🇸'},
    {'name': 'العربية', 'code': 'ar', 'flag': '🇪🇬'},
    {'name': 'Français', 'code': 'fr', 'flag': '🇫🇷'},
    {'name': 'Deutsch', 'code': 'de', 'flag': '🇩🇪'},
    {'name': 'Italiano', 'code': 'it', 'flag': '🇮🇹'},
    {'name': 'Español', 'code': 'es', 'flag': '🇪🇸'},
    {'name': 'Русский', 'code': 'ru', 'flag': '🇷🇺'},
  ];

  @override
  void initState() {
    super.initState();
    _selectedLanguageCode = context.read<LocaleProvider>().locale.languageCode;
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Container(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                behavior: HitTestBehavior.opaque,
                child: const SizedBox.expand(),
              ),
            ),
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding: const EdgeInsets.fromLTRB(22, 0, 22, 22),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 12),
                    const SheetHandle(),
                    const SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context).language,
                      style: AppTheme.dm(
                        size: 16,
                        weight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 12),
                    for (var i = 0; i < _languages.length; i++)
                      GestureDetector(
                        onTap: () => setState(() {
                          _selectedLanguageCode = _languages[i]['code']!;
                        }),
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: i == _languages.length - 1
                                    ? Colors.transparent
                                    : const Color(0xFFF4EFE7),
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(_languages[i]['flag']!,
                                  style: const TextStyle(fontSize: 20)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(_languages[i]['name']!,
                                    style: AppTheme.dm(
                                      size: 14,
                                      weight: _selectedLanguageCode ==
                                              _languages[i]['code']
                                          ? FontWeight.w700
                                          : FontWeight.w400,
                                    )),
                              ),
                              Icon(
                                _selectedLanguageCode == _languages[i]['code']
                                    ? Icons.radio_button_checked
                                    : Icons.radio_button_unchecked,
                                size: 20,
                                color: _selectedLanguageCode ==
                                        _languages[i]['code']
                                    ? AppColors.gold
                                    : AppColors.border,
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 14),
                    NavyButton(
                      label: AppLocalizations.of(context).save,
                      onTap: () {
                        context
                            .read<LocaleProvider>()
                            .setLocale(_selectedLanguageCode);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
