import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';

class ReviewsTabs extends StatelessWidget {
  final int selectedTab;
  final ValueChanged<int> onTabSelected;

  const ReviewsTabs({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Reviews I Gave Tab
          Expanded(
            child: GestureDetector(
              onTap: () => onTabSelected(0),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: selectedTab == 0 ? AppColors.navy : AppColors.white,
                  borderRadius: BorderRadius.circular(30),
                  border : null,
                ),
                child: Center(
                  child: Text(
                    'Reviews I gave',
                    style: AppTheme.dm(
                      size: 13,
                      weight: FontWeight.w700,
                      color:
                          selectedTab == 0 ? AppColors.white : AppColors.navy,
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // About Me Tab
          Expanded(
            child: GestureDetector(
              onTap: () => onTabSelected(1),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: selectedTab == 1 ? AppColors.navy : AppColors.white,
                  borderRadius: BorderRadius.circular(30),
                  border : null,
                ),
                child: Center(
                  child: Text(
                    'About me',
                    style: AppTheme.dm(
                      size: 13,
                      weight: FontWeight.w700,
                      color:
                          selectedTab == 1 ? AppColors.white : AppColors.navy,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
