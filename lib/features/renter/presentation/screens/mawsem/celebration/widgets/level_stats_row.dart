import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';

class LevelStatsRow extends StatelessWidget {
  final int currentStars;
  final int starsToNextLevel;
  final int nextLevel;

  const LevelStatsRow({
    super.key,
    required this.currentStars,
    required this.starsToNextLevel,
    required this.nextLevel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Current Stars
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                RichText(
                  text: TextSpan(
                    style: AppTheme.dm(
                      size: 24,
                      weight: FontWeight.w700,
                    ),
                    children: [
                      TextSpan(
                        text: '$currentStars',
                        style: AppTheme.dm(color: AppColors.gold, size: 24, weight: FontWeight.w700),
                      ),
                      TextSpan(
                        text: ' ★',
                        style: AppTheme.dm(color: AppColors.gold, size: 24, weight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'This season',
                  style: AppTheme.dm(
                    size: 12,
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Stars to Next Level
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                Text(
                  '$starsToNextLevel',
                  style: AppTheme.dm(
                    size: 24,
                    weight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '★ to Level $nextLevel',
                  style: AppTheme.dm(
                    size: 12,
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
