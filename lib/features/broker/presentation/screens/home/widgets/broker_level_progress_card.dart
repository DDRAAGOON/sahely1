import 'package:flutter/material.dart';

import '../../../../../../core/theme/app_colors.dart';

class BrokerLevelProgressCard extends StatelessWidget {
  final String currentLevelName;
  final IconData levelIcon;
  final int currentStars;
  final int starsToNextLevel;
  final String nextLevelName;
  final VoidCallback onTap;

  const BrokerLevelProgressCard({
    super.key,
    required this.currentLevelName,
    required this.levelIcon,
    required this.currentStars,
    required this.starsToNextLevel,
    required this.nextLevelName,
    required this.onTap,
  });

  int get _nextLevelThreshold => currentStars + starsToNextLevel;

  double get _progress => currentStars / _nextLevelThreshold;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.navy,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    levelIcon,
                    color: AppColors.gold,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentLevelName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontFamily: 'DM Sans',
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$currentStars ★ this season',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.gold,
                          fontFamily: 'DM Sans',
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: Colors.white54,
                  size: 20,
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: _progress),
                duration: const Duration(milliseconds: 1000),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return LinearProgressIndicator(
                    value: value,
                    minHeight: 8,
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(AppColors.gold),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$starsToNextLevel ★ to $nextLevelName',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white70,
                fontFamily: 'DM Sans',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
