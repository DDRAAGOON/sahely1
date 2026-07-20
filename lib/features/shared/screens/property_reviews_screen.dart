import 'package:flutter/material.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/kit.dart';

class PropertyReviewsScreen extends StatelessWidget {
  final Property? property;

  const PropertyReviewsScreen({super.key, this.property});

  @override
  Widget build(BuildContext context) {
    final pName = property?.name ?? 'Azure Beach Villa';
    final pRating = property?.rating ?? 4.8;

    return PhoneScaffold(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
            child: TopBar(
              title: 'Reviews',
              subtitle: pName,
              trailing: Row(
                children: [
                  const Icon(Icons.star, size: 14, color: AppColors.gold),
                  const SizedBox(width: 4),
                  Text('$pRating',
                      style: AppTheme.dm(
                          size: 14,
                          weight: FontWeight.w700,
                          color: AppColors.navy)),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),
              children: [
                _fullReview(
                    'Nour A.',
                    'Renter',
                    BadgeKind.renterLight,
                    5,
                    'Jun 2026',
                    'Absolutely stunning. The pool and sea views were unreal, and check-in via the smart lock was seamless. Highly recommend for families.'),
                const SizedBox(height: 12),
                _fullReview(
                    'Omar K.',
                    'Renter',
                    BadgeKind.renterLight,
                    5,
                    'May 2026',
                    'Spotless, exactly as pictured. Host was responsive and the location is unbeatable. Will book again next season.'),
                const SizedBox(height: 12),
                _fullReview('Sara M.', 'Broker', BadgeKind.gold, 4, 'May 2026',
                    'Great property for clients. Beautiful finish; only note is the beach can get busy on weekends, so arrive early.'),
                const SizedBox(height: 12),
                _fullReview(
                    'Hana T.',
                    'Renter',
                    BadgeKind.renterLight,
                    5,
                    'Apr 2026',
                    'The best stay I had in Sahel. The villa is modern and very clean. The private pool is a huge plus.'),
                const SizedBox(height: 12),
                _fullReview(
                    'Tarek S.',
                    'Renter',
                    BadgeKind.renterLight,
                    4,
                    'Mar 2026',
                    'Very nice place and great location. The smart lock made it very easy to check in and out.'),
                const SizedBox(height: 12),
                _fullReview(
                    'Layla M.',
                    'Renter',
                    BadgeKind.renterLight,
                    5,
                    'Feb 2026',
                    'Beautiful villa with amazing views. Everything was perfect.'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _fullReview(String name, String role, BadgeKind kind, int stars,
      String date, String body) {
    return WhiteCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                      colors: [Color(0xFFD8B98A), Color(0xFF7D5A2C)]),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(name,
                            style: AppTheme.dm(
                                size: 14,
                                weight: FontWeight.w700,
                                color: AppColors.navy)),
                        const SizedBox(width: 8),
                        StatusBadge(role, kind: kind),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        for (var i = 0; i < 5; i++)
                          Icon(Icons.star,
                              size: 12,
                              color: i < stars
                                  ? AppColors.gold
                                  : AppColors.border),
                        const SizedBox(width: 6),
                        Text(date,
                            style:
                                AppTheme.dm(size: 11, color: AppColors.muted)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(body,
              style: AppTheme.dm(size: 13, color: AppColors.ink, height: 1.5)),
        ],
      ),
    );
  }
}
