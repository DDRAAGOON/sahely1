import 'package:flutter/material.dart';
import '../../../../../../../core/theme/app_colors.dart';
import 'level_perk.dart';
import 'season_perk_item.dart';

class SeasonPerksSection extends StatelessWidget {
  final List<LevelPerk> perks;
  final Color perkColor;

  const SeasonPerksSection({
    super.key,
    required this.perks,
    required this.perkColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Season Perks',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.navy,
              fontFamily: 'DM Sans',
            ),
          ),
          const SizedBox(height: 12),
          ...perks.map((perk) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: SeasonPerkItem(
                perk: perk,
                perkColor: perkColor,
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
