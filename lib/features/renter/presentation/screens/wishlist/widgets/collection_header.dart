import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';

class CollectionHeader extends StatelessWidget {
  final String collectionName;
  final int propertyCount;
  final int sharedWithCount;
  final VoidCallback onBackTap;

  const CollectionHeader({
    super.key,
    required this.collectionName,
    required this.propertyCount,
    required this.sharedWithCount,
    required this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      decoration: const BoxDecoration(
        color: AppColors.cream,
      ),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: onBackTap,
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(
                Icons.chevron_left,
                color: AppColors.navy,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  collectionName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                    fontFamily: 'DM Sans',
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$propertyCount places · shared with $sharedWithCount',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.secondary,
                    fontFamily: 'DM Sans',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
