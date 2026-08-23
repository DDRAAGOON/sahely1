import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';

class StatusCardsRow extends StatelessWidget {
  final String status;
  final String flaggedDate;
  final String reReviewTime;

  const StatusCardsRow({
    super.key,
    required this.status,
    required this.flaggedDate,
    required this.reReviewTime,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _StatusCard(
              label: 'Status',
              value: status,
              valueColor: AppColors.red,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _StatusCard(
              label: 'Flagged',
              value: flaggedDate,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _StatusCard(
              label: 'Re-review',
              value: reReviewTime,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _StatusCard({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border : null,
      ),
      child: Column(
        children: [
          Text(
            label,
            style: AppTheme.dm(
              size: 11,
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTheme.dm(
              size: 14,
              weight: FontWeight.w700,
              color: valueColor ?? AppColors.navy,
            ),
          ),
        ],
      ),
    );
  }
}