import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/common.dart';
import 'package:sahely/core/widgets/property_card_base.dart' as base;
import 'package:sahely/features/shared/properties/domain/entities/property.dart';

/// Owner-specific property card with status, stats, and action buttons.
/// Uses [PropertyCardBase] under the hood with [extraInfo] and [footerActions] slots.
class OwnerPropertyCard extends StatelessWidget {
  const OwnerPropertyCard({
    super.key,
    required this.property,
    required this.status,
    required this.badgeKind,
    required this.meta,
    required this.stats,
    this.nameOverride,
    this.note,
    this.primaryActionLabel = 'Insights',
    this.secondaryActionLabel = 'Edit',
    this.primaryActionColor,
    this.secondaryActionColor,
    this.onPrimaryAction,
    this.onSecondaryAction,
    this.onSosAction,
  });

  final Property? property;
  final String status;
  final BadgeKind badgeKind;
  final String meta;
  final List<String> stats;
  final String? nameOverride;
  final String? note;
  final String primaryActionLabel;
  final String secondaryActionLabel;
  final Color? primaryActionColor;
  final Color? secondaryActionColor;
  final VoidCallback? onPrimaryAction;
  final VoidCallback? onSecondaryAction;
  final VoidCallback? onSosAction;

  @override
  Widget build(BuildContext context) {
    final bool isNotLive = status == 'Draft' || status == 'Under review';
    final displayName = nameOverride ?? property?.name ?? 'Untitled';
    final img = property?.image ?? '';

    // If it's not live and some fields are empty/zero, handle them
    final displayProperty = Property(
      name: displayName,
      area: property?.area ?? '',
      image: img,
      price: property?.price ?? 0,
      rating: property?.rating ?? 0.0,
      reviews: property?.reviews ?? 0,
      type: property?.type ?? (isNotLive ? '' : 'Chalet'),
    );

    return base.PropertyCardBase(
      property: displayProperty,
      imageHeight: 160,
      showGuestFav: false,
      showLocation: false,
      showRating: false,
      // If no image, show a placeholder
      imageOverlay: Stack(
        children: [
          if (img.isEmpty)
            Container(
              color: const Color(0xFFF1F5F9),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add_a_photo_outlined,
                        color: Color(0xFF94A3B8), size: 32),
                    const SizedBox(height: 8),
                    Text('No photos added',
                        style: AppTheme.dm(
                            size: 12, color: const Color(0xFF94A3B8))),
                  ],
                ),
              ),
            ),
          Positioned(
            top: 12,
            right: 12,
            child: StatusBadge(status,
                kind: badgeKind, dot: badgeKind == BadgeKind.green),
          ),
        ],
      ),
      // Extra info: meta + stats pills + note
      extraInfo: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (meta.isNotEmpty &&
              !meta.contains('0 beds') &&
              !meta.endsWith(' ·  · '))
            Text(
              meta,
              style: AppTheme.dm(size: 13, color: const Color(0xFF5B5B5B)),
            ),
          if (stats.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final s in stats)
                  Pill(
                    s,
                    bg: AppColors.white,
                    fg: AppColors.navy,
                    radius: 12,
                    border: AppColors.border,
                  ),
              ],
            ),
          ],
          if (note != null) ...[
            const SizedBox(height: 10),
            Text(
              note!,
              style: AppTheme.dm(
                size: 12,
                color: const Color(0xFFD2760A),
                weight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
      // Footer action buttons
      footerActions: IntrinsicHeight(
        child: Row(
          children: [
            _actionButton(
              label: primaryActionLabel,
              color: primaryActionColor ?? AppColors.navy,
              onTap: onPrimaryAction,
            ),
            if (onSecondaryAction != null) ...[
              const VerticalDivider(
                  width: 1,
                  color: Color(0x33000000),
                  indent: 12,
                  endIndent: 12),
              _actionButton(
                label: secondaryActionLabel,
                color: secondaryActionColor ?? AppColors.navy,
                onTap: onSecondaryAction,
              ),
            ],
            if (onSosAction != null) ...[
              const VerticalDivider(
                  width: 1,
                  color: Color(0x33000000),
                  indent: 12,
                  endIndent: 12),
              _actionButton(
                label: 'SOS',
                color: const Color(0xFFB22222),
                icon: Icons.warning_amber_rounded,
                onTap: onSosAction,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _actionButton({
    required String label,
    required Color color,
    IconData? icon,
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 14, color: color),
                const SizedBox(width: 4),
              ],
              Flexible(
                child: Text(
                  label,
                  style: AppTheme.dm(
                    size: 13,
                    weight: FontWeight.w700,
                    color: color,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
