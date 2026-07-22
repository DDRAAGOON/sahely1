import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/common.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';

import 'package:sahely/core/widgets/image.dart';

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
  final VoidCallback? onPrimaryAction;
  final VoidCallback? onSecondaryAction;
  final VoidCallback? onSosAction;

  @override
  Widget build(BuildContext context) {
    final name = nameOverride ?? property?.name ?? 'Untitled';
    final img = property?.image;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
              color: Color(0x1F000000), blurRadius: 10, offset: Offset(0, 4))
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with soft fade
          if (img != null)
            SahelyImage(
              imageUrl: img,
              height: 160,
              width: double.infinity,
              showFade: true,
              fadeHeight: 60,
              fadeColor: AppColors.white,
              enableViewer: false,
            )
          else
            Container(
              height: 160,
              width: double.infinity,
              color: const Color(0xFFD8D2C6),
            ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Status Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: AppTheme.dm(
                          size: 18,
                          weight: FontWeight.w700,
                          color: AppColors.navy,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    StatusBadge(status,
                        kind: badgeKind, dot: badgeKind == BadgeKind.green),
                  ],
                ),
                const SizedBox(height: 4),
                // Meta Info
                Text(
                  meta,
                  style: AppTheme.dm(size: 13, color: const Color(0xFF5B5B5B)),
                ),
                if (stats.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  // Stats Pills
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
                        weight: FontWeight.w600),
                  ),
                ],
              ],
            ),
          ),

          // Action Bar
          const Divider(height: 1, color: Color(0x33000000)),
          IntrinsicHeight(
            child: Row(
              children: [
                _actionButton(
                  label: primaryActionLabel,
                  color: AppColors.navy,
                  onTap: onPrimaryAction,
                ),
                const VerticalDivider(
                    width: 1,
                    color: Color(0x33000000),
                    indent: 12,
                    endIndent: 12),
                _actionButton(
                  label: secondaryActionLabel,
                  color: AppColors.navy,
                  onTap: onSecondaryAction,
                ),
                if (onSosAction != null || stats.isNotEmpty) ...[
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
        ],
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
