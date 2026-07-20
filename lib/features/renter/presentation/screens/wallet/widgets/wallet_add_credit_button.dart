import 'package:flutter/material.dart';

import '../../../../../../core/theme/app_colors.dart';

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
        label: const Text(
          'Add Credit',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            fontFamily: 'DM Sans',
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
