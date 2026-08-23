import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';

class AccountVerificationBanner extends StatelessWidget {
  final VoidCallback onAddCardTap;

  const AccountVerificationBanner({
    super.key,
    required this.onAddCardTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF7EC), // Peach background
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Left Accent Bar
            Container(
              width: 5,
              color: const Color(0xFFD2760A),
            ),
            const SizedBox(width: 12),
            // Warning Icon
            const Icon(
              Icons.warning_amber_rounded,
              color: Color(0xFFD2760A),
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Account not verified',
                      style: AppTheme.dm(
                        size: 14,
                        weight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Add your card to withdraw earnings',
                      style: AppTheme.dm(
                        size: 12,
                        color: const Color(0xFF8A6A1E),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Add Card Button
            Padding(
              padding: const EdgeInsets.only(right: 14),
              child: GestureDetector(
                onTap: onAddCardTap,
                child: Text(
                  'Add Card →',
                  style: AppTheme.dm(
                    size: 13,
                    weight: FontWeight.w700,
                    color: const Color(0xFFD2760A),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}