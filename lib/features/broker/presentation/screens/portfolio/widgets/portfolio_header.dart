import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';

class PortfolioHeader extends StatelessWidget {
  final int totalCount;
  final int liveCount;
  final VoidCallback onReferTap;

  const PortfolioHeader({
    super.key,
    required this.totalCount,
    required this.liveCount,
    required this.onReferTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Row(
        children: [
          // Back Button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(
                Icons.chevron_left,
                color: AppColors.navy,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Title & Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Portfolio',
                  style: AppTheme.dm(
                    size: 20,
                    weight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$totalCount referred · $liveCount live',
                  style: AppTheme.dm(
                    size: 13,
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
          ),
          // Refer Button
          GestureDetector(
            onTap: onReferTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.gold,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Refer',
                style: AppTheme.dm(
                  size: 13,
                  weight: FontWeight.w600,
                  color: AppColors.navy,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}