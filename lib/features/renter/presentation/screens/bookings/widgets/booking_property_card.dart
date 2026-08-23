import 'package:flutter/material.dart';
import 'package:sahely/core/utils/currency_formatter.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';

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
    final egpPrice = CurrencyFormatter.formatNumber(pricePerNight ~/ 100);

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
                  style: AppTheme.dm(
                    size: 15,
                    weight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'EGP $egpPrice / night',
                  style: AppTheme.dm(
                    size: 13,
                    color: AppColors.secondary,
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
