import 'package:flutter/material.dart';
import '../../../../data/models.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import 'common.dart';
import 'ui.dart';

/// Large hero property card (Trending Now / Browse results).
class PropertyCard extends StatelessWidget {
  const PropertyCard({super.key, required this.property, this.onTap, this.imageHeight = 150, this.showGuestFav = false});
  final Property property;
  final VoidCallback? onTap;
  final double imageHeight;
  final bool showGuestFav;

  @override
  Widget build(BuildContext context) {
    final p = property;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(color: Color(0x141B2744), blurRadius: 12, offset: Offset(0, 2))],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: imageHeight,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  SahelyImage(
                    imageUrl: p.image,
                    fadeColor: const Color(0x8CF5F0E8),
                    enableViewer: false,
                  ),
                  if (showGuestFav && p.guestFavourite)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.navy.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text('★ Guest favourite',
                            style: AppTheme.dm(size: 10, weight: FontWeight.w700, color: AppColors.white)),
                      ),
                    ),
                  Positioned(top: 12, right: 12, child: SaveHeart(property: p)),
                  Positioned(
                    left: 14,
                    right: 14,
                    bottom: 12,
                    child: Text(
                      p.name,
                      style: AppTheme.dm(size: 16, weight: FontWeight.w700, color: AppColors.white),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.location_on_outlined, size: 13, color: AppColors.muted),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    p.area,
                                    style: AppTheme.dm(size: 13, color: AppColors.muted),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            RatingRow(rating: p.rating, reviews: p.reviews),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      PriceTag(price: p.price),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: Wrap(
                      spacing: 7,
                      runSpacing: 7,
                      children: [
                        for (final t in p.tags) Pill(t, border: AppColors.navy, fg: AppColors.navy),
                        if (p.petsOk)
                          const Pill('🐾 Pets OK', bg: Color(0xFFD7EEDD), fg: AppColors.success)
                        else
                          const Pill('No pets', bg: Color(0xFFFDECEC), fg: Color(0xFFB22222)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Compact list card (Lagoon/Golden Dunes rows on the home feed).
class PropertyMiniCard extends StatelessWidget {
  const PropertyMiniCard({super.key, required this.property, this.onTap});
  final Property property;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final p = property;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(color: Color(0x141B2744), blurRadius: 12, offset: Offset(0, 2))],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 140,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  SahelyImage(
                    imageUrl: p.image,
                    fadeHeight: 60,
                    enableViewer: false,
                  ),
                  Positioned(top: 10, right: 10, child: SaveHeart(property: p)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 13),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p.name,
                              style: AppTheme.dm(size: 15, weight: FontWeight.w700, color: AppColors.navy),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                const Icon(Icons.location_on_outlined, size: 11, color: AppColors.muted),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    p.area,
                                    style: AppTheme.dm(size: 12, color: AppColors.muted),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      PriceTag(price: p.price, size: 15),
                    ],
                  ),
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 12, color: AppColors.gold),
                      const SizedBox(width: 4),
                      Text(p.rating.toString(), style: AppTheme.dm(size: 12, weight: FontWeight.w700)),
                      Expanded(
                        child: Text(
                          '  ·  ${p.beds} beds · ${p.type}',
                          style: AppTheme.dm(size: 12, color: AppColors.muted),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      for (final t in p.tags) Pill(t, bg: AppColors.cream, fg: AppColors.ink),
                      if (p.petsOk) const Pill('🐾 Pets OK', bg: Color(0xFFD7EEDD), fg: AppColors.success),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
