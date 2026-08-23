import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';

class NotificationSectionHeader extends StatelessWidget {
  final String title;

  const NotificationSectionHeader({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTheme.dm(
        size: 11,
        weight: FontWeight.w700,
        color: AppColors.secondary,
        letterSpacing: 1.2,
      ),
    );
  }
}
