import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';

class Pill extends StatelessWidget {
  const Pill(
    this.text, {
    super.key,
    this.bg,
    this.fg = AppColors.navy,
    this.border,
    this.radius = 8,
  });

  final String text;
  final Color? bg;
  final Color fg;
  final Color? border;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        border: border != null ? Border.all(color: border!) : null,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Text(text, style: AppTheme.dm(size: 11, color: fg)),
    );
  }
}
