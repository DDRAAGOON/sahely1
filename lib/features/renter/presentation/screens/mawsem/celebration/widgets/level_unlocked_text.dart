import 'package:flutter/material.dart';
import '../../../../../../../../core/theme/app_colors.dart';

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
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppColors.gold,
        fontFamily: 'DM Sans',
        letterSpacing: 2,
      ),
    );
  }
}
