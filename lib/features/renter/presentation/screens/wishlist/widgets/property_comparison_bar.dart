import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';

class PropertyCompareData {
  final String name;
  final double rating;
  final int price;
  final String imageUrl;

  const PropertyCompareData({
    required this.name,
    required this.rating,
    required this.price,
    required this.imageUrl,
  });
}

class PropertyComparisonBar extends StatelessWidget {
  final PropertyCompareData property1;
  final PropertyCompareData property2;

  const PropertyComparisonBar({
    super.key,
    required this.property1,
    required this.property2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // Property 1
          Expanded(
            child: _buildPropertyCard(property1, isLeft: true),
          ),
          // VS Badge
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: AppColors.navy,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                'VS',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontFamily: 'DM Sans',
                ),
              ),
            ),
          ),
          // Property 2
          Expanded(
            child: _buildPropertyCard(property2, isLeft: false),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyCard(PropertyCompareData property, {required bool isLeft}) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              property.imageUrl,
              height: 60,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 60,
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
          const SizedBox(height: 6),
          // Name
          Text(
            property.name,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.navy,
              fontFamily: 'DM Sans',
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          // Rating & Price
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.star,
                size: 12,
                color: AppColors.gold,
              ),
              const SizedBox(width: 2),
              Text(
                '${property.rating}',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.dark,
                  fontFamily: 'DM Sans',
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${property.price}',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondary,
                  fontFamily: 'DM Sans',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
