import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';

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
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: AppColors.secondary,
        fontFamily: 'DM Sans',
        letterSpacing: 1.2,
      ),
    );
  }
}
