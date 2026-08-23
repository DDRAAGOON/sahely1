import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/bouncy_button.dart';

class ReferPropertyBanner extends StatelessWidget {
  final VoidCallback onTap;

  const ReferPropertyBanner({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BouncyButton(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.gold,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.navy.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.person_add,
                color: AppColors.navy,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Refer a property',
                    style: AppTheme.dm(
                      size: 15,
                      weight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Earn 4% on every booking · share your code',
                    style: AppTheme.dm(
                      size: 12,
                      color: AppColors.navy.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: AppColors.navy,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chevron_right,
                color: Colors.white,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
