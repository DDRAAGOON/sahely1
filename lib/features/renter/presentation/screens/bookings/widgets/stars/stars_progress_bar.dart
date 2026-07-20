import 'package:flutter/material.dart';

import '../../../../../../../core/theme/app_colors.dart';

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
              const Text(
                'Season total',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.secondary,
                  fontFamily: 'DM Sans',
                ),
              ),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'DM Sans',
                  ),
                  children: [
                    TextSpan(
                      text: '$previousTotal',
                      style: const TextStyle(color: AppColors.secondary),
                    ),
                    const TextSpan(
                      text: ' → ',
                      style: TextStyle(color: AppColors.secondary),
                    ),
                    TextSpan(
                      text: '$currentTotal',
                      style: const TextStyle(color: AppColors.navy),
                    ),
                    const TextSpan(
                      text: ' ★',
                      style: TextStyle(color: AppColors.gold),
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
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.secondary,
              fontFamily: 'DM Sans',
            ),
          ),
        ],
      ),
    );
  }
}
