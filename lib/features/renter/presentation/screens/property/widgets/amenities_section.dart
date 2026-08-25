import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/l10n/app_localizations.dart';

class AmenitiesSection extends StatelessWidget {
  const AmenitiesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).amenitiesTitle,
              style: AppTheme.dm(
                size: 16,
                weight: FontWeight.w700,
                color: AppColors.navy,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 24,
              runSpacing: 12,
              children: [
                _AmenityItem(icon: Icons.pool, label: AppLocalizations.of(context).amenityPool),
                _AmenityItem(icon: Icons.wifi, label: AppLocalizations.of(context).amenityWifi),
                _AmenityItem(icon: Icons.local_parking, label: AppLocalizations.of(context).amenityParking),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AmenityItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _AmenityItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 17, color: AppColors.navy),
        const SizedBox(width: 8),
        Text(
          label,
          style: AppTheme.dm(
            size: 13,
            color: AppColors.dark,
          ),
        ),
      ],
    );
  }
}
