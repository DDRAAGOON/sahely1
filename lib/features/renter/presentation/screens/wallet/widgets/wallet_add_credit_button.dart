import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';

class WalletAddCreditButton extends StatelessWidget {
  final VoidCallback onAddCredit;

  const WalletAddCreditButton({
    super.key,
    required this.onAddCredit,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: onAddCredit,
        icon: const Icon(Icons.add, size: 20),
        label: Text(
          'Add Credit',
          style: AppTheme.dm(
            size: 15,
            weight: FontWeight.w700,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.gold,
          foregroundColor: AppColors.navy,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}
