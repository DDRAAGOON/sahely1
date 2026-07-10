import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';

class BrokerCollectionPropertyCard extends StatelessWidget {
  final String propertyName;
  final String location;
  final String propertyType;
  final int beds;
  final List<String> amenities;
  final double rating;
  final int reviewCount;
  final int pricePerNight;
  final String imageUrl;
  final String friendNote;
  final Color friendAvatarColor;
  final VoidCallback onTap;

  const BrokerCollectionPropertyCard({
    super.key,
    required this.propertyName,
    required this.location,
    required this.propertyType,
    required this.beds,
    required this.amenities,
    required this.rating,
    required this.reviewCount,
    required this.pricePerNight,
    required this.imageUrl,
    required this.friendNote,
    required this.friendAvatarColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final egpPrice = pricePerNight.toString(); 

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(
                      imageUrl,
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
                  // Bottom fade
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 80,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            AppColors.white.withOpacity(0.9),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Property name overlay
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Text(
                      propertyName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                        fontFamily: 'DM Sans',
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: AppColors.secondary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          location,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.secondary,
                            fontFamily: 'DM Sans',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Chips
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      _buildChip(propertyType),
                      _buildChip('$beds beds'),
                      ...amenities.map((amenity) => _buildChip(
                            amenity,
                            isSpecial: amenity == 'Pets' || amenity == 'No pets',
                            isPositive: amenity == 'Pets',
                          )),
                    ],
                  ),
                  const SizedBox(height: 10),
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
                            '$rating',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.dark,
                              fontFamily: 'DM Sans',
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '($reviewCount)',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.secondary,
                              fontFamily: 'DM Sans',
                            ),
                          ),
                        ],
                      ),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.navy,
                            fontFamily: 'DM Sans',
                          ),
                          children: [
                            const TextSpan(text: 'EGP '),
                            TextSpan(text: egpPrice),
                            const TextSpan(
                              text: ' /night',
                              style: TextStyle(
                                fontSize: 12,
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
                  // Friend note pill
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.cream,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: friendAvatarColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            friendNote,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.dark,
                              fontFamily: 'DM Sans',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label, {bool isSpecial = false, bool isPositive = true}) {
    Color bgColor = AppColors.cream;
    Color textColor = AppColors.navy;
    Color borderColor = AppColors.navy;

    if (isSpecial) {
      if (isPositive) {
        bgColor = const Color(0xFFE8F5E9);
        textColor = const Color(0xFF2E7D32);
        borderColor = const Color(0xFF2E7D32);
      } else {
        bgColor = const Color(0xFFEFEBE9);
        textColor = const Color(0xFFC62828);
        borderColor = const Color(0xFFC62828);
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor.withOpacity(0.5)),
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
