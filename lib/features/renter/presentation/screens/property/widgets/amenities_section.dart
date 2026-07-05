import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';

class AmenitiesSection extends StatelessWidget {
  const AmenitiesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Amenities',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.navy,
                fontFamily: 'DM Sans',
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                _AmenityItem(icon: Icons.pool, label: 'Private Pool'),
                SizedBox(width: 24),
                _AmenityItem(icon: Icons.wifi, label: 'Fast WiFi'),
                SizedBox(width: 24),
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
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.dark,
            fontFamily: 'DM Sans',
          ),
        ),
      ],
    );
  }
}
