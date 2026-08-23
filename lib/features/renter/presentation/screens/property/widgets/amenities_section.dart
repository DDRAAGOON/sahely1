import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';

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
              'Amenities',
              style: AppTheme.dm(
                size: 16,
                weight: FontWeight.w700,
                color: AppColors.navy,
              ),
            ),
            const SizedBox(height: 12),
            const Wrap(
              spacing: 24,
              runSpacing: 12,
              children: [
                _AmenityItem(icon: Icons.pool, label: 'Private Pool'),
                _AmenityItem(icon: Icons.wifi, label: 'Fast Wi-Fi'),
                _AmenityItem(icon: Icons.local_parking, label: 'Free Parking'),
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
