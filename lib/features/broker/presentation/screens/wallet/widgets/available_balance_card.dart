import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';

class AvailableBalanceCard extends StatelessWidget {
  final String balance;

  const AvailableBalanceCard({
    super.key,
    required this.balance,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(16),
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Available Balance',
            style: AppTheme.dm(
              size: 14,
              color: const Color(0xFFCDD4E0),
              weight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'EGP $balance',
            style: AppTheme.dm(
              size: 32,
              weight: FontWeight.w700,
              color: const Color(0xFFC9A84C),
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}