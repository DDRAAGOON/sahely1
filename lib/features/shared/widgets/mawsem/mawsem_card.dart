import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sahely/core/navigation/app_navigation.dart';
import 'package:sahely/core/providers/profile_provider.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/features/shared/widgets/mawsem/level/level_detail_sheet.dart';
import 'package:sahely/features/shared/widgets/mawsem/level/level_perk.dart';

class MawsemCard extends StatelessWidget {
  const MawsemCard({super.key});

  void _showNextLevelDetail(
      BuildContext context, Map<String, dynamic> nextLevel, int currentStars) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useRootNavigator: true, // This makes it cover the bottom nav
      builder: (context) => LevelDetailSheet(
        levelName: nextLevel['name'],
        levelIcon: nextLevel['icon'],
        levelColor: nextLevel['color'],
        starsRequired: nextLevel['stars'],
        currentStars: currentStars,
        seasonPerks: const [
          LevelPerk(title: 'Complimentary welcome basket'),
          LevelPerk(title: '200 EGP credit on next booking'),
          LevelPerk(title: 'Free early access to new units'),
        ],
        unlockReward: 'Gift: Local Artisan Soap Set',
        onClose: () => Navigator.pop(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileProvider>();
    final levelData = profile.levelData;
    final nextLevel = profile.nextLevelData;

    final int currentStars = profile.stars;
    final int starsToNext =
        nextLevel != null ? nextLevel['stars'] - currentStars : 0;

    // Using the logic: Progress = currentStars / nextLevelThreshold
    double progress = 1.0;
    if (nextLevel != null) {
      final int nextLevelThreshold = nextLevel['stars'];
      progress = (currentStars / nextLevelThreshold).clamp(0.0, 1.0);
    }

    return GestureDetector(
      onTap: () {
        AppNavigation.goToMawsem(context);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.navy,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: AppColors.gold.withValues(alpha: 0.3), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Icon + Level Info
            Row(
              children: [
                // Level Icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    levelData['icon'],
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
                        levelData['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontFamily: 'DM Sans',
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$currentStars â˜… this season',
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

            // Progress Bar Section
            GestureDetector(
              onTap: () {
                if (nextLevel != null) {
                  _showNextLevelDetail(context, nextLevel, currentStars);
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(AppColors.gold),
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    nextLevel != null
                        ? '$starsToNext â˜… to ${nextLevel['name']}'
                        : 'Max level reached!',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                      fontFamily: 'DM Sans',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
