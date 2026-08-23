import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';

class ConfirmPayButton extends StatelessWidget {
  final bool isLoading;
  final int total; // in piastres
  final VoidCallback? onPressed;

  const ConfirmPayButton({
    super.key,
    required this.isLoading,
    required this.total,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: (isLoading || total == 0) ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              (isLoading || total == 0) ? AppColors.border : AppColors.navy,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                ),
              )
            : Text(
                'Confirm & Pay',
                style: AppTheme.dm(
                  size: 16,
                  weight: FontWeight.w700,
                ),
              ),
      ),
    );
  }
}
