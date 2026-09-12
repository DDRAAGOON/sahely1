import 'package:flutter/material.dart';

import 'package:sahely/core/di/service_locator.dart' show sl;
import 'package:sahely/core/navigation/app_navigation.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/features/shared/reviews/domain/models/review.dart';
import 'package:sahely/features/shared/reviews/domain/repositories/review_repository.dart';
import 'package:sahely/l10n/app_localizations.dart';

/// The first reviews of a listing on its page (`GET /reviews?propertyId=`).
class ReviewsSection extends StatefulWidget {
  final String propertyId;
  final String propertyName;
  final double rating;
  final int reviewCount;

  const ReviewsSection({
    super.key,
    this.propertyId = '',
    this.propertyName = '',
    required this.rating,
    required this.reviewCount,
  });

  @override
  State<ReviewsSection> createState() => _ReviewsSectionState();
}

class _ReviewsSectionState extends State<ReviewsSection> {
  List<Review> _reviews = const [];
  bool _loaded = false;

  static const _avatarColors = [Colors.blue, Color(0xFFC9A84C)];

  static const _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    var reviews = const <Review>[];
    if (widget.propertyId.isNotEmpty) {
      try {
        reviews =
            await sl<ReviewRepository>().getPropertyReviews(widget.propertyId);
      } catch (_) {}
    }
    if (mounted) {
      setState(() {
        _reviews = reviews;
        _loaded = true;
      });
    }
  }

  static String _role(String role) => switch (role.toLowerCase()) {
        'broker' => 'Broker',
        'owner' => 'Owner',
        _ => 'Renter',
      };

  @override
  Widget build(BuildContext context) {
    final recent = _reviews.take(3).toList();
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
                      widget.reviewCount == 0
                          ? '—'
                          : widget.rating.toStringAsFixed(1),
                      style: AppTheme.dm(
                        size: 14,
                        weight: FontWeight.w600,
                        color: AppColors.dark,
                      ),
                    ),
                    Text(
                      '· ${widget.reviewCount}',
                      style: AppTheme.dm(
                        size: 14,
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    AppNavigation.goToPropertyReviews(context, extra: {
                      'id': widget.propertyId,
                      'name': widget.propertyName,
                      'rating': widget.rating,
                      'reviewCount': widget.reviewCount,
                    });
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

            // Review cards
            if (_loaded && recent.isEmpty)
              Text('No reviews yet.',
                  style: AppTheme.dm(size: 13, color: AppColors.muted)),
            for (var i = 0; i < recent.length; i++) ...[
              if (i > 0) const SizedBox(height: 12),
              _buildReviewCard(
                recent[i].userName,
                _role(recent[i].userRole),
                recent[i].rating.round().clamp(0, 5),
                '${_months[recent[i].createdAt.month - 1]} ${recent[i].createdAt.year}',
                recent[i].comment,
                _avatarColors[i % 2],
              ),
            ],

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
                        Flexible(
                          child: Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTheme.dm(
                              size: 14,
                              weight: FontWeight.w600,
                              color: AppColors.dark,
                            ),
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
