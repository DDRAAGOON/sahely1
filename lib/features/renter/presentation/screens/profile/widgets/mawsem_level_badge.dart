import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sahely/core/providers/profile_provider.dart';
import 'package:sahely/core/theme/app_colors.dart';

import 'package:sahely/features/shared/widgets/mawsem/level/level_detail_sheet.dart';
import 'package:sahely/features/shared/widgets/mawsem/level/level_perk.dart';

class MawsemLevelBadge extends StatelessWidget {
  final String levelName;
  final int levelNumber;

  const MawsemLevelBadge({
    super.key,
    required this.levelName,
    required this.levelNumber,
  });

  void _showLevelDetail(BuildContext context) {
    final profile = context.read<ProfileProvider>();

    // Level Icons
    final Map<int, IconData> levelIcons = {
      1: Icons.directions_walk,
      2: Icons.explore,
      3: Icons.waves,
      4: Icons.anchor,
      5: Icons.diamond,
      6: Icons.star,
      7: Icons.emoji_events,
    };

    // Level Colors
    final Map<int, Color> levelColors = {
      1: const Color(0xFF717171),
      2: AppColors.mawsemTeal,
      3: AppColors.mawsemTeal,
      4: const Color(0xFFBC9B43),
      5: const Color(0xFF6B4D8A),
      6: const Color(0xFFBC9B43),
      7: AppColors.gold,
    };

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useRootNavigator: true, // This makes it cover the bottom nav
      builder: (context) => LevelDetailSheet(
        levelName: levelName,
        levelIcon: levelIcons[levelNumber] ?? Icons.waves,
        levelColor: levelColors[levelNumber] ?? AppColors.mawsemTeal,
        starsRequired: _getStarsRequired(levelNumber),
        currentStars: profile.stars,
        seasonPerks: _getMockPerks(levelNumber),
        unlockReward: _getMockReward(levelNumber),
        onClose: () => Navigator.pop(context),
      ),
    );
  }

  int _getStarsRequired(int level) {
    final thresholds = [0, 15, 40, 80, 140, 220, 500];
    if (level <= thresholds.length) return thresholds[level - 1];
    return 0;
  }

  List<LevelPerk> _getMockPerks(int level) {
    if (level == 5) {
      return const [
        LevelPerk(
            title: 'Free Professional Cleaning', subtitle: 'Once per stay'),
        LevelPerk(
            title: 'Early access (48h)', subtitle: 'For all season promos'),
        LevelPerk(title: 'Everything from Coastal Regular'),
      ];
    }
    return [LevelPerk(title: 'Access to level $level perks')];
  }

  String? _getMockReward(int level) {
    if (level == 5) return 'Free Airport Pickup (Cairo to compound)';
    return 'Level $level Badge';
  }

  @override
  Widget build(BuildContext context) {
    // MAWSEM Level Display Colors
    final Map<int, Color> displayBgColors = {
      1: const Color(0xFFE8E8E8),
      2: const Color(0xFFB8D4E8),
      3: AppColors.mawsemTeal,
      4: AppColors.navy,
      5: const Color(0xFF6B4D8A),
      6: AppColors.gold,
      7: AppColors.navy,
    };

    final Map<int, Color> displayTextColors = {
      1: AppColors.secondary,
      2: AppColors.navy,
      3: Colors.white,
      4: Colors.white,
      5: Colors.white,
      6: AppColors.navy,
      7: AppColors.gold,
    };

    final Map<int, IconData> levelIcons = {
      1: Icons.directions_walk,
      2: Icons.explore,
      3: Icons.waves,
      4: Icons.anchor,
      5: Icons.diamond,
      6: Icons.star,
      7: Icons.emoji_events,
    };

    final bgColor = displayBgColors[levelNumber] ?? AppColors.mawsemTeal;
    final textColor = displayTextColors[levelNumber] ?? Colors.white;
    final icon = levelIcons[levelNumber] ?? Icons.waves;

    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: () => _showLevelDetail(context),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: textColor),
              const SizedBox(width: 8),
              Text(
                levelName,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                  fontFamily: 'DM Sans',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
