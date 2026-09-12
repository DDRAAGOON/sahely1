import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class PropertyInfoSection extends StatelessWidget {
  final String propertyName;
  final String location;
  final double rating;
  final int reviewCount;

  /// The unit and floor the listing records, when it has them.
  final String unit;
  final int? floor;

  const PropertyInfoSection({
    super.key,
    required this.propertyName,
    required this.location,
    required this.rating,
    required this.reviewCount,
    this.unit = '',
    this.floor,
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
            if (unit.isNotEmpty || floor != null)
              Row(
                children: [
                  if (unit.isNotEmpty)
                    _buildUnitInfoItem('Unit $unit', Icons.home),
                  if (unit.isNotEmpty && floor != null)
                    const SizedBox(width: 16),
                  if (floor != null)
                    _buildUnitInfoItem('Floor $floor', Icons.layers),
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
