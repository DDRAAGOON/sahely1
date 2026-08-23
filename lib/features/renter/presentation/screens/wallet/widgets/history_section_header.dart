import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';

class HistorySectionHeader extends StatelessWidget {
  final String title;

  const HistorySectionHeader({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTheme.dm(
        size: 12,
        weight: FontWeight.w700,
        color: AppColors.secondary,
        letterSpacing: 1.2,
      ),
    );
  }
}
