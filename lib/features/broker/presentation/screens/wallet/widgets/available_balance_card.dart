import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';

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
          const Text(
            'Available Balance',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFFCDD4E0),
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'EGP $balance',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: Color(0xFFC9A84C),
              fontFamily: 'DM Sans',
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}