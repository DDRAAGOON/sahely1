import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import 'buttons.dart';

class BrowseEmptyState extends StatelessWidget {
  const BrowseEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.navy.withValues(alpha: 0.04),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.zoom_out, size: 40, color: AppColors.gold),
          ),
          const SizedBox(height: 32),
          Text(
            'No properties match your search',
            textAlign: TextAlign.center,
            style: AppTheme.dm(size: 20, weight: FontWeight.w700, color: AppColors.navy),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Try adjusting your filters or search terms.',
              textAlign: TextAlign.center,
              style: AppTheme.dm(size: 15, color: AppColors.muted, height: 1.4),
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: 180,
            child: NavyButton(
              label: 'Clear Filters',
              radius: 14,
              onTap: () => Navigator.pushReplacementNamed(context, '/filters'),
            ),
          ),
        ],
      ),
    );
  }
}
