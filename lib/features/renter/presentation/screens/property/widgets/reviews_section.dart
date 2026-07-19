import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sahely/core/theme/app_colors.dart';

class ReviewsSection extends StatelessWidget {
  final double rating;
  final int reviewCount;

  const ReviewsSection({
    super.key,
    required this.rating,
    required this.reviewCount,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      'Reviews',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                        fontFamily: 'DM Sans',
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.star, size: 16, color: AppColors.gold),
                    const SizedBox(width: 4),
                    Text(
                      '$rating',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.dark,
                        fontFamily: 'DM Sans',
                      ),
                    ),
                    Text(
                      '· $reviewCount',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.secondary,
                        fontFamily: 'DM Sans',
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    context.push('/property-reviews');
                  },
                  child: const Text(
                    'See All',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.gold,
                      fontFamily: 'DM Sans',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Review Cards
            _buildReviewCard(
              'Nour A.',
              'Renter',
              5,
              'Jun 2026',
              'Absolutely stunning. The pool and sea views were unreal, and check-in via the smart lock was seamless.',
              Colors.blue,
            ),
            const SizedBox(height: 12),
            _buildReviewCard(
              'Omar K.',
              'Renter',
              5,
              'May 2026',
              'Spotless, exactly as pictured. Host was responsive and the location is unbeatable. Will book again.',
              const Color(0xFFC9A84C),
            ),
            const SizedBox(height: 12),
            _buildReviewCard(
              'Sara M.',
              'Broker',
              5,
              'May 2026',
              'Great property for clients. Beautiful finish; only note is the beach can get busy on weekends.',
              const Color(0xFFC9A84C),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewCard(
    String name,
    String role,
    int rating,
    String date,
    String comment,
    Color avatarColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: avatarColor.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.dark,
                            fontFamily: 'DM Sans',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.renterPillBg,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            role,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.navy,
                              fontFamily: 'DM Sans',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        ...List.generate(
                          rating,
                          (index) => const Icon(
                            Icons.star,
                            size: 12,
                            color: AppColors.gold,
                          ),
                        ),
                        const SizedBox(width: 6),
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
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            comment,
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
