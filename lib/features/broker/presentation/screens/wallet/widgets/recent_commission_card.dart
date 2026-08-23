import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';

class RecentCommissionCard extends StatelessWidget {
  final Map<String, dynamic> commission;

  const RecentCommissionCard({
    super.key,
    required this.commission,
  });

  @override
  Widget build(BuildContext context) {
    final status = commission['status']?.toString() ?? '';
    final isPaid = status == 'Paid';

    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.white,
      child: Row(
        children: [
          // Property Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  commission['propertyName']?.toString() ?? '',
                  style: AppTheme.dm(
                    size: 15,
                    weight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  commission['date']?.toString() ?? '',
                  style: AppTheme.dm(
                    size: 12,
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
          ),
          // Amount & Status
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${commission['amount']}',
                style: AppTheme.dm(
                  size: 15,
                  weight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isPaid ? const Color(0xFF1D5E57) : const Color(0xFFD2760A),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  status,
                  style: AppTheme.dm(
                    size: 10,
                    weight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}