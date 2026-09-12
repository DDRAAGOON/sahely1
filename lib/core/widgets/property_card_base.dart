import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/common.dart';
import 'package:sahely/core/widgets/image.dart';
import 'package:sahely/core/widgets/bouncy_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';
import 'package:sahely/l10n/app_localizations.dart';

/// Base layout for any property card in the app.
/// All 3 roles (Renter, Owner, Broker) use this same base.
class PropertyCardBase extends StatefulWidget {
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
    this.showLocation = true,
    this.showRating = true,
  });

  final Property property;
  final double imageHeight;
  final Widget? imageOverlay;
  final Widget? footerActions;
  final Widget? extraInfo;
  final VoidCallback? onTap;
  final bool showGuestFav;
  final String? nameOverride;
  final bool showLocation;
  final bool showRating;

  @override
  State<PropertyCardBase> createState() => _PropertyCardBaseState();
}

class _PropertyCardBaseState extends State<PropertyCardBase> {
  @override
  Widget build(BuildContext context) {
    final p = widget.property;
    return BouncyButton(
      onTap: widget.onTap,
      scale: 0.98,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppColors.cardShadow,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Image Section ───
            SizedBox(
              height: widget.imageHeight,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  SahelyImage(
                    imageUrl: p.image,
                    enableViewer: false,
                    fadeHeight: widget.imageHeight * 0.4,
                  ),
                  // Guest favourite badge
                  if (widget.showGuestFav && p.guestFavourite)
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
                        child: Text(
                            '★ ${AppLocalizations.of(context).guestFavourite}',
                            style: AppTheme.dm(
                                size: 10,
                                weight: FontWeight.w700,
                                color: AppColors.white)),
                      ),
                    ),
                  // Custom overlay (e.g. SaveHeart, badge, status)
                  if (widget.imageOverlay != null) widget.imageOverlay!,
                ],
              ),
            ),

            // ─── Info Section ───
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                              style: GoogleFonts.dmSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.navy),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (widget.showLocation) ...[
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
                            ],
                            if (widget.showRating) ...[
                              const SizedBox(height: 4),
                              RatingRow(rating: p.rating, reviews: p.reviews),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      PriceTag(price: p.price),
                    ],
                  ),

                  // Extra info slot (Owner stats, Broker commission, etc.)
                  if (widget.extraInfo != null) ...[
                    const SizedBox(height: 10),
                    widget.extraInfo!,
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
                          Pill('🐾 ${AppLocalizations.of(context).petsOk}',
                              bg: const Color(0xFFD7EEDD),
                              fg: AppColors.success)
                        else
                          Pill(AppLocalizations.of(context).noPets,
                              bg: const Color(0xFFFDECEC),
                              fg: const Color(0xFFB22222)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ─── Footer Actions ───
            if (widget.footerActions != null) ...[
              const Divider(height: 1, color: Color(0x33000000)),
              widget.footerActions!,
            ],
          ],
        ),
      ),
    );
  }
}
