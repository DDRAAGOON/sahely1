import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';

class BrokerStatsRow extends StatelessWidget {
  final String thisMonthEarnings;
  final int liveProps;
  final int needHelp;

  const BrokerStatsRow({
    super.key,
    required this.thisMonthEarnings,
    required this.liveProps,
    required this.needHelp,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            value: thisMonthEarnings,
            label: 'This month',
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatCard(
            value: '$liveProps',
            label: 'Live props',
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatCard(
            value: '$needHelp',
            label: 'Need help',
            valueColor: AppColors.gold,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color? valueColor;

  const _StatCard({
    required this.value,
    required this.label,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: valueColor ?? AppColors.navy,
              fontFamily: 'DM Sans',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.secondary,
              fontFamily: 'DM Sans',
            ),
          ),
        ],
      ),
    );
  }
}
