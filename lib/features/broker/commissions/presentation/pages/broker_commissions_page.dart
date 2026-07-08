import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/cards/sahely_card.dart';

class BrokerCommissionsPage extends StatelessWidget {
  const BrokerCommissionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: Text('My Commissions', style: AppTheme.dm(size: 20, weight: FontWeight.w700)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
        children: [
          _buildBalanceCard(),
          const SizedBox(height: 24),
          Text('Payout History', style: AppTheme.dm(size: 18, weight: FontWeight.w700)),
          const SizedBox(height: 16),
          _buildHistoryItem('Azure Villa Booking', '+ EGP 450', '21 Jun 2026'),
          _buildHistoryItem('Referral Bonus', '+ EGP 500', '15 Jun 2026'),
        ],
      ),
    );
  }

  Widget _buildBalanceCard() {
    return SahelyCard(
      color: AppColors.white,
      child: Column(
        children: [
          Text('Available for Payout', style: AppTheme.dm(size: 14, color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          Text('EGP 4,250', style: AppTheme.dm(size: 32, weight: FontWeight.w800, color: AppColors.navy)),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () {},
            child: Text('Request Payout →', style: AppTheme.dm(size: 14, weight: FontWeight.w700, color: AppColors.gold)),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(String title, String amount, String date) {
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
              Text(title, style: AppTheme.dm(size: 14, weight: FontWeight.w600)),
              Text(date, style: AppTheme.dm(size: 12, color: AppColors.textSecondary)),
            ],
          ),
          Text(amount, style: AppTheme.dm(size: 15, weight: FontWeight.w700, color: AppColors.success)),
        ],
      ),
    );
  }
}
