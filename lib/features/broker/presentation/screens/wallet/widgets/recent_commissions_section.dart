import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/features/broker/presentation/screens/wallet/widgets/recent_commission_card.dart';

class RecentCommissionsSection extends StatelessWidget {
  final List<Map<String, dynamic>> commissions;
  final VoidCallback onViewFullHistory;

  const RecentCommissionsSection({
    super.key,
    required this.commissions,
    required this.onViewFullHistory,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          const Text(
            'Recent commissions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.navy,
              fontFamily: 'DM Sans',
            ),
          ),
          const SizedBox(height: 12),
          // Commission List in a Card
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: List.generate(commissions.length, (index) {
                final commission = commissions[index];
                final isLast = index == commissions.length - 1;
                return Container(
                  decoration: BoxDecoration(
                    border: isLast ? null : const Border(
                      bottom: BorderSide(color: Color(0xFFF4EFE7)),
                    ),
                  ),
                  child: RecentCommissionCard(commission: commission),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),
          // View Full History at bottom
          Center(
            child: GestureDetector(
              onTap: onViewFullHistory,
              child: const Text(
                'View Full History →',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFD2760A),
                  fontFamily: 'DM Sans',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}