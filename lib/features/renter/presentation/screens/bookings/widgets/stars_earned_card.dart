import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';

class StarsEarnedCard extends StatelessWidget {
  final int starsEarned;

  const StarsEarnedCard({
    super.key,
    required this.starsEarned,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFC49F45),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.star,
            color: AppColors.navy,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'You earned $starsEarned Sahel Stars on this booking!',
              style: AppTheme.dm(
                size: 13,
                weight: FontWeight.w600,
                color: AppColors.navy,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
