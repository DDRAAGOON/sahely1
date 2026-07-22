import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';

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
          // Greeting
          Text(
            'Good morning, $name',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.navy,
              fontFamily: 'DM Sans',
            ),
          ),
          const SizedBox(height: 4),
          // Tier & Rate
          Text(
            '$tier · $commissionRate rate',
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.gold,
              fontWeight: FontWeight.w600,
              fontFamily: 'DM Sans',
            ),
          ),
        ],
      ),
    );
  }
}