import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';

class LevelUnlockedText extends StatelessWidget {
  final int levelNumber;

  const LevelUnlockedText({
    super.key,
    required this.levelNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      'LEVEL $levelNumber UNLOCKED',
      style: AppTheme.dm(
        size: 12,
        weight: FontWeight.w700,
        color: AppColors.gold,
        letterSpacing: 2,
      ),
    );
  }
}
