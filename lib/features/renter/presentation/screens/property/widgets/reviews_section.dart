import 'package:flutter/material.dart';
import 'package:sahely/core/navigation/app_navigation.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/l10n/app_localizations.dart';

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
                    Text(
                      AppLocalizations.of(context).reviewsSection,
                      style: AppTheme.dm(
                        size: 16,
                        weight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.star, size: 16, color: AppColors.gold),
                    const SizedBox(width: 4),
                    Text(
                      '$rating',
                      style: AppTheme.dm(
                        size: 14,
                        weight: FontWeight.w600,
                        color: AppColors.dark,
                      ),
                    ),
                    Text(
                      '· $reviewCount',
                      style: AppTheme.dm(
                        size: 14,
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    AppNavigation.goToPropertyReviews(context);
                  },
                child: Text(
                    AppLocalizations.of(context).seeAll,
                    style: AppTheme.dm(
                      size: 13,
                      weight: FontWeight.w600,
                      color: AppColors.gold,
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
                          style: AppTheme.dm(
                            size: 14,
                            weight: FontWeight.w600,
                            color: AppColors.dark,
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
                            style: AppTheme.dm(
                              size: 11,
                              weight: FontWeight.w600,
                              color: AppColors.navy,
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
                          style: AppTheme.dm(
                            size: 12,
                            color: AppColors.secondary,
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
            style: AppTheme.dm(
              size: 13,
              color: AppColors.dark,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
