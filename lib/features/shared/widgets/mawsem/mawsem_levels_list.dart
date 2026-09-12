import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sahely/core/providers/profile_provider.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/features/shared/widgets/mawsem/level/level_detail_sheet.dart';
import 'package:sahely/features/shared/widgets/mawsem/level/level_perk.dart';
import 'package:sahely/features/shared/widgets/mawsem/mawsem_level_tile.dart';

/// The season ladder, exactly as the backend defines it
/// (`GET /mawsem/levels`): the names, the star thresholds and how many levels
/// there are all belong to the season, not to the app.
///
/// Perks come from `GET /mawsem/perks`, which only answers for the account's
/// own level, so no other level claims perks it cannot confirm.
class MawsemLevelsList extends StatelessWidget {
  final int currentLevel;
  final int currentStars;

  const MawsemLevelsList({
    super.key,
    required this.currentLevel,
    required this.currentStars,
  });

  void _showLevelDetail(
    BuildContext context,
    Map<String, dynamic> level,
    List<String> perks,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => LevelDetailSheet(
        levelName: '${level['name'] ?? ''}',
        levelIcon: level['icon'] as IconData,
        levelColor: level['color'] as Color,
        starsRequired: level['stars'] as int,
        currentStars: currentStars,
        seasonPerks: [for (final perk in perks) LevelPerk(title: perk)],
        onClose: () => Navigator.pop(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileProvider>();
    final levels = profile.levels;
    if (levels.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'The ${levels.length} Levels',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.navy,
                fontFamily: 'DM Sans',
              ),
            ),
            const Flexible(
              child: Text(
                'climb the levels for perks',
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.secondary,
                  fontFamily: 'DM Sans',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Levels
        for (final level in levels)
          Builder(builder: (context) {
            final number = level['level'] as int;
            final stars = level['stars'] as int;
            final isCurrent = number == currentLevel;
            final perks = isCurrent ? profile.perks : const <String>[];

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: MawsemLevelTile(
                number: number,
                name: '${level['name'] ?? ''}',
                stars: stars,
                icon: level['icon'] as IconData,
                perks: perks.join(' · '),
                bgColor: isCurrent ? AppColors.mawsemBg : Colors.white,
                textColor: isCurrent ? Colors.white : AppColors.navy,
                iconColor: level['color'] as Color,
                perksColor: isCurrent ? Colors.white70 : AppColors.secondary,
                isCurrent: isCurrent,
                isUnlocked: currentStars >= stars,
                hasGoldBorder: isCurrent,
                onTap: () => _showLevelDetail(context, level, perks),
              ),
            );
          }),
      ],
    );
  }
}
