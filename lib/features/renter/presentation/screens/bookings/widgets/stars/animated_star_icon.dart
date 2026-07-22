import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';

class AnimatedStarIcon extends StatelessWidget {
  const AnimatedStarIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      height: 96,
      decoration: BoxDecoration(
        color: AppColors.gold,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withValues(alpha: 0.4),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: const Icon(
        Icons.star,
        color: Colors.white,
        size: 48,
      ),
    );
  }
}
