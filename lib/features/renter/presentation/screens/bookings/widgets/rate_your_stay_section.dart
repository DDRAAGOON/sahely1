import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';

class RateYourStaySection extends StatelessWidget {
  final VoidCallback onAddReview;

  const RateYourStaySection({
    super.key,
    required this.onAddReview,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Rate your stay',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
            fontFamily: 'DM Sans',
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton.icon(
            onPressed: onAddReview,
            icon: const Icon(Icons.star, size: 18),
            label: const Text(
              'Add a review · earn +5',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'DM Sans',
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.gold, width: 1.5),
              foregroundColor: AppColors.gold,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
