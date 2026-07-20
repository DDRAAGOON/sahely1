import 'package:flutter/material.dart';

import '../../../../../../core/theme/app_colors.dart';
import 'review_received_card.dart';

class ReviewsReceivedSection extends StatelessWidget {
  final int reviewCount;
  final List<Map<String, dynamic>> reviews;

  const ReviewsReceivedSection({
    super.key,
    required this.reviewCount,
    required this.reviews,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Text(
          'WHAT HOSTS SAY ABOUT ME · $reviewCount',
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.secondary,
            fontFamily: 'DM Sans',
            letterSpacing: 1.2,
          ),
        ),

        const SizedBox(height: 12),

        // Reviews List
        ...reviews.map((review) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ReviewReceivedCard(
              hostName: review['hostName'],
              hostRole: review['hostRole'],
              hostAvatar: review['hostAvatar'],
              rating: review['rating'],
              reviewText: review['reviewText'],
            ),
          );
        }),
      ],
    );
  }
}
