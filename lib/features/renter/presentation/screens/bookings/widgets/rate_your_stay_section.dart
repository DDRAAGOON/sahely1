import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';

class RateYourStaySection extends StatelessWidget {
  final VoidCallback onAddReview;

  const RateYourStaySection({
    super.key,
    required this.onAddReview,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How was your stay?',
            style: AppTheme.dm(
              size: 18,
              weight: FontWeight.w700,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: List.generate(5, (index) {
              return const Padding(
                padding: EdgeInsets.only(right: 6),
                child: Icon(Icons.star_border, color: Color(0xFFE0E0E0), size: 28),
              );
            }),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: onAddReview,
            child: Container(
              height: 54,
              decoration: BoxDecoration(
                color: AppColors.navy,
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.star, color: AppColors.gold, size: 18),
                  const SizedBox(width: 10),
                  Text(
                    'Write a review · earn +5 ★',
                    style: AppTheme.dm(
                      size: 15,
                      weight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
