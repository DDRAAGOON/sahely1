import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';

class AskSahelyAiBanner extends StatelessWidget {
  final VoidCallback onTap;

  const AskSahelyAiBanner({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.navy,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            // AI Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.gold,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.auto_awesome,
                color: AppColors.navy,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ask Sahely AI',
                    style: AppTheme.dm(
                      size: 14,
                      weight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Questions about this stay — directions, parking, check-in',
                    style: AppTheme.dm(
                      size: 11,
                      color: const Color(0xFFB8C4E0),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chat_bubble_outline,
              color: AppColors.gold,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
