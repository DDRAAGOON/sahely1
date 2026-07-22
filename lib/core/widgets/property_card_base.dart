import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/common.dart';
import 'package:sahely/core/widgets/image.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';

/// Base layout for any property card in the app.
/// All 3 roles (Renter, Owner, Broker) use this same base.
///
/// Slots for customisation:
/// - [imageOverlay]: Widgets positioned on top of the image (e.g. SaveHeart, badge, status)
/// - [footerActions]: Row of buttons below the card (e.g. Insights | Edit | SOS)
/// - [extraInfo]: Additional widgets between pricing and tags (e.g. Owner stats, Broker commission)
class PropertyCardBase extends StatelessWidget {
  const PropertyCardBase({
    super.key,
    required this.property,
    this.imageHeight = 150,
    this.imageOverlay,
    this.footerActions,
    this.extraInfo,
    this.onTap,
    this.showGuestFav = false,
    this.nameOverride,
  });

  final Property property;
  final double imageHeight;
  final Widget? imageOverlay;
  final Widget? footerActions;
  final Widget? extraInfo;
  final VoidCallback? onTap;
  final bool showGuestFav;
  final String? nameOverride;

  @override
  Widget build(BuildContext context) {
    final p = property;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
                color: Color(0x141B2744), blurRadius: 12, offset: Offset(0, 2)),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Image Section ───
            SizedBox(
              height: imageHeight,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  SahelyImage(
                    imageUrl: p.image,
                    enableViewer: false,
                    fadeHeight: imageHeight * 0.4,
                  ),
                  // Guest favourite badge
                  if (showGuestFav && p.guestFavourite)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.navy.withValues(alpha: 0.55),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text('★ Guest favourite',
                            style: AppTheme.dm(
                                size: 10,
                                weight: FontWeight.w700,
                                color: AppColors.white)),
                      ),
                    ),
                  // Custom overlay (e.g. SaveHeart, badge, status)
                  if (imageOverlay != null) imageOverlay!,
                ],
              ),
            ),

            // ─── Info Section ───
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + Location + Price Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p.name,
                              style: AppTheme.dm(
                                  size: 16,
                                  weight: FontWeight.w700,
                                  color: AppColors.navy),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.location_on_outlined,
                                    size: 13, color: AppColors.muted),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    p.area,
                                    style: AppTheme.dm(
                                        size: 13, color: AppColors.muted),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            RatingRow(rating: p.rating, reviews: p.reviews),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      PriceTag(price: p.price),
                    ],
                  ),

                  // Extra info slot (Owner stats, Broker commission, etc.)
                  if (extraInfo != null) ...[
                    const SizedBox(height: 10),
                    extraInfo!,
                  ],

                  // Tags
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: Wrap(
                      spacing: 7,
                      runSpacing: 7,
                      children: [
                        for (final t in p.tags)
                          Pill(t, border: AppColors.navy, fg: AppColors.navy),
                        if (p.petsOk)
                          const Pill('🐾 Pets OK',
                              bg: Color(0xFFD7EEDD), fg: AppColors.success)
                        else
                          const Pill('No pets',
                              bg: Color(0xFFFDECEC), fg: Color(0xFFB22222)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ─── Footer Actions ───
            if (footerActions != null) ...[
              const Divider(height: 1, color: Color(0x33000000)),
              footerActions!,
            ],
          ],
        ),
      ),
    );
  }
}
