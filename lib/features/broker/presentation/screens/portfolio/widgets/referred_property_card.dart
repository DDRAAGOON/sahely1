import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';

class ReferredPropertyCard extends StatelessWidget {
  final Map<String, dynamic> property;
  final VoidCallback onTap;

  const ReferredPropertyCard({
    super.key,
    required this.property,
    required this.onTap,
  });

  String _formatPrice(int piastres) {
    return 'EGP ${(piastres / 100).toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
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
                      color: AppColors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Accepted · Live',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontFamily: 'DM Sans',
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
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                      fontFamily: 'DM Sans',
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
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.secondary,
                          fontFamily: 'DM Sans',
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
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.dark,
                              fontFamily: 'DM Sans',
                            ),
                          ),
                        ],
                      ),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.navy,
                            fontFamily: 'DM Sans',
                          ),
                          children: [
                            TextSpan(
                              text: _formatPrice(
                                  (property['pricePerNight'] ?? 0).toInt()),
                            ),
                            const TextSpan(
                              text: '/night',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
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
                    children: (property['amenities'] as List<String>)
                        .map((amenity) {
                      final isPets = amenity == 'Pets';
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
                          border: Border.all(
                            color: isPets
                                ? const Color(0xFF2E7D32)
                                : AppColors.border,
                          ),
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
                              amenity,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: isPets
                                    ? const Color(0xFF2E7D32)
                                    : AppColors.dark,
                                fontFamily: 'DM Sans',
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