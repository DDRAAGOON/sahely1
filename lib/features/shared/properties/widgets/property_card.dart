import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../data/models.dart';

class PropertyCard extends StatelessWidget {
  final Property property;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;

  const PropertyCard({
    super.key,
    required this.property,
    this.onTap,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.navy.withOpacity(0.06),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Stack
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(
                      property.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Bottom Fade
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
                  // Favorite Button
                  Positioned(
                    top: 12,
                    right: 12,
                    child: GestureDetector(
                      onTap: onFavoriteTap,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: Icon(
                          property.saved ? Icons.favorite : Icons.favorite_border,
                          color: property.saved ? AppColors.gold : AppColors.navy,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  // Property Info Overlay
                  Positioned(
                    bottom: 12,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          property.name,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.navy, fontFamily: 'Cairo'),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: AppColors.navy, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              property.area,
                              style: const TextStyle(fontSize: 12, color: AppColors.navy, fontWeight: FontWeight.w600, fontFamily: 'Cairo'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Details Row
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star, color: AppColors.gold, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        property.rating.toString(),
                        style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.navy, fontFamily: 'Cairo'),
                      ),
                      Text(
                        ' (${property.reviews})',
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontFamily: 'Cairo'),
                      ),
                    ],
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'EGP ${property.price.toInt()}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.navy, fontFamily: 'Cairo'),
                        ),
                        const TextSpan(
                          text: ' / night',
                          style: TextStyle(fontSize: 11, color: AppColors.textSecondary, fontFamily: 'Cairo'),
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
}
