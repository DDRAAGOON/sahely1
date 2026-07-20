import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';

import 'currency_tile.dart';

class CurrencyList extends StatelessWidget {
  final String selectedCurrency;
  final ValueChanged<String> onCurrencySelected;

  const CurrencyList({
    super.key,
    required this.selectedCurrency,
    required this.onCurrencySelected,
  });

  static const List<Map<String, String>> _currencies = [
    {
      'code': 'EGP',
      'symbol': '£E',
      'name': 'Egyptian Pound',
      'countryCode': 'EG',
    },
    {
      'code': 'USD',
      'symbol': '\$',
      'name': 'US Dollar',
      'countryCode': 'US',
    },
    {
      'code': 'EUR',
      'symbol': '€',
      'name': 'Euro',
      'countryCode': 'EU',
    },
    {
      'code': 'GBP',
      'symbol': '£',
      'name': 'British Pound',
      'countryCode': 'GB',
    },
    {
      'code': 'SAR',
      'symbol': 'ريال',
      'name': 'Saudi Riyal',
      'countryCode': 'SA',
    },
    {
      'code': 'AED',
      'symbol': 'د.إ',
      'name': 'UAE Dirham',
      'countryCode': 'AE',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: _currencies.asMap().entries.map((entry) {
          final index = entry.key;
          final currency = entry.value;
          final isLast = index == _currencies.length - 1;

          return Column(
            children: [
              CurrencyTile(
                countryCode: currency['countryCode']!,
                currencyCode: currency['code']!,
                symbol: currency['symbol']!,
                name: currency['name']!,
                isSelected: selectedCurrency == currency['code'],
                onTap: () => onCurrencySelected(currency['code']!),
              ),
              if (!isLast)
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
    );
  }
}
