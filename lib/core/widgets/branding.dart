import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';

/// "SAHELY" wordmark.
class Wordmark extends StatelessWidget {
  const Wordmark(
      {super.key,
      this.size = 24,
      this.color = AppColors.white,
      this.spacing = 5});

  final double size;
  final Color color;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Text('SAHELY',
        style: AppTheme.dm(
            size: size,
            weight: FontWeight.w700,
            color: color,
            letterSpacing: spacing));
  }
}

/// Progress dots for carousels or onboarding.
class ProgressDots extends StatelessWidget {
  const ProgressDots({super.key, required this.count, required this.active});

  final int count;
  final int active;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final on = i == active;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: on ? 22 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: on ? AppColors.gold : const Color(0xFFD8CDBB),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
