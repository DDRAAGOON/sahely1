import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_theme.dart';

class AmenitiesSection extends StatelessWidget {
  final List<String> amenities;

  const AmenitiesSection({super.key, required this.amenities});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Amenities',
          style: TextStyle(
            fontSize: 16, 
            fontWeight: FontWeight.w700, 
            color: AppColors.navy, 
            fontFamily: 'Cairo'
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: amenities.map((amenity) => _AmenityItem(label: amenity)).toList(),
        ),
      ],
    );
  }
}

class _AmenityItem extends StatelessWidget {
  final String label;
  const _AmenityItem({required this.label});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    switch (label.toLowerCase()) {
      case 'pool': icon = Icons.pool; break;
      case 'wifi': icon = Icons.wifi; break;
      case 'beachfront': icon = Icons.beach_access; break;
      case 'pets': icon = Icons.pets; break;
      case 'parking': icon = Icons.local_parking; break;
      case 'kitchen': icon = Icons.kitchen; break;
      case 'ac': icon = Icons.ac_unit; break;
      default: icon = Icons.check_circle_outline;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: AppColors.navy),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: AppColors.navy, fontFamily: 'Cairo'),
        ),
      ],
    );
  }
}
