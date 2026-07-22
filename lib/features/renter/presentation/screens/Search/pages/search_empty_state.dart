import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';

class SearchEmptyState extends StatelessWidget {
  final String searchQuery;
  final VoidCallback onClearFilters;
  final VoidCallback onBack;

  const SearchEmptyState({
    super.key,
    required this.searchQuery,
    required this.onClearFilters,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Search Icon
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: AppColors.gold.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_outlined,
                size: 40,
                color: AppColors.gold,
              ),
            ),

            const SizedBox(height: 32),

            // Title
            const Text(
              'No properties match your search',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.navy,
                fontFamily: 'Cairo',
              ),
            ),

            const SizedBox(height: 12),

            // Subtitle
            const Text(
              'Try adjusting your filters or search terms.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.secondary,
                fontFamily: 'Cairo',
              ),
            ),

            const SizedBox(height: 32),

            // Clear Filters Button (Smaller Box with Normal Border Radius)
            ElevatedButton(
              onPressed: onClearFilters,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.navy,
                foregroundColor: AppColors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Clear Filters',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
