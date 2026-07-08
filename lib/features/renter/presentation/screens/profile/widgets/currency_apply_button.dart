import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';

class CurrencyApplyButton extends StatelessWidget {
  final String selectedCurrency;
  final VoidCallback onApply;

  const CurrencyApplyButton({
    super.key,
    required this.selectedCurrency,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: onApply,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.navy,
            foregroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Apply',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              fontFamily: 'DM Sans',
            ),
          ),
        ),
      ),
    );
  }
}
