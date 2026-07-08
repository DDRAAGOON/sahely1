import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';

class BookingPropertyCard extends StatelessWidget {
  final String propertyName;
  final String propertyImage;
  final int pricePerNight; // in piastres

  const BookingPropertyCard({
    super.key,
    required this.propertyName,
    required this.propertyImage,
    required this.pricePerNight,
  });

  @override
  Widget build(BuildContext context) {
    final egpPrice = (pricePerNight / 100).toStringAsFixed(0);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // Property Thumbnail
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.navy.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                propertyImage,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.home,
                    color: AppColors.navy,
                    size: 32,
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Property Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  propertyName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                    fontFamily: 'DM Sans',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'EGP $egpPrice / night',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.secondary,
                    fontFamily: 'DM Sans',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
