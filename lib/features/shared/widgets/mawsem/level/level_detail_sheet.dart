import 'package:flutter/material.dart';

import 'package:sahely/features/shared/widgets/mawsem/level/level_done_button.dart';
import 'package:sahely/features/shared/widgets/mawsem/level/level_header.dart';
import 'package:sahely/features/shared/widgets/mawsem/level/level_perk.dart';
import 'package:sahely/features/shared/widgets/mawsem/level/level_progress_bar.dart';
import 'package:sahely/features/shared/widgets/mawsem/level/season_perks_section.dart';
import 'package:sahely/features/shared/widgets/mawsem/level/unlock_reward_card.dart';

class LevelDetailSheet extends StatelessWidget {
  final String levelName;
  final IconData levelIcon;
  final Color levelColor;
  final int starsRequired;
  final int currentStars;
  final List<LevelPerk> seasonPerks;
  final String? unlockReward;
  final VoidCallback onClose;

  const LevelDetailSheet({
    super.key,
    required this.levelName,
    required this.levelIcon,
    required this.levelColor,
    required this.starsRequired,
    required this.currentStars,
    required this.seasonPerks,
    this.unlockReward,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(32),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE0D8CC),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Level Header
          LevelHeader(
            levelName: levelName,
            levelIcon: levelIcon,
            levelColor: levelColor,
            starsRequired: starsRequired,
            onClose: onClose,
          ),

          const SizedBox(height: 20),

          // Progress Area (93 stars more...)
          LevelProgressBar(
            currentStars: currentStars,
            starsRequired: starsRequired,
            levelColor: levelColor,
          ),

          const SizedBox(height: 24),

          // Season Perks
          SeasonPerksSection(
            perks: seasonPerks,
            perkColor: levelColor,
          ),

          const SizedBox(height: 24),

          // Unlock Reward
          if (unlockReward != null) UnlockRewardCard(reward: unlockReward!),

          const SizedBox(height: 24),

          // Done Button
          LevelDoneButton(onTap: onClose),
        ],
      ),
    );
  }
}
