import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';

class BrokerDashboardHeader extends StatelessWidget {
  final String name;
  final String tier;
  final String commissionRate;

  const BrokerDashboardHeader({
    super.key,
    required this.name,
    required this.tier,
    required this.commissionRate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Good morning, $name',
            style: AppTheme.dm(
              size: 22,
              weight: FontWeight.w700,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 4),
          // Tier & Rate
          Text(
            '$tier · $commissionRate rate',
            style: AppTheme.dm(
              size: 13,
              color: AppColors.gold,
              weight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}