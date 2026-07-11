import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';
import 'review_given_card.dart';

class ReviewsGivenSection extends StatelessWidget {
  final int reviewCount;
  final List<Map<String, dynamic>> reviews;

  const ReviewsGivenSection({
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
          'REVIEWS I GAVE · $reviewCount',
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
            child: ReviewGivenCard(
              propertyName: review['propertyName'],
              propertyImage: review['propertyImage'],
              rating: review['rating'],
              date: review['date'],
              reviewText: review['reviewText'],
            ),
          );
        }),
      ],
    );
  }
}
