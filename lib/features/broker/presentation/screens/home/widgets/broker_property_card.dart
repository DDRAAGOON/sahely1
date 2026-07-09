import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../wishlist/widgets/broker_heart_button.dart';

class BrokerPropertyCard extends StatelessWidget {
  final Map<String, dynamic> property;
  final VoidCallback onTap;
  final VoidCallback onWishlistTap;

  const BrokerPropertyCard({
    super.key,
    required this.property,
    required this.onTap,
    required this.onWishlistTap,
  });

  String _formatPrice(int piastres) {
    return 'EGP ${(piastres / 100).toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    final name = property['name'] ?? '';
    final location = property['location'] ?? '';
    final imageUrl = property['imageUrl'] ?? '';
    final rating = property['rating'] ?? 0.0;
    final reviews = property['reviews'] ?? 0;
    final price = _formatPrice(property['pricePerNight'] ?? 0);
    final type = property['type'] ?? 'Villa';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.navy.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Stack(
                children: [
                  // Property Image
                  Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  // Bottom fade gradient
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            AppColors.white.withValues(alpha: 0.95),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Heart Button
                  Positioned(
                    top: 12,
                    right: 12,
                    child: BrokerHeartButton(
                      propertyId: property['id'] ?? '',
                      propertyName: property['name'] ?? '',
                      propertyImage: property['imageUrl'] ?? '',
                      size: 34,
                    ),
                  ),

                  // Property Name & Location Overlay
                  Positioned(
                    bottom: 12,
                    left: 12,
                    right: 12,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.navy,
                            fontFamily: 'Cairo',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: AppColors.navy, size: 14),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                '$location · 3 min to beach',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.navy,
                                  fontFamily: 'Cairo',
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Info Section
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Rating & Price Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Rating
                      Row(
                        children: [
                          const Icon(Icons.star, size: 16, color: AppColors.gold),
                          const SizedBox(width: 4),
                          Text(
                            rating.toString(),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.dark,
                              fontFamily: 'Cairo',
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '($reviews reviews)',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.secondary,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ],
                      ),
                      // Price
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: price,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.navy,
                                fontFamily: 'Cairo',
                              ),
                            ),
                            const TextSpan(
                              text: ' /night',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.secondary,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Features Wrap
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildFeatureChip(type),
                      _buildFeatureChip('3 beds'),
                      _buildFeatureChip('6 guests'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.navy, width: 1),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          color: AppColors.navy,
          fontFamily: 'Cairo',
        ),
      ),
    );
  }
}
