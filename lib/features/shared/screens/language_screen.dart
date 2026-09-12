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
  String? _selectedLanguageCode;

  @override
  void initState() {
    super.initState();
    final locale = context.read<LocaleProvider>().locale;
    _selectedLanguageCode = locale?.languageCode ?? 'system';
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final List<Map<String, String>> languages = [
      {'name': l.followSystem, 'code': 'system', 'flag': '⚙️'},
      {'name': 'English', 'code': 'en', 'flag': '🇺🇸'},
      {'name': 'العربية', 'code': 'ar', 'flag': '🇪🇬'},
      {'name': 'Français', 'code': 'fr', 'flag': '🇫🇷'},
      {'name': 'Deutsch', 'code': 'de', 'flag': '🇩🇪'},
      {'name': 'Italiano', 'code': 'it', 'flag': '🇮🇹'},
      {'name': 'Español', 'code': 'es', 'flag': '🇪🇸'},
      {'name': 'Русский', 'code': 'ru', 'flag': '🇷🇺'},
    ];

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
            ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.sizeOf(context).height * 0.9),
              child: SingleChildScrollView(
                  child: Container(
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
                        l.language,
                        style: AppTheme.dm(
                          size: 16,
                          weight: FontWeight.w700,
                          color: AppColors.navy,
                        ),
                      ),
                      const SizedBox(height: 12),
                      for (var i = 0; i < languages.length; i++)
                        GestureDetector(
                          onTap: () => setState(() {
                            _selectedLanguageCode = languages[i]['code']!;
                          }),
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: i == languages.length - 1
                                      ? Colors.transparent
                                      : const Color(0xFFF4EFE7),
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Text(languages[i]['flag']!,
                                    style: const TextStyle(fontSize: 20)),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(languages[i]['name']!,
                                      style: AppTheme.dm(
                                        size: 14,
                                        weight: _selectedLanguageCode ==
                                                languages[i]['code']
                                            ? FontWeight.w700
                                            : FontWeight.w400,
                                      )),
                                ),
                                Icon(
                                  _selectedLanguageCode == languages[i]['code']
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_unchecked,
                                  size: 20,
                                  color: _selectedLanguageCode ==
                                          languages[i]['code']
                                      ? AppColors.gold
                                      : AppColors.border,
                                ),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: 14),
                      NavyButton(
                        label: l.save,
                        onTap: () {
                          context.read<LocaleProvider>().setLocale(
                              _selectedLanguageCode == 'system'
                                  ? null
                                  : _selectedLanguageCode);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }
}
