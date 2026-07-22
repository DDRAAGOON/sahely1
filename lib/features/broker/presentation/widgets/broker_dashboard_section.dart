import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/features/broker/presentation/widgets/broker_stats_row.dart';

class BrokerDashboardSection extends StatelessWidget {
  final String thisMonthEarnings;
  final int liveProps;
  final int needHelp;
  final VoidCallback onReferOwnerTap;

  const BrokerDashboardSection({
    super.key,
    required this.thisMonthEarnings,
    required this.liveProps,
    required this.needHelp,
    required this.onReferOwnerTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your dashboard',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.navy,
              fontFamily: 'DM Sans',
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: onReferOwnerTap,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.gold.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.home_outlined,
                      color: AppColors.gold,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Refer an owner, earn 50 ★',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.navy,
                            fontFamily: 'DM Sans',
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'When their property gets listed & approved',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.secondary,
                            fontFamily: 'DM Sans',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    color: AppColors.secondary,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          BrokerStatsRow(
            thisMonth: thisMonthEarnings,
            totalEarned: '312k', // Default mock value
            liveProps: liveProps,
          ),
        ],
      ),
    );
  }
}
