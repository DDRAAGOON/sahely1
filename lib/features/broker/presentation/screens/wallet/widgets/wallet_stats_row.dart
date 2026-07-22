import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';

class WalletStatsRow extends StatelessWidget {
  final String earned;
  final String pending;
  final int bookings;

  const WalletStatsRow({
    super.key,
    required this.earned,
    required this.pending,
    required this.bookings,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _StatCard(
              label: 'Earned (mo)',
              value: earned,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _StatCard(
              label: 'Pending',
              value: pending,
              valueColor: const Color(0xFFD2760A),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _StatCard(
              label: 'Bookings',
              value: '$bookings',
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
  final Color? valueColor;

  const _StatCard({
    required this.label,
    required this.value,
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
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: valueColor ?? AppColors.navy,
              fontFamily: 'DM Sans',
            ),
          ),
        ],
      ),
    );
  }
}