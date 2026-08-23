import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';

class PropertyDetailsCard extends StatelessWidget {
  final Map<String, dynamic> details;

  const PropertyDetailsCard({
    super.key,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _DetailItem(
                  icon: Icons.bed,
                  label:
                      '${details['bedrooms'] ?? 0} bdr · ${details['beds'] ?? 0} beds'),
              const SizedBox(width: 16),
              _DetailItem(
                  icon: Icons.bathtub,
                  label: '${details['bathrooms'] ?? 0} bathrooms'),
            ],
          ),
          const SizedBox(height: 12),
          const Row(
            children: [
              _DetailItem(icon: Icons.pool, label: 'Private pool'),
              SizedBox(width: 16),
              _DetailItem(icon: Icons.wifi, label: 'Fast Wi-Fi'),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _DetailItem(
                  icon: Icons.beach_access,
                  label: details['beach'] ?? 'Beach access'),
              const SizedBox(width: 16),
              const _DetailItem(icon: Icons.lock, label: 'Smart lock'),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _DetailItem({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.navy),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: AppTheme.dm(
                size: 13,
                color: AppColors.dark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
