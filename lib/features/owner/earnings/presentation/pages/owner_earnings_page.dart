import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/cards/sahely_card.dart';

class OwnerEarningsPage extends StatelessWidget {
  const OwnerEarningsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: Text('Earnings & Payouts', style: AppTheme.dm(size: 20, weight: FontWeight.w700)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
        children: [
          _buildBalanceCard(),
          const SizedBox(height: 24),
          Text('Monthly Breakdown', style: AppTheme.dm(size: 18, weight: FontWeight.w700)),
          const SizedBox(height: 16),
          _buildEarningItem('July 2026', 'EGP 42,500', 'Pending'),
          _buildEarningItem('June 2026', 'EGP 68,000', 'Paid'),
          _buildEarningItem('May 2026', 'EGP 34,200', 'Paid'),
        ],
      ),
    );
  }

  Widget _buildBalanceCard() {
    return SahelyCard(
      color: AppColors.navy,
      child: Column(
        children: [
          Text('Total Net Earnings', style: AppTheme.dm(size: 14, color: Colors.white70)),
          const SizedBox(height: 8),
          Text('EGP 144,700', style: AppTheme.dm(size: 32, weight: FontWeight.w800, color: AppColors.gold)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMiniStat('Upcoming', 'EGP 12k'),
              Container(width: 1, height: 30, color: Colors.white10),
              _buildMiniStat('Withdrawable', 'EGP 8.5k'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(String label, String value) {
    return Column(
      children: [
        Text(value, style: AppTheme.dm(size: 16, weight: FontWeight.w700, color: Colors.white)),
        Text(label, style: AppTheme.dm(size: 11, color: Colors.white54)),
      ],
    );
  }

  Widget _buildEarningItem(String month, String amount, String status) {
    final isPaid = status == 'Paid';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(month, style: AppTheme.dm(size: 14, weight: FontWeight.w600)),
              Text(status, style: AppTheme.dm(size: 12, color: isPaid ? AppColors.success : AppColors.warning)),
            ],
          ),
          Text(amount, style: AppTheme.dm(size: 15, weight: FontWeight.w700, color: AppColors.navy)),
        ],
      ),
    );
  }
}
