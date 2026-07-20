import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';

class ReferPropertyHeader extends StatelessWidget {
  const ReferPropertyHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Refer a Property',
          style: AppTheme.dm(
            size: 24,
            weight: FontWeight.w700,
            color: AppColors.navy,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Refer a property owner and earn commissions on every booking',
          style: AppTheme.dm(
            size: 14,
            color: AppColors.muted,
          ),
        ),
      ],
    );
  }
}
