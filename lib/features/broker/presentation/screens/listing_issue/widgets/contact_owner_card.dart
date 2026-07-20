import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';

class ContactOwnerCard extends StatelessWidget {
  final String ownerName;
  final VoidCallback onTap;

  const ContactOwnerCard({
    super.key,
    required this.ownerName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFBF0), // Light gold/cream background
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.gold.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            // Phone Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.gold,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.phone,
                color: AppColors.navy,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            // Text
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.dark,
                    fontFamily: 'DM Sans',
                    height: 1.4,
                  ),
                  children: [
                    const TextSpan(
                      text: 'Reach out to the owner, ',
                    ),
                    TextSpan(
                      text: ownerName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                    const TextSpan(
                      text: ', and help them add what\'s needed — a quick morning re-shoot usually clears this within a day so you both start earning.',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}