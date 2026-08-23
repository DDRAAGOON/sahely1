import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/property_card.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';

enum PropertyBadge { trending, discount, newlyAdded }

class PropertySection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final List<Map<String, dynamic>> properties;
  final PropertyBadge badgeType;
  final Function(Map<String, dynamic>) onPropertyTap;

  const PropertySection({
    super.key,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.properties,
    required this.badgeType,
    required this.onPropertyTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(icon, size: 16, color: iconColor),
              const SizedBox(width: 6),
              Text(
                title,
                style: AppTheme.dm(
                  size: 11,
                  weight: FontWeight.w700,
                  color: AppColors.secondary,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Property Cards
        ...properties.map((property) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
            child: PropertyCard(
              property: Property.fromMap(property),
              onTap: () => onPropertyTap(property),
            ),
          );
        }),
      ],
    );
  }
}
