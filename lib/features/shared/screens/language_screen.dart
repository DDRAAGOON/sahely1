import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../widgets/buttons.dart';
import '../widgets/cards.dart';
import '../widgets/cream_background.dart';
import '../widgets/top_bar.dart';


class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});
  static const _langs = ['English', 'العربية', 'Français', 'Deutsch', 'Italiano', 'Español', 'Русский'];

  @override
  Widget build(BuildContext context) {
    return PhoneScaffold(
      child: Column(children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            children: [
              const TopBar(title: 'Language'),
              const SizedBox(height: 16),
              WhiteCard(
                child: Column(children: [
                  for (var i = 0; i < _langs.length; i++)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: i == _langs.length - 1 ? Colors.transparent : const Color(0xFFF4EFE7)))),
                      child: Row(children: [
                        Expanded(child: Text(_langs[i], style: AppTheme.dm(size: 14, weight: i == 0 ? FontWeight.w700 : FontWeight.w400))),
                        Icon(i == 0 ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                            size: 20, color: i == 0 ? AppColors.gold : AppColors.border),
                      ]),
                    ),
                ]),
              ),
            ],
          ),
        ),
        Padding(padding: const EdgeInsets.all(16), child: NavyButton(label: 'Save', onTap: () => Navigator.maybePop(context))),
      ]),
    );
  }
}
