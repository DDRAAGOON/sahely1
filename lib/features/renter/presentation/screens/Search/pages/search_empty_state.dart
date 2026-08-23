import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/bouncy_button.dart';

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

            Text(
              'No properties match your search',
              textAlign: TextAlign.center,
              style: AppTheme.dm(
                size: 20,
                weight: FontWeight.w700,
                color: AppColors.navy,
              ),
            ),

            const SizedBox(height: 12),

            // Subtitle
            Text(
              'Try adjusting your filters or search terms.',
              textAlign: TextAlign.center,
              style: AppTheme.dm(
                size: 14,
                color: AppColors.secondary,
              ),
            ),

            const SizedBox(height: 32),

            BouncyButton(
              onTap: onClearFilters,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.navy,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Clear Filters',
                  style: AppTheme.dm(
                    size: 14,
                    weight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
