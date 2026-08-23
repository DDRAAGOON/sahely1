import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';

class ReviewSection extends StatelessWidget {
  final bool hasReview;
  final int? rating;
  final String? reviewText;
  final VoidCallback onWriteReview;

  const ReviewSection({
    super.key,
    required this.hasReview,
    this.rating,
    this.reviewText,
    required this.onWriteReview,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How was your stay?',
            style: AppTheme.dm(
              size: 16,
              weight: FontWeight.w700,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 16),
          if (hasReview && rating != null) ...[
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < rating! ? Icons.star : Icons.star,
                  size: 28,
                  color: index < rating!
                      ? AppColors.gold
                      : const Color(0xFFEFE9DD),
                );
              }),
            ),
            if (reviewText != null) ...[
              const SizedBox(height: 12),
              Text(
                reviewText!,
                style: AppTheme.dm(
                  size: 14,
                  color: AppColors.secondary,
                  height: 1.5,
                ),
              ),
            ],
          ] else ...[
            Row(
              children: List.generate(5, (index) {
                return const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(
                    Icons.star,
                    size: 32,
                    color: Color(0xFFEFE9DD), // Light muted stars as in image
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: onWriteReview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.navy,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.star, color: Color(0xFFC9A84C), size: 18),
                    const SizedBox(width: 8),
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
        ],
      ),
    );
  }
}
