import 'package:flutter/material.dart';
import '../../../../../../core/navigation/app_navigation.dart';
import '../../../../../../core/theme/app_colors.dart';

class BrokerStatsRow extends StatelessWidget {
  final String thisMonth;
  final String totalEarned;
  final int liveProps;

  const BrokerStatsRow({
    super.key,
    required this.thisMonth,
    required this.totalEarned,
    required this.liveProps,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _StatCard(
              label: 'This Month',
              value: thisMonth,
              onTap: () => AppNavigation.goToBrokerWallet(context),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _StatCard(
              label: 'Total Earned',
              value: totalEarned,
              onTap: () => AppNavigation.goToBrokerWallet(context),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _StatCard(
              label: 'Live Props',
              value: '$liveProps',
              onTap: () => AppNavigation.goToBrokerPortfolio(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback? onTap;

  const _StatCard({
    required this.label,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.secondary,
                fontFamily: 'DM Sans',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.navy,
                fontFamily: 'DM Sans',
              ),
            ),
          ],
        ),
      ),
    );
  }
}