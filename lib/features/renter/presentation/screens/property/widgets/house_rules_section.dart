import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';
import 'package:sahely/l10n/app_localizations.dart';

/// Check-in, check-out and the cancellation policy — the only house rules
/// the listing data carries. Pets, parties and mixed groups are not part of
/// it, so they are not claimed here.
class HouseRulesSection extends StatelessWidget {
  const HouseRulesSection({super.key, this.property});

  /// Null until the listing is loaded.
  final Property? property;

  /// `16:00:00` -> `4:00 PM`.
  static String _time(String raw) {
    final parts = raw.split(':');
    if (parts.length < 2) return raw;
    final hour = int.tryParse(parts.first) ?? 0;
    final minute = parts[1].padLeft(2, '0');
    final suffix = hour < 12 ? 'AM' : 'PM';
    final display = hour % 12 == 0 ? 12 : hour % 12;
    return '$display:$minute $suffix';
  }

  @override
  Widget build(BuildContext context) {
    final listing = property;
    if (listing == null) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context).houseRules,
              style: AppTheme.dm(
                size: 16,
                weight: FontWeight.w700,
                color: AppColors.navy,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  if (listing.checkInTime.isNotEmpty) ...[
                    _RuleRow(
                      icon: Icons.login,
                      label: 'Check-in',
                      value: _time(listing.checkInTime),
                    ),
                    _Divider(),
                  ],
                  if (listing.checkOutTime.isNotEmpty) ...[
                    _RuleRow(
                      icon: Icons.logout,
                      label: 'Check-out',
                      value: _time(listing.checkOutTime),
                    ),
                    _Divider(),
                  ],
                  _RuleRow(
                    icon: Icons.event_busy,
                    label: 'Cancellation',
                    value: listing.cancellationPolicy.isEmpty
                        ? '—'
                        : '${listing.cancellationPolicy[0].toUpperCase()}'
                            '${listing.cancellationPolicy.substring(1)}',
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

class _RuleRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;

  const _RuleRow({
    required this.icon,
    required this.label,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.navy),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: AppTheme.dm(
                size: 12,
                color: AppColors.dark,
              ),
            ),
          ),
          Text(
            value ?? '',
            style: AppTheme.dm(
              size: 12,
              weight: FontWeight.w600,
              color: AppColors.dark,
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      color: AppColors.border,
      indent: 16,
      endIndent: 16,
    );
  }
}
