import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';

class PropertyInfoCard extends StatelessWidget {
  final String propertyName;
  final String propertyType;
  final String location;
  final String referralCode;
  final String imageUrl;

  const PropertyInfoCard({
    super.key,
    required this.propertyName,
    required this.propertyType,
    required this.location,
    required this.referralCode,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // Property Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              imageUrl,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 64,
                  height: 64,
                  color: AppColors.border,
                  child: const Icon(
                    Icons.image,
                    color: AppColors.secondary,
                    size: 24,
                  ),
                );
              },
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
                  '$propertyType · $location · via $referralCode',
                  style: AppTheme.dm(
                    size: 12,
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