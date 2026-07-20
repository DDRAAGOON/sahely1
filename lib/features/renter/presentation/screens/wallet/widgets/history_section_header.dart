import 'package:flutter/material.dart';

import '../../../../../../core/theme/app_colors.dart';

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
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppColors.secondary,
        fontFamily: 'DM Sans',
        letterSpacing: 1.2,
      ),
    );
  }
}
