import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sahely/core/providers/currency_provider.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/features/renter/presentation/screens/profile/widgets/currency_apply_button.dart';
import 'package:sahely/features/renter/presentation/screens/profile/widgets/currency_header.dart';
import 'package:sahely/features/renter/presentation/screens/profile/widgets/currency_list.dart';

class CurrencySelectorSheet extends StatefulWidget {
  const CurrencySelectorSheet({super.key});

  @override
  State<CurrencySelectorSheet> createState() => _CurrencySelectorSheetState();
}

class _CurrencySelectorSheetState extends State<CurrencySelectorSheet> {
  late String _selectedCurrency;

  @override
  void initState() {
    super.initState();
    _selectedCurrency = context.read<CurrencyProvider>().selectedCurrency;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const SizedBox(height: 20),

          // Header
          const CurrencyHeader(),

          const SizedBox(height: 20),

          // Currency List
          CurrencyList(
            selectedCurrency: _selectedCurrency,
            onCurrencySelected: (currency) {
              setState(() {
                _selectedCurrency = currency;
              });
            },
          ),

          const SizedBox(height: 16),

          // Info Note
          _buildInfoNote(),

          const SizedBox(height: 20),

          // Apply Button
          CurrencyApplyButton(
            selectedCurrency: _selectedCurrency,
            onApply: () {
              context.read<CurrencyProvider>().setCurrency(_selectedCurrency);
              Navigator.pop(context);
            },
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildInfoNote() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.gold.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.gold.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            size: 16,
            color: AppColors.gold,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Conversions are estimates · you\'re always charged in the property\'s listed currency.',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.secondary,
                fontFamily: 'DM Sans',
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
