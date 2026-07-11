import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sahely/core/providers/currency_provider.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../property/page/property_detail_screen.dart';
import '../../wishlist/presentation/widgets/heart_button.dart';

class PropertyCard extends StatelessWidget {
  final Map<String, dynamic>? property;
  const PropertyCard({super.key, this.property});

  @override
  Widget build(BuildContext context) {
    final currencyProvider = context.watch<CurrencyProvider>();
    final prop = property;
    final id = prop?['id']?.toString() ?? '1';
    final name = prop?['name']?.toString() ?? 'Azure Beach Villa';
    final location = prop?['location']?.toString() ?? 'North Coast';
    final priceInt = (prop?['price'] as num?)?.toInt() ?? 4500;
    final price = currencyProvider.formatPrice(priceInt.toDouble());
    final rating = (prop?['rating'] as num?)?.toDouble() ?? 4.8;
    final reviews = (prop?['reviewCount'] as num?)?.toInt() ?? 124;
    final imageUrl = prop?['imageUrl']?.toString() ?? 'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=800';
    final type = prop?['type']?.toString() ?? 'Villa';
    final features = prop?['features'] as List<dynamic>? ?? ['Pool', 'WiFi', 'Beachfront'];

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PropertyDetailScreen(
              propertyId: id,
              propertyName: name,
              propertyImage: imageUrl,
              location: location,
              rating: rating,
              reviewCount: reviews,
              pricePerNight: priceInt,
            ),
          ),
        );
      },
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

                  // Bottom fade gradient - WHITE SMOOTH BLEND
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
                    child: HeartButton(
                      propertyId: id,
                      propertyName: name,
                      propertyImage: imageUrl,
                      size: 34,
                    ),
                  ),

                  // Badges (Trending / Discount / New)
                  if (rating >= 4.8 && (int.tryParse(id) ?? 0) <= 5)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: _buildBadge('Trending', const Color(0xFFC62828), Colors.white),
                    )
                  else if (prop?['features']?.contains('Budget') ?? false)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: _buildBadge('-15%', AppColors.green, Colors.white),
                    )
                  else if ((int.tryParse(id) ?? 0) > 10)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: _buildBadge('New', AppColors.gold, AppColors.navy),
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
                      ...features.take(4).map((f) => _buildFeatureChip(f.toString())),
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

  Widget _buildBadge(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: textColor,
          fontFamily: 'Cairo',
        ),
      ),
    );
  }
}
