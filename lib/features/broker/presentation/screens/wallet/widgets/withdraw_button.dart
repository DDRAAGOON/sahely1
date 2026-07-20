import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';

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
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isVerified ? AppColors.navy : const Color(0xFFC0A975),
                  fontFamily: 'DM Sans',
                ),
              ),
            ),
          ),
          if (!isVerified) ...[
            const SizedBox(height: 8),
            const Text(
              'Locked until your account is verified',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.muted,
                fontFamily: 'DM Sans',
              ),
            ),
          ],
        ],
      ),
    );
  }
}