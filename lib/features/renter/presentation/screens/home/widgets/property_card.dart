import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sahely/core/providers/currency_provider.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../wishlist/presentation/widgets/heart_button.dart';
import 'property_section.dart';

class PropertyCard extends StatelessWidget {
  final Map<String, dynamic> property;
  final PropertyBadge badgeType;
  final VoidCallback onTap;

  const PropertyCard({
    super.key,
    required this.property,
    required this.badgeType,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final currencyProvider = context.watch<CurrencyProvider>();
    final discount = property['discount'];
    final priceInt = (property['pricePerNight'] as num?)?.toInt() ?? 0;
    final price = currencyProvider.formatPrice(priceInt.toDouble());
    final features = property['features'] as List<dynamic>? ?? [];

    return GestureDetector(
      onTap: onTap,
      child: Container(
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
                  Image.network(
                    property['imageUrl'],
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 180,
                        color: AppColors.border,
                        child: const Icon(Icons.image, color: AppColors.secondary, size: 48),
                      );
                    },
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

                  // Badge
                  if (badgeType == PropertyBadge.discount && discount != null)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: AppColors.green, borderRadius: BorderRadius.circular(6)),
                        child: Text('-$discount%', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white, fontFamily: 'Cairo')),
                      ),
                    )
                  else if (badgeType == PropertyBadge.trending)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: const Color(0xFFC62828), borderRadius: BorderRadius.circular(6)),
                        child: const Text('Trending', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white, fontFamily: 'Cairo')),
                      ),
                    )
                  else if (badgeType == PropertyBadge.newlyAdded)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: AppColors.gold, borderRadius: BorderRadius.circular(6)),
                        child: const Text('New', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.navy, fontFamily: 'Cairo')),
                      ),
                    ),

                  // Heart Button
                  Positioned(
                    top: 12,
                    right: 12,
                    child: HeartButton(
                      propertyId: property['id'],
                      propertyName: property['name'],
                      propertyImage: property['imageUrl'],
                    ),
                  ),

                  // Name & Location Overlay
                  Positioned(
                    bottom: 12,
                    left: 12,
                    right: 12,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          property['name'],
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.navy, fontFamily: 'Cairo'),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: AppColors.navy, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              '${property['location']} · 3 min to beach',
                              style: const TextStyle(fontSize: 13, color: AppColors.navy, fontFamily: 'Cairo'),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, size: 16, color: AppColors.gold),
                          const SizedBox(width: 4),
                          Text('${property['rating']}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.dark, fontFamily: 'Cairo')),
                          const SizedBox(width: 4),
                          Text('(${property['reviewCount'] ?? 0} reviews)', style: const TextStyle(fontSize: 14, color: AppColors.secondary, fontFamily: 'Cairo')),
                        ],
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(text: price, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.navy, fontFamily: 'Cairo')),
                            const TextSpan(text: ' /night', style: TextStyle(fontSize: 12, color: AppColors.secondary, fontFamily: 'Cairo')),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildFeatureChip(property['type'] ?? 'Villa'),
                      _buildFeatureChip('${property['beds']} beds'),
                      ...features.take(3).map((f) => _buildFeatureChip(f.toString())),
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
      child: Text(label, style: const TextStyle(fontSize: 12, color: AppColors.navy, fontFamily: 'Cairo')),
    );
  }
}
