import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';

class TierInfoCard extends StatelessWidget {
  final String tier;
  final String commissionRate;
  final String avgPerBooking;
  final int progressToElite;

  const TierInfoCard({
    super.key,
    required this.tier,
    required this.commissionRate,
    required this.avgPerBooking,
    required this.progressToElite,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // Crown Icon Box
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFFEF7EC),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.workspace_premium,
              color: Color(0xFFD2760A),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          // Tier Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$tier · $commissionRate',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                    fontFamily: 'DM Sans',
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'avg $avgPerBooking per booking',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.secondary,
                    fontFamily: 'DM Sans',
                  ),
                ),
              ],
            ),
          ),
          // Progress
          Text(
            '$progressToElite to Elite',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.gold,
              fontFamily: 'DM Sans',
            ),
          ),
        ],
      ),
    );
  }
}