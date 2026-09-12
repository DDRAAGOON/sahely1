import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sahely/core/providers/currency_provider.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/ui.dart';
import 'package:sahely/core/widgets/sheet_handle.dart';

class CurrencyScreen extends StatefulWidget {
  const CurrencyScreen({super.key});

  @override
  State<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
  late String _selectedCurrency;

  static const List<Map<String, String>> _currencies = [
    {
      'code': 'EGP',
      'symbol': '£E',
      'name': 'Egyptian Pound',
      'flag': '🇪🇬',
    },
    {
      'code': 'USD',
      'symbol': '\$',
      'name': 'US Dollar',
      'flag': '💵',
    },
    {
      'code': 'EUR',
      'symbol': '€',
      'name': 'Euro',
      'flag': '💶',
    },
    {
      'code': 'GBP',
      'symbol': '£',
      'name': 'British Pound',
      'flag': '💷',
    },
    {
      'code': 'SAR',
      'symbol': 'ريال',
      'name': 'Saudi Riyal',
      'flag': '🇸🇦',
    },
    {
      'code': 'AED',
      'symbol': 'د.إ',
      'name': 'UAE Dirham',
      'flag': '🇦🇪',
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedCurrency = context.read<CurrencyProvider>().selectedCurrency;
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
                    const SheetHandle(),
                    const SizedBox(height: 8),
                    Text(
                      'Currency',
                      style: AppTheme.dm(
                        size: 16,
                        weight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 12),
                    for (var i = 0; i < _currencies.length; i++)
                      GestureDetector(
                        onTap: () => setState(() {
                          _selectedCurrency = _currencies[i]['code']!;
                        }),
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: i == _currencies.length - 1
                                    ? Colors.transparent
                                    : const Color(0xFFF4EFE7),
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(_currencies[i]['flag']!,
                                  style: const TextStyle(fontSize: 20)),
                              const SizedBox(width: 12),
                              Text(_currencies[i]['code']!,
                                  style: AppTheme.dm(
                                      size: 14,
                                      weight: FontWeight.w700,
                                      color: AppColors.navy)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(_currencies[i]['name']!,
                                    style: AppTheme.dm(
                                        size: 12, color: AppColors.muted)),
                              ),
                              Icon(
                                _selectedCurrency == _currencies[i]['code']
                                    ? Icons.radio_button_checked
                                    : Icons.radio_button_unchecked,
                                size: 20,
                                color:
                                    _selectedCurrency == _currencies[i]['code']
                                        ? AppColors.gold
                                        : AppColors.border,
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 14),
                    NavyButton(
                      label: 'Apply',
                      onTap: () {
                        context
                            .read<CurrencyProvider>()
                            .setCurrency(_selectedCurrency);
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
