import 'package:flutter/material.dart';

import 'package:sahely/features/shared/widgets/mawsem/level/level_perk.dart';

class SeasonPerkItem extends StatelessWidget {
  final LevelPerk perk;
  final Color perkColor;

  const SeasonPerkItem({
    super.key,
    required this.perk,
    required this.perkColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Perk Check Icon Box
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: perkColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.check,
            color: perkColor,
            size: 18,
          ),
        ),
        const SizedBox(width: 14),
        // Perk Text Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                perk.title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1B2744),
                  fontFamily: 'DM Sans',
                ),
              ),
              if (perk.subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  perk.subtitle!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9CA3AF),
                    fontFamily: 'DM Sans',
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
