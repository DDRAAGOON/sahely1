import 'package:flutter/material.dart';
import 'package:sahely/core/navigation/app_navigation.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';

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
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _StatCard(
              label: 'This Month',
              value: thisMonth,
              onTap: () => AppNavigation.goToBrokerWallet(context),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _StatCard(
              label: 'Total Earned',
              value: totalEarned,
              onTap: () => AppNavigation.goToBrokerWallet(context),
            ),
          ),
          const SizedBox(width: 10),
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTheme.dm(
                size: 11,
                color: AppColors.secondary,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: AppTheme.dm(
                size: 17,
                weight: FontWeight.w700,
                color: AppColors.navy,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
