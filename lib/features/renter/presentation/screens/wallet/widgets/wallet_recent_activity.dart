import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/features/renter/presentation/screens/wallet/widgets/wallet_activity_row.dart';

class WalletRecentActivity extends StatelessWidget {
  final List<Map<String, dynamic>> transactions;
  final VoidCallback onViewAll;

  const WalletRecentActivity({
    super.key,
    required this.transactions,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.navy,
                fontFamily: 'DM Sans',
              ),
            ),
            GestureDetector(
              onTap: onViewAll,
              child: const Text(
                'View All',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.gold,
                  fontFamily: 'DM Sans',
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Activity List
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: transactions.asMap().entries.map((entry) {
              final index = entry.key;
              final transaction = entry.value;
              final isLast = index == transactions.length - 1;

              return Column(
                children: [
                  WalletActivityRow(
                    type: transaction['type'],
                    title: transaction['title'],
                    subtitle: transaction['subtitle'],
                    amount: transaction['amount'],
                  ),
                  if (!isLast)
                    const Divider(
                      height: 1,
                      color: AppColors.border,
                      indent: 0, // Changed from 16 to 0
                      endIndent: 0, // Changed from 16 to 0
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
