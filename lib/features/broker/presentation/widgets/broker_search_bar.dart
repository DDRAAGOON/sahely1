import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/bouncy_button.dart';

class BrokerSearchBar extends StatelessWidget {
  final VoidCallback onSearchTap;
  final VoidCallback onFilterTap;
  final VoidCallback onChatTap;

  const BrokerSearchBar({
    super.key,
    required this.onSearchTap,
    required this.onFilterTap,
    required this.onChatTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: BouncyButton(
              onTap: onSearchTap,
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.search,
                      size: 18,
                      color: AppColors.gold,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Find your perfect stay',
                      style: AppTheme.dm(
                        size: 13,
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          BouncyButton(
            onTap: onFilterTap,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.navy,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.tune,
                color: AppColors.gold,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 8),
          BouncyButton(
            onTap: onChatTap,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.gold,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(
                    Icons.chat_bubble_outline,
                    color: AppColors.navy,
                    size: 20,
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
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
      ),
    );
  }
}
