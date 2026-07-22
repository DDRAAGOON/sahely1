import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/features/broker/presentation/widgets/top_referred_property_card.dart';

class TopReferredPropertiesSection extends StatelessWidget {
  final List<Map<String, dynamic>> properties;
  final int totalCount;
  final VoidCallback onSeeAllTap;
  final Function(Map<String, dynamic>) onPropertyTap;

  const TopReferredPropertiesSection({
    super.key,
    required this.properties,
    required this.totalCount,
    required this.onSeeAllTap,
    required this.onPropertyTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Top Referred Properties',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                  fontFamily: 'DM Sans',
                ),
              ),
              GestureDetector(
                onTap: onSeeAllTap,
                child: Text(
                  'All $totalCount',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.gold,
                    fontFamily: 'DM Sans',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Property Cards
          ...properties.map((property) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TopReferredPropertyCard(
                property: property,
                onTap: () => onPropertyTap(property),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}