import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/navigation/app_navigation.dart';

class SearchRow extends StatelessWidget {
  final VoidCallback? onFilterTap;
  final VoidCallback? onChatTap;
  const SearchRow({super.key, this.onFilterTap, this.onChatTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // ... (keep search bar)
        Expanded(
          child: GestureDetector(
            onTap: () => AppNavigation.goToSearchResults(context),
            child: Container(
              height: 54,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(27),
                border: Border.all(color: AppColors.border, width: 1),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.search,
                    color: AppColors.gold,
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Find your perfect stay',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.navy.withValues(alpha: 0.5),
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),

        // Filter Button
        GestureDetector(
          onTap: onFilterTap,
          child: Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: AppColors.navy,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Center(
              child: Icon(
                Icons.tune,
                color: AppColors.gold,
                size: 22,
              ),
            ),
          ),
        ),

        const SizedBox(width: 10),

        // AI Chat Button - Kept as is
        GestureDetector(
          onTap: onChatTap,
          child: Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: AppColors.gold,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Stack(
              children: [
                const Center(
                  child: Icon(
                    Icons.chat_bubble_outline,
                    color: AppColors.navy,
                    size: 20,
                  ),
                ),
                // Green presence dot
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.gold, width: 2),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
