import 'package:flutter/material.dart';
import 'package:sahely/core/navigation/app_navigation.dart';
import 'package:sahely/core/theme/app_colors.dart';

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

  void _showNextLevelDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => LevelDetailSheet(
        levelName: 'Coastal Regular',
        levelIcon: Icons.home_outlined,
        levelColor: const Color(0xFFBC9B43),
        starsRequired: 80,
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.navy,
            Color(0xFF243358),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.gold, width: 1),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => AppNavigation.goToMawsem(context),
            child: Row(
              children: [
                // Star Icon Tile
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.star,
                    color: AppColors.navy,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                // Title & Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'AL MAWSEM Season Pass',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$levelName · $starsCount ★',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.gold,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                ),
                // Chevron
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.gold,
                  size: 20,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Progress Bar Section
          GestureDetector(
            onTap: () => _showNextLevelDetail(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: const LinearProgressIndicator(
                    value: 0.58,
                    minHeight: 6,
                    backgroundColor: Color(0xFF2D3A5C),
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.gold),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '33 ★ more to Coastal Regular',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFFB8C4E0),
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
