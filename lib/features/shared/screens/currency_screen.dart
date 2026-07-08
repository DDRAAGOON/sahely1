import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/common.dart';
import '../../../widgets/ui.dart';

class CurrencyScreen extends StatelessWidget {
  const CurrencyScreen({super.key});
  static const _items = [
    ('🇪🇬', 'EGP', 'Egyptian Pound'),
    ('💵', 'USD', 'US Dollar'),
    ('💶', 'EUR', 'Euro'),
    ('💷', 'GBP', 'British Pound'),
    ('🇸🇦', 'SAR', 'Saudi Riyal'),
    ('🇦🇪', 'AED', 'UAE Dirham')
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(children: [
        const Positioned.fill(child: ColoredBox(color: Color(0x731B2744))),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: const BoxDecoration(
                color: AppColors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
            padding: const EdgeInsets.fromLTRB(22, 0, 22, 22),
            child: SafeArea(
              top: false,
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SheetHandle(),
                    const SizedBox(height: 8),
                    Text('Currency', style: AppTheme.dm(size: 16, weight: FontWeight.w700, color: AppColors.navy)),
                    const SizedBox(height: 12),
                    for (var i = 0; i < _items.length; i++)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: i == _items.length - 1 ? Colors.transparent : const Color(0xFFF4EFE7)))),
                        child: Row(children: [
                          Text(_items[i].$1, style: const TextStyle(fontSize: 20)),
                          const SizedBox(width: 12),
                          Text(_items[i].$2, style: AppTheme.dm(size: 14, weight: FontWeight.w700, color: AppColors.navy)),
                          const SizedBox(width: 8),
                          Expanded(child: Text(_items[i].$3, style: AppTheme.dm(size: 12, color: AppColors.muted))),
                          Icon(i == 0 ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                              size: 20, color: i == 0 ? AppColors.gold : AppColors.border),
                        ]),
                      ),
                    const SizedBox(height: 14),
                    NavyButton(label: 'Apply', onTap: () => Navigator.maybePop(context)),
                  ]),
            ),
          ),
        ),
      ]),
    );
  }
}
