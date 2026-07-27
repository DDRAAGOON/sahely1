import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sahely/core/navigation/app_navigation.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/providers/profile_provider.dart';

import 'package:sahely/features/shared/widgets/mawsem/level/level_detail_sheet.dart';
import 'package:sahely/features/shared/widgets/mawsem/level/level_perk.dart';

class MawsemSeasonPassCard extends StatelessWidget {
  final String levelName;
  final int starsCount;

  const MawsemSeasonPassCard({
    super.key,
    required this.levelName,
    required this.starsCount,
  });

  void _showNextLevelDetail(BuildContext context, Map<String, dynamic>? nextLevel) {
    if (nextLevel == null) return;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useRootNavigator: true, 
      builder: (context) => LevelDetailSheet(
        levelName: nextLevel['name'],
        levelIcon: nextLevel['icon'],
        levelColor: nextLevel['color'],
        starsRequired: nextLevel['stars'],
        currentStars: starsCount,
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
    
    final int starsToNext =
        nextLevel != null ? nextLevel['stars'] - starsCount : 0;

    double progress = 1.0;
    if (nextLevel != null) {
      final int nextLevelThreshold = nextLevel['stars'];
      progress = (starsCount / nextLevelThreshold).clamp(0.0, 1.0);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.mawsemCardBgTop,
            AppColors.mawsemCardBgBottom,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => AppNavigation.goToMawsem(context),
            child: Row(
              children: [
                // Level Icon Box with Teal Gradient
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.mawsemTealStart,
                        AppColors.mawsemTealEnd,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    levelData['icon'],
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                // Title & Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        levelName,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontFamily: 'DM Sans',
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            '$starsCount ',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.mawsemGoldBright,
                              fontFamily: 'DM Sans',
                            ),
                          ),
                          const Icon(Icons.star, color: AppColors.mawsemGoldBright, size: 12),
                          const Text(
                            ' this season',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.mawsemGoldBright,
                              fontFamily: 'DM Sans',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Chevron
                const Icon(
                  Icons.chevron_right,
                  color: Colors.white38,
                  size: 20,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Progress Bar Section
          GestureDetector(
            onTap: () => _showNextLevelDetail(context, nextLevel),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 7,
                    backgroundColor: AppColors.mawsemProgressTrack,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.mawsemGoldBright),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      '$starsToNext ',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.mawsemTextMuted,
                        fontFamily: 'DM Sans',
                      ),
                    ),
                    const Icon(Icons.star, color: AppColors.mawsemTextMuted, size: 11),
                    Text(
                      nextLevel != null
                          ? ' to ${nextLevel['name']}'
                          : ' Max level reached!',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.mawsemTextMuted,
                        fontFamily: 'DM Sans',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
