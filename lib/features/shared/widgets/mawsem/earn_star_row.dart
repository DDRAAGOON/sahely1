import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';

class EarnStarRow extends StatelessWidget {
  final IconData icon;
  final Widget title; // Changed from String to Widget for more flexibility
  final String subtitle;
  final String stars;
  final Color iconColor;
  final Color iconBgColor;
  final Color? rowBgColor;
  final bool showDivider;
  final Color? titleColor;
  final BorderRadius? borderRadius;

  const EarnStarRow({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.stars,
    required this.iconColor,
    required this.iconBgColor,
    this.rowBgColor,
    required this.showDivider,
    this.titleColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: rowBgColor,
        borderRadius: borderRadius,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    size: 18,
                    color: iconColor,
                  ),
                ),
                const SizedBox(width: 10),

                // Title + Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DefaultTextStyle(
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: titleColor ?? AppColors.navy,
                          fontFamily: 'Cairo',
                        ),
                        child: title,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.secondary,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                ),

                // Stars
                Text(
                  '$stars ★',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: titleColor ?? AppColors.gold,
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
          ),
          if (showDivider)
            Divider(
              height: 1,
              color: AppColors.border.withValues(alpha: 0.4),
              indent: 0,
              endIndent: 0,
            ),
        ],
      ),
    );
  }
}
