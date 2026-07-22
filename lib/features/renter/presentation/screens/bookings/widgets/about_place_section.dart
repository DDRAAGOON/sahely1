import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';

class AboutPlaceSection extends StatelessWidget {
  final String? description;
  final List<dynamic>? amenities;

  const AboutPlaceSection({
    super.key,
    this.description,
    this.amenities,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About this place',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
            fontFamily: 'DM Sans',
          ),
        ),
        const SizedBox(height: 8),
        Text(
          description ?? 'No description available.',
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.dark,
            fontFamily: 'DM Sans',
            height: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        if (amenities != null && amenities!.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: amenities!.map((amenity) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  amenity.toString(),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.dark,
                    fontFamily: 'DM Sans',
                  ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}
