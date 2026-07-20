import 'package:flutter/material.dart';

import '../../../../../../core/theme/app_colors.dart';

class ReviewGivenCard extends StatelessWidget {
  final String propertyName;
  final String propertyImage;
  final int rating;
  final String date;
  final String reviewText;

  const ReviewGivenCard({
    super.key,
    required this.propertyName,
    required this.propertyImage,
    required this.rating,
    required this.date,
    required this.reviewText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Property Info Row
          Row(
            children: [
              // Property Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  propertyImage,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 40,
                      height: 40,
                      color: AppColors.border,
                      child: const Icon(
                        Icons.image,
                        color: AppColors.secondary,
                        size: 20,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(width: 12),

              // Property Name + Stars
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      propertyName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.dark,
                        fontFamily: 'DM Sans',
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Stars
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < rating ? Icons.star : Icons.star_border,
                          size: 14,
                          color: AppColors.gold,
                        );
                      }),
                    ),
                  ],
                ),
              ),

              // Date
              Text(
                date,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.secondary,
                  fontFamily: 'DM Sans',
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Review Text
          Text(
            reviewText,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.dark,
              fontFamily: 'DM Sans',
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
