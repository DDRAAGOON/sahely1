import 'package:flutter/material.dart';

import 'package:sahely/core/di/service_locator.dart' show sl;
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/kit.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';
import 'package:sahely/features/shared/reviews/domain/models/review.dart';
import 'package:sahely/features/shared/reviews/domain/repositories/review_repository.dart';

/// Every review of one listing (`GET /reviews?propertyId=`).
class PropertyReviewsScreen extends StatefulWidget {
  final Property? property;

  const PropertyReviewsScreen({super.key, this.property});

  @override
  State<PropertyReviewsScreen> createState() => _PropertyReviewsScreenState();
}

class _PropertyReviewsScreenState extends State<PropertyReviewsScreen> {
  late Future<List<Review>> _reviews = _load();

  Future<List<Review>> _load() {
    final id = widget.property?.id ?? '';
    if (id.isEmpty) return Future.value(const <Review>[]);
    return sl<ReviewRepository>().getPropertyReviews(id);
  }

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

  static (String, BadgeKind) _role(String role) => switch (role.toLowerCase()) {
        'broker' => ('Broker', BadgeKind.gold),
        'owner' => ('Owner', BadgeKind.navy),
        _ => ('Renter', BadgeKind.renterLight),
      };

  @override
  Widget build(BuildContext context) {
    final property = widget.property;
    final hasRating = property != null && property.reviews > 0;

    return PhoneScaffold(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
            child: TopBar(
              title: 'Reviews',
              subtitle: property?.name ?? '',
              trailing: Row(
                children: [
                  const Icon(Icons.star, size: 14, color: AppColors.gold),
                  const SizedBox(width: 4),
                  Text(hasRating ? property.rating.toStringAsFixed(1) : '—',
                      style: AppTheme.dm(
                          size: 14,
                          weight: FontWeight.w700,
                          color: AppColors.navy)),
                ],
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Review>>(
              future: _reviews,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(
                      child: CircularProgressIndicator(color: AppColors.gold));
                }
                if (snapshot.hasError) {
                  return Center(
                    child: TextButton(
                      onPressed: () => setState(() => _reviews = _load()),
                      child: Text('Could not load reviews. Tap to retry.',
                          style: AppTheme.dm(size: 14, color: AppColors.muted)),
                    ),
                  );
                }
                final reviews = snapshot.data ?? const <Review>[];
                if (reviews.isEmpty) {
                  return Center(
                    child: Text('No reviews yet.',
                        style: AppTheme.dm(size: 14, color: AppColors.muted)),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),
                  itemCount: reviews.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final r = reviews[index];
                    final (role, kind) = _role(r.userRole);
                    return _fullReview(
                        r.userName,
                        role,
                        kind,
                        r.rating.round(),
                        '${_months[r.createdAt.month - 1]} ${r.createdAt.year}',
                        r.comment);
                  },
                );
              },
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
                        Flexible(
                          child: Text(name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTheme.dm(
                                  size: 14,
                                  weight: FontWeight.w700,
                                  color: AppColors.navy)),
                        ),
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
