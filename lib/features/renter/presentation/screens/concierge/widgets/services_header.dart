import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';

class ServicesHeader extends StatelessWidget {
  const ServicesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Services',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 6),
        Text(
          'Elevate your stay with premium services',
          style: AppTheme.dm(
            size: 14,
            color: AppColors.secondary,
          ),
        ),
      ],
    );
  }
}
