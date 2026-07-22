import 'package:flutter/material.dart';

import 'package:sahely/data/models.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';

enum BadgeKind {
  navy,
  green,
  greenSoft,
  gray,
  red,
  redSoft,
  orange,
  gold,
  renterLight
}

class StatusBadge extends StatelessWidget {
  const StatusBadge(this.label,
      {super.key, this.kind = BadgeKind.navy, this.dot = false});

  final String label;
  final BadgeKind kind;
  final bool dot;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (kind) {
      BadgeKind.navy => (AppColors.navy, AppColors.white),
      BadgeKind.green => (const Color(0xFF1B6B3A), AppColors.white),
      BadgeKind.greenSoft => (const Color(0xFFD7EEDD), AppColors.success),
      BadgeKind.gray => (const Color(0xFF717171), AppColors.white),
      BadgeKind.red => (const Color(0xFFB22222), AppColors.white),
      BadgeKind.redSoft => (const Color(0xFFFDECEC), const Color(0xFFB22222)),
      BadgeKind.orange => (const Color(0xFFFCEEDD), const Color(0xFFD2760A)),
      BadgeKind.gold => (const Color(0xFFF3E7C4), const Color(0xFF9A7A22)),
      BadgeKind.renterLight => (const Color(0xFFE6EAF2), AppColors.navy),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dot) ...[
            Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(color: fg, shape: BoxShape.circle)),
            const SizedBox(width: 5),
          ],
          Text(label,
              style: AppTheme.dm(size: 11, weight: FontWeight.w700, color: fg)),
        ],
      ),
    );
  }
}

/// Coloured role chip — Renter (navy) · Owner (green) · Broker (gold).
class RoleBadge extends StatelessWidget {
  const RoleBadge({super.key, required this.role});

  final Role role;

  @override
  Widget build(BuildContext context) {
    final (bg, fg, icon) = switch (role) {
      Role.renter => (
          const Color(0xFFE6EAF2),
          AppColors.navy,
          Icons.person_outline
        ),
      Role.owner => (
          const Color(0xFFDCEFE2),
          AppColors.owner,
          Icons.apartment_outlined
        ),
      Role.broker => (
          const Color(0xFFF6EAC9),
          const Color(0xFF8A6D1E),
          Icons.handshake_outlined
        ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: fg),
          const SizedBox(width: 6),
          Text(role.shortLabel,
              style: AppTheme.dm(size: 12, weight: FontWeight.w700, color: fg)),
        ],
      ),
    );
  }
}
