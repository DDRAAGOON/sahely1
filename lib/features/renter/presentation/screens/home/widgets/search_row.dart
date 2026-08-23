import 'package:flutter/material.dart';

import 'package:sahely/core/navigation/app_navigation.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/bouncy_button.dart';

class SearchRow extends StatelessWidget {
  final VoidCallback? onFilterTap;
  final VoidCallback? onChatTap;

  const SearchRow({super.key, this.onFilterTap, this.onChatTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Search bar
        Expanded(
          child: BouncyButton(
            onTap: () => AppNavigation.goToSearchResults(context),
            child: Container(
              height: 54,
              padding: const EdgeInsets.symmetric(horizontal: 12),
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
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Find your perfect stay',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTheme.dm(
                        size: 13,
                        color: AppColors.navy.withValues(alpha: 0.5),
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
        BouncyButton(
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

        // AI Chat Button
        BouncyButton(
          onTap: onChatTap,
          child: Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: AppColors.gold,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(
                  Icons.chat_bubble_outline,
                  color: AppColors.navy,
                  size: 20,
                ),
                // Green presence dot
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF34C759),
                      shape: BoxShape.circle,
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
