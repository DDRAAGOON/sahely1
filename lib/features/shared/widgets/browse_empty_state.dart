import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';

class BrowseEmptyState extends StatelessWidget {
  const BrowseEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 40, horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon in a light circle
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: AppColors.gold.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.zoom_out,
                          size: 38, color: AppColors.gold),
                    ),
                    const SizedBox(height: 32),
                    // Title
                    Text(
                      'No properties match your search',
                      textAlign: TextAlign.center,
                      style: AppTheme.dm(
                          size: 20,
                          weight: FontWeight.w700,
                          color: AppColors.navy),
                    ),
                    const SizedBox(height: 12),
                    // Subtitle
                    Text(
                      'Try adjusting your filters or search terms.',
                      textAlign: TextAlign.center,
                      style: AppTheme.dm(
                          size: 14,
                          color: AppColors.textSecondary,
                          height: 1.4),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
