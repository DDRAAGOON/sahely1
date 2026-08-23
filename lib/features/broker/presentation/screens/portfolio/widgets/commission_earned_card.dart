import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';

class CommissionEarnedCard extends StatelessWidget {
  final String totalEarned;
  final int liveCount;
  final int pendingCount;
  final int issueCount;
  final int cancelledCount;

  const CommissionEarnedCard({
    super.key,
    required this.totalEarned,
    required this.liveCount,
    required this.pendingCount,
    required this.issueCount,
    required this.cancelledCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'Commission earned · this season',
            style: AppTheme.dm(
              size: 13,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 8),
          // Total Earned
          Text(
            'EGP $totalEarned',
            style: AppTheme.dm(
              size: 28,
              weight: FontWeight.w700,
              color: AppColors.gold,
            ),
          ),
          const SizedBox(height: 20),
          // Stats Row
          Row(
            children: [
              _StatColumn(
                value: '$liveCount',
                label: 'Live',
                dividerColor: Colors.white.withValues(alpha: 0.2),
              ),
              _StatColumn(
                value: '$pendingCount',
                label: 'Pending',
                dividerColor: Colors.white.withValues(alpha: 0.2),
              ),
              _StatColumn(
                value: '$issueCount',
                label: 'Issue',
                valueColor: AppColors.red,
                dividerColor: Colors.white.withValues(alpha: 0.2),
              ),
              _StatColumn(
                value: '$cancelledCount',
                label: 'Cancelled',
                dividerColor: Colors.transparent,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String value;
  final String label;
  final Color? valueColor;
  final Color dividerColor;

  const _StatColumn({
    required this.value,
    required this.label,
    this.valueColor,
    required this.dividerColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Column(
            children: [
              Text(
                value,
                style: AppTheme.dm(
                  size: 20,
                  weight: FontWeight.w700,
                  color: valueColor ?? AppColors.gold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: AppTheme.dm(
                  size: 11,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          if (dividerColor != Colors.transparent)
            Container(
              width: 1,
              height: 32,
              color: dividerColor,
            ),
        ],
      ),
    );
  }
}
