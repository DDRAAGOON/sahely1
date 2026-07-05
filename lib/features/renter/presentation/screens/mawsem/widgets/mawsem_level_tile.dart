import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';

class MawsemLevelTile extends StatelessWidget {
  final int number;
  final String name;
  final int stars;
  final IconData icon;
  final String perks;
  final Color bgColor;
  final Color textColor;
  final Color? iconColor;
  final Color? iconBgColor;
  final Color? perksColor;
  final bool isCurrent;
  final bool isUnlocked;
  final bool hasGoldBorder;
  final VoidCallback? onTap;

  const MawsemLevelTile({
    super.key,
    required this.number,
    required this.name,
    required this.stars,
    required this.icon,
    required this.perks,
    required this.bgColor,
    required this.textColor,
    this.iconColor,
    this.iconBgColor,
    this.perksColor,
    required this.isCurrent,
    required this.isUnlocked,
    this.hasGoldBorder = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveIconColor = iconColor ?? textColor;
    final effectiveIconBgColor = iconBgColor ?? effectiveIconColor.withValues(alpha: 0.1);
    
    // Determine stars badge colors based on level number
    Color badgeBg;
    Color badgeText;
    
    if (number == 7) {
      badgeBg = AppColors.gold;
      badgeText = AppColors.navy;
    } else if (isCurrent) {
      badgeBg = AppColors.gold;
      badgeText = AppColors.navy;
    } else if (number == 1 || number == 2) {
      badgeBg = AppColors.levelUnlockedBg; // #DFEDDE
      badgeText = AppColors.levelUnlockedText; // #5B926C
    } else if (number == 4 || number == 5 || number == 6) {
      badgeBg = AppColors.levelLockedBg; // #FBF3DE
      badgeText = AppColors.levelLockedText; // #9A7A22
    } else {
      badgeBg = isUnlocked 
          ? AppColors.levelUnlockedBg 
          : Colors.black.withValues(alpha: 0.05);
      badgeText = isUnlocked 
          ? AppColors.levelUnlockedText 
          : AppColors.secondary;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(13),
          border: (isCurrent || hasGoldBorder)
              ? Border.all(color: AppColors.gold, width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
            if (isCurrent)
              BoxShadow(
                color: AppColors.gold.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          children: [
            // Icon Box
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: effectiveIconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: effectiveIconColor, size: 22),
            ),
            const SizedBox(width: 8),

            // Name + Perks
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '$number · $name',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      if (isCurrent) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.gold,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'YOU',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.navy,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    perks,
                    style: TextStyle(
                      fontSize: 12,
                      color: perksColor ?? (isCurrent 
                          ? Colors.white.withValues(alpha: 0.7) 
                          : AppColors.secondary),
                      fontFamily: 'Cairo',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Stars Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: badgeBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$stars ',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: badgeText,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  Icon(Icons.star, size: 12, color: badgeText),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

