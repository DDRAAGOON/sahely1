import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';

class CelebrationIcon extends StatelessWidget {
  final IconData icon;
  final Color color;

  const CelebrationIcon({
    super.key,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Main Icon Container
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 64,
          ),
        ),
        // Star Badge
        Positioned(
          bottom: -8,
          right: -8,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.gold,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: AppColors.gold.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.star,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}
