import 'package:flutter/material.dart';
import 'package:sahely/core/navigation/app_navigation.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/utils/currency_formatter.dart';
import 'package:sahely/features/renter/presentation/screens/wishlist/presentation/widgets/heart_button.dart';

class SearchResultCard extends StatelessWidget {
  final Map<String, dynamic> property;

  const SearchResultCard({
    super.key,
    required this.property,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppNavigation.goToPropertyDetail(context, extra: property);
      },
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
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Stack(
                children: [
                  // Property Image
                  AspectRatio(
                    aspectRatio: 4 / 3,
                    child: Image.network(
                      property['imageUrl'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.border,
                          child: const Icon(
                            Icons.image,
                            color: AppColors.placeholder,
                            size: 48,
                          ),
                        );
                      },
                    ),
                  ),

                  // Bottom Fade Gradient
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

                  // Guest Favourite Badge
                  if (property['badge'] != null)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.guestFavouriteBg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star,
                              color: AppColors.gold,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              property['badge'],
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.white,
                                fontFamily: 'DM Sans',
                              ),
                            ),
                          ],
                        ),
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

                  // Property Name Overlay
                  Positioned(
                    bottom: 12,
                    left: 12,
                    right: 12,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          property['name'],
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
                              color: AppColors.navy,
                              size: 12,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                '${property['location']} Â· ${property['distanceToBeach']}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.navy,
                                  fontFamily: 'DM Sans',
                                ),
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
                          const Icon(
                            Icons.star,
                            size: 14,
                            color: AppColors.gold,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            property['rating'].toString(),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.dark,
                              fontFamily: 'DM Sans',
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${property['reviewCount']} reviews)',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.secondary,
                              fontFamily: 'DM Sans',
                            ),
                          ),
                        ],
                      ),

                      // Price
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: CurrencyFormatter.format(property['price']),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.navy,
                                fontFamily: 'DM Sans',
                              ),
                            ),
                            const TextSpan(
                              text: ' /night',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF717171),
                                fontFamily: 'DM Sans',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Feature Chips
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      _buildFeatureChip(property['type']),
                      _buildFeatureChip('${property['beds']} beds'),
                      _buildFeatureChip('${property['guests']} guests'),
                      ...List.generate(
                        property['features'].length,
                        (index) => _buildFeatureChip(
                          property['features'][index],
                          isSpecial: property['features'][index] == 'Pets OK',
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
    );
  }

  Widget _buildFeatureChip(String label, {bool isSpecial = false}) {
    Color? backgroundColor = AppColors.white;
    Color? textColor;
    Color borderColor = AppColors.navy;

    if (isSpecial && label == 'Pets OK') {
      backgroundColor = const Color(0xFFE8F5E9);
      textColor = const Color(0xFF2E7D32);
      borderColor = const Color(0xFF2E7D32);
    } else if (label == 'No pets') {
      backgroundColor = const Color(0xFFEFEBE9);
      textColor = const Color(0xFFC62828);
      borderColor = const Color(0xFFC62828);
    } else {
      textColor = AppColors.navy;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: textColor,
          fontFamily: 'DM Sans',
        ),
      ),
    );
  }
}
