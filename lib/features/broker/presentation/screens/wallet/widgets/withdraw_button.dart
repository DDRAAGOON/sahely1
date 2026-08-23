import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';

class WithdrawButton extends StatelessWidget {
  final bool isVerified;
  final VoidCallback? onTap;

  const WithdrawButton({
    super.key,
    required this.isVerified,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          GestureDetector(
            onTap: isVerified ? onTap : null,
            child: Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                color: isVerified ? AppColors.gold : const Color(0xFFEAD9A8),
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.center,
              child: Text(
                'Withdraw to Bank',
                style: AppTheme.dm(
                  size: 16,
                  weight: FontWeight.w700,
                  color: isVerified ? AppColors.navy : const Color(0xFFC0A975),
                ),
              ),
            ),
          ),
          if (!isVerified) ...[
            const SizedBox(height: 8),
            Text(
              'Locked until your account is verified',
              style: AppTheme.dm(
                size: 12,
                color: AppColors.muted,
              ),
            ),
          ],
        ],
      ),
    );
  }
}