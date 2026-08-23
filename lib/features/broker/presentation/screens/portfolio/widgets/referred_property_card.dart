import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/utils/currency_formatter.dart';

class ReferredPropertyCard extends StatelessWidget {
  final Map<String, dynamic> property;
  final VoidCallback onTap;

  const ReferredPropertyCard({
    super.key,
    required this.property,
    required this.onTap,
  });

  String _formatPrice(int piastres) {
    return 'EGP ${CurrencyFormatter.formatNumber(piastres ~/ 100)}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderDefault),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with Status Badge
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: AspectRatio(
                    aspectRatio: 4 / 3,
                    child: Image.network(
                      property['imageUrl']?.toString() ?? '',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.border,
                          child: const Icon(
                            Icons.image,
                            color: AppColors.secondary,
                            size: 48,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // Accepted - Live Badge
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Accepted · Live',
                      style: AppTheme.dm(
                        size: 11,
                        weight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name & Location
                  Text(
                    property['name']?.toString() ?? '',
                    style: AppTheme.dm(
                      size: 16,
                      weight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 12,
                        color: AppColors.secondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        property['location']?.toString() ?? '',
                        style: AppTheme.dm(
                          size: 12,
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Rating & Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            size: 14,
                            color: AppColors.gold,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${property['rating']} · ${property['reviews']}',
                            style: AppTheme.dm(
                              size: 12,
                              weight: FontWeight.w600,
                              color: AppColors.ink,
                            ),
                          ),
                        ],
                      ),
                      RichText(
                        text: TextSpan(
                          style: AppTheme.dm(
                            size: 14,
                            weight: FontWeight.w700,
                            color: AppColors.navy,
                          ),
                          children: [
                            TextSpan(
                              text: _formatPrice(
                                  (property['pricePerNight'] ?? 0).toInt()),
                            ),
                            TextSpan(
                              text: '/night',
                              style: AppTheme.dm(
                                size: 11,
                                weight: FontWeight.w400,
                                color: AppColors.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Amenities
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: (property['amenities'] as List<dynamic>? ?? [])
                        .map((amenity) {
                      final name = amenity.toString();
                      final isPets = name == 'Pets' || name == 'Pets OK';
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isPets
                              ? const Color(0xFFE8F5E9)
                              : AppColors.cream,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.borderDefault),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isPets)
                              const Icon(
                                Icons.pets,
                                size: 12,
                                color: Color(0xFF2E7D32),
                              ),
                            if (isPets) const SizedBox(width: 4),
                            Text(
                              name,
                              style: AppTheme.dm(
                                size: 11,
                                weight: FontWeight.w500,
                                color: isPets
                                    ? const Color(0xFF2E7D32)
                                    : AppColors.ink,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
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
