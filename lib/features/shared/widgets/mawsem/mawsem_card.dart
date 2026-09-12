import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sahely/core/navigation/app_navigation.dart';
import 'package:sahely/core/providers/profile_provider.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/features/shared/widgets/mawsem/level/level_detail_sheet.dart';
import 'package:sahely/features/shared/widgets/mawsem/mawsem_scene_background.dart';
import 'package:sahely/core/widgets/bouncy_button.dart';
import 'package:sahely/core/theme/app_theme.dart';

class MawsemCard extends StatelessWidget {
  const MawsemCard({super.key});

  void _showNextLevelDetail(
      BuildContext context, Map<String, dynamic> nextLevel, int currentStars) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useRootNavigator: true,
      // No perk list: the backend only reports the perks of the level the
      // account is on, not of the one above it.
      builder: (context) => LevelDetailSheet(
        levelName: nextLevel['name'],
        levelIcon: nextLevel['icon'],
        levelColor: nextLevel['color'],
        starsRequired: nextLevel['stars'],
        currentStars: currentStars,
        seasonPerks: const [],
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
    final int starsToNext = profile.starsToNext;

    double progress = 1.0;
    if (nextLevel != null) {
      final int nextLevelThreshold = nextLevel['stars'];
      progress = (currentStars / nextLevelThreshold).clamp(0.0, 1.0);
    }

    return BouncyButton(
      onTap: () {
        AppNavigation.goToMawsem(context);
      },
      child: Container(
        clipBehavior: Clip.antiAlias,
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
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            const Positioned.fill(child: MawsemSceneBackground()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Row: Icon + Level Info
                  Row(
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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              levelData['name'],
                              style: AppTheme.dm(
                                size: 17,
                                weight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Text(
                                  '$currentStars ',
                                  style: AppTheme.dm(
                                    size: 13,
                                    weight: FontWeight.w700,
                                    color: AppColors.mawsemGoldBright,
                                  ),
                                ),
                                const Icon(Icons.star,
                                    color: AppColors.mawsemGoldBright,
                                    size: 12),
                                Text(
                                  ' this season',
                                  style: AppTheme.dm(
                                    size: 13,
                                    color: AppColors.mawsemGoldBright,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: Colors.white38,
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
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: AppColors.mawsemProgressTrack,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                AppColors.mawsemGoldBright),
                            minHeight: 7,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              '$starsToNext ',
                              style: AppTheme.dm(
                                size: 12,
                                weight: FontWeight.w600,
                                color: AppColors.mawsemTextMuted,
                              ),
                            ),
                            const Icon(Icons.star,
                                color: AppColors.mawsemTextMuted, size: 11),
                            Text(
                              nextLevel != null
                                  ? ' to ${nextLevel['name']}'
                                  : ' Max level reached!',
                              style: AppTheme.dm(
                                size: 12,
                                color: AppColors.mawsemTextMuted,
                              ),
                            ),
                          ],
                        ),
                      ],
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
