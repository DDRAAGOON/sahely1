import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/features/renter/presentation/screens/reviews/widgets/review_given_card.dart';
import 'package:sahely/l10n/app_localizations.dart';

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
          '${AppLocalizations.of(context).reviewsIGaveTab}  · $reviewCount',
          style: AppTheme.dm(
            size: 11,
            weight: FontWeight.w700,
            color: AppColors.secondary,
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
