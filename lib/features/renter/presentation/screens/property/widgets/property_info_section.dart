import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class PropertyInfoSection extends StatelessWidget {
  final String propertyName;
  final String location;
  final double rating;
  final int reviewCount;

  const PropertyInfoSection({
    super.key,
    required this.propertyName,
    required this.location,
    required this.rating,
    required this.reviewCount,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              propertyName,
              style: GoogleFonts.dmSans(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.navy,
              ),
            ),
            const SizedBox(height: 8),

            // Location
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: AppColors.secondary,
                ),
                const SizedBox(width: 4),
                Text(
                  location,
                  style: AppTheme.dm(
                    size: 14,
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Rating
            Row(
              children: [
                const Icon(
                  Icons.star,
                  size: 16,
                  color: AppColors.gold,
                ),
                const SizedBox(width: 4),
                Text(
                  '$rating',
                  style: AppTheme.dm(
                    size: 14,
                    weight: FontWeight.w600,
                    color: AppColors.dark,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '($reviewCount reviews)',
                  style: AppTheme.dm(
                    size: 14,
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Unit Info
            Row(
              children: [
                _buildUnitInfoItem('Unit 8-214', Icons.home),
                const SizedBox(width: 16),
                _buildUnitInfoItem('Floor 2 of 2', Icons.layers),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnitInfoItem(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.secondary),
        const SizedBox(width: 6),
        Text(
          text,
          style: AppTheme.dm(
            size: 13,
            color: AppColors.secondary,
          ),
        ),
      ],
    );
  }
}
