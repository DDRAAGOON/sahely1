import 'package:flutter/material.dart';

import '../../../../../../../../core/theme/app_colors.dart';

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
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'DM Sans',
                    ),
                    children: [
                      TextSpan(
                        text: '$currentStars',
                        style: const TextStyle(color: AppColors.gold),
                      ),
                      const TextSpan(
                        text: ' ★',
                        style: TextStyle(color: AppColors.gold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'This season',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.secondary,
                    fontFamily: 'DM Sans',
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
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                    fontFamily: 'DM Sans',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '★ to Level $nextLevel',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.secondary,
                    fontFamily: 'DM Sans',
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
