import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';

class TopReferredPropertyCard extends StatelessWidget {
  final Map<String, dynamic> property;
  final VoidCallback onTap;

  const TopReferredPropertyCard({
    super.key,
    required this.property,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Property Header
            Row(
              children: [
                // Thumbnail
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    property['imageUrl']?.toString() ?? '',
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 64,
                        height: 64,
                        color: AppColors.border,
                        child: const Icon(
                          Icons.image,
                          color: AppColors.secondary,
                          size: 24,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        property['name']?.toString() ?? '',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy,
                          fontFamily: 'DM Sans',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Owner: ${property['owner']}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.secondary,
                          fontFamily: 'DM Sans',
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.secondary,
                  size: 20,
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Stats Row
            Row(
              children: [
                Expanded(
                  child: _StatBox(
                    value: '${property['daysRented']}',
                    label: 'days rented',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _StatBox(
                    value: property['avgNight']?.toString() ?? '',
                    label: 'avg/night',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _StatBox(
                    value: property['profit']?.toString() ?? '',
                    label: 'your profit',
                    valueColor: AppColors.gold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String value;
  final String label;
  final Color? valueColor;

  const _StatBox({
    required this.value,
    required this.label,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: valueColor ?? AppColors.navy,
              fontFamily: 'DM Sans',
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.secondary,
              fontFamily: 'DM Sans',
            ),
          ),
        ],
      ),
    );
  }
}