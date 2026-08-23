import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/features/broker/presentation/screens/portfolio/widgets/not_live_property_card.dart';

class NotLiveSection extends StatelessWidget {
  final List<Map<String, dynamic>> properties;
  final Function(Map<String, dynamic>) onPropertyTap;

  const NotLiveSection({
    super.key,
    required this.properties,
    required this.onPropertyTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Text(
            'NOT LIVE',
            style: AppTheme.dm(
              size: 11,
              weight: FontWeight.w700,
              color: AppColors.secondary,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          // Property Cards
          ...properties.map((property) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: NotLivePropertyCard(
                property: property,
                onTap: () => onPropertyTap(property),
              ),
            );
          }),
        ],
      ),
    );
  }
}