import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';

class StarsProgressBar extends StatelessWidget {
  final int previousTotal;
  final int currentTotal;
  final int starsToNextLevel;
  final String nextLevelName;

  const StarsProgressBar({
    super.key,
    required this.previousTotal,
    required this.currentTotal,
    required this.starsToNextLevel,
    required this.nextLevelName,
  });

  @override
  Widget build(BuildContext context) {
    final nextLevelTotal = currentTotal + starsToNextLevel;
    final progress = (currentTotal / nextLevelTotal).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Season total',
                style: AppTheme.dm(
                  size: 13,
                  color: AppColors.secondary,
                ),
              ),
              RichText(
                text: TextSpan(
                  style: AppTheme.dm(
                    size: 13,
                    weight: FontWeight.w600,
                  ),
                  children: [
                    TextSpan(
                      text: '$previousTotal',
                      style: AppTheme.dm(
                          color: AppColors.secondary,
                          size: 13,
                          weight: FontWeight.w600),
                    ),
                    TextSpan(
                      text: ' → ',
                      style: AppTheme.dm(
                          color: AppColors.secondary,
                          size: 13,
                          weight: FontWeight.w600),
                    ),
                    TextSpan(
                      text: '$currentTotal',
                      style: AppTheme.dm(
                          color: AppColors.navy,
                          size: 13,
                          weight: FontWeight.w600),
                    ),
                    TextSpan(
                      text: ' ★',
                      style: AppTheme.dm(
                          color: AppColors.gold,
                          size: 13,
                          weight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: AppColors.border,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
            ),
          ),
          const SizedBox(height: 8),
          // Next Level
          Text(
            '$starsToNextLevel ★ to $nextLevelName',
            style: AppTheme.dm(
              size: 12,
              color: AppColors.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
