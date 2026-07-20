import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';

class BrokerTierCard extends StatelessWidget {
  final String currentTier;
  final String nextTier;
  final int progressToNext;
  final int properties;
  final String totalEarned;
  final String thisMonth;
  final String pending;

  const BrokerTierCard({
    super.key,
    required this.currentTier,
    required this.nextTier,
    required this.progressToNext,
    required this.properties,
    required this.totalEarned,
    required this.thisMonth,
    required this.pending,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Tier Header
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.gold,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.workspace_premium,
                  color: AppColors.navy,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentTier,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.gold,
                        fontFamily: 'DM Sans',
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$progressToNext to $nextTier',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                        fontFamily: 'DM Sans',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: 0.6, // Mock value
              minHeight: 8,
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
            ),
          ),
          const SizedBox(height: 20),
          // Stats Grid
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatItem(
                value: '$properties',
                label: 'Properties',
              ),
              _StatItem(
                value: totalEarned,
                label: 'Total earned',
              ),
              _StatItem(
                value: thisMonth,
                label: 'This month',
              ),
              _StatItem(
                value: pending,
                label: 'Pending',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.gold,
            fontFamily: 'DM Sans',
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.white70,
            fontFamily: 'DM Sans',
          ),
        ),
      ],
    );
  }
}