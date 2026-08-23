import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';

class BrokerHeader extends StatelessWidget {
  final String name;
  final String role;

  const BrokerHeader({
    super.key,
    required this.name,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good morning,',
                style: AppTheme.dm(
                  size: 13,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                name,
                style: AppTheme.dm(
                  size: 22,
                  weight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.gold, width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.star,
                  size: 14,
                  color: AppColors.gold,
                ),
                const SizedBox(width: 4),
                Text(
                  role,
                  style: AppTheme.dm(
                    size: 13,
                    weight: FontWeight.w600,
                    color: AppColors.gold,
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
