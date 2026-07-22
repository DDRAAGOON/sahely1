import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';

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
            // Text
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Account not verified',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                        fontFamily: 'DM Sans',
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Add your card to withdraw earnings',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF8A6A1E),
                        fontFamily: 'DM Sans',
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
                child: const Text(
                  'Add Card →',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFD2760A),
                    fontFamily: 'DM Sans',
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