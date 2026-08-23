import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/features/broker/presentation/widgets/broker_stats_row.dart';

import '../../../../core/navigation/app_navigation.dart';
import '../../../../core/widgets/bouncy_button.dart';

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
          Text(
            'Your dashboard',
            style: AppTheme.dm(
              size: 18,
              weight: FontWeight.w700,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 12),
          BouncyButton(
            onTap: () => AppNavigation.goToShareEarn(context),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.navy.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Refer an owner, earn 50 ★',
                          style: AppTheme.dm(
                            size: 14,
                            weight: FontWeight.w600,
                            color: AppColors.navy,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'When their property gets listed & approved',
                          style: AppTheme.dm(
                            size: 12,
                            color: AppColors.secondary,
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
