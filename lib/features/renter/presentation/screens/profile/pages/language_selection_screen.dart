import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sahely/core/providers/locale_provider.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String? _tempSelectedLocale;

  final List<Map<String, String>> _languages = [
    {'code': 'en', 'name': 'English', 'nativeName': 'English'},
    {'code': 'ar', 'name': 'Arabic', 'nativeName': 'العربية'},
    {'code': 'fr', 'name': 'French', 'nativeName': 'Français'},
    {'code': 'de', 'name': 'German', 'nativeName': 'Deutsch'},
    {'code': 'it', 'name': 'Italian', 'nativeName': 'Italiano'},
    {'code': 'es', 'name': 'Spanish', 'nativeName': 'Español'},
    {'code': 'ru', 'name': 'Russian', 'nativeName': 'Русский'},
  ];

  @override
  void initState() {
    super.initState();
    // Initialize with current locale
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _tempSelectedLocale =
            context.read<LocaleProvider>().locale.languageCode;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.read<LocaleProvider>();

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(
              Icons.chevron_left,
              color: AppColors.navy,
              size: 20,
            ),
          ),
        ),
        title: Text(
          'Language',
          style: AppTheme.dm(
            size: 20,
            weight: FontWeight.w700,
            color: AppColors.navy,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Subtitle
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Text(
                'Choose your app language',
                style: AppTheme.dm(
                  size: 14,
                  color: AppColors.secondary,
                ),
              ),
            ),

            // Language List Card
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: _languages.asMap().entries.map((entry) {
                        final index = entry.key;
                        final language = entry.value;
                        final isSelected =
                            _tempSelectedLocale == language['code'];

                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _tempSelectedLocale = language['code'];
                                });
                              },
                              child: Container(
                                color: Colors.transparent, // Fixes tap area
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                child: Row(
                                  children: [
                                    // Language Name
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            language['nativeName']!,
                                            style: AppTheme.dm(
                                              size: 15,
                                              weight: FontWeight.w600,
                                              color: AppColors.navy,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            language['name']!,
                                            style: AppTheme.dm(
                                              size: 13,
                                              color: AppColors.muted,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Radio Button
                                    Container(
                                      width: 22,
                                      height: 22,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isSelected
                                              ? AppColors.navy
                                              : AppColors.border,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: isSelected
                                          ? Center(
                                              child: Container(
                                                width: 12,
                                                height: 12,
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: AppColors.navy,
                                                ),
                                              ),
                                            )
                                          : null,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Divider (except last item)
                            if (index < _languages.length - 1)
                              const Divider(
                                height: 1,
                                color: AppColors.border,
                                indent: 0,
                                endIndent: 0,
                              ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Done Button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    if (_tempSelectedLocale != null) {
                      localeProvider.setLocale(_tempSelectedLocale!);
                    }
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.navy,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Done',
                    style: AppTheme.dm(
                      size: 15,
                      weight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
