import 'package:flutter/material.dart';
import 'package:sahely/core/navigation/app_navigation.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/features/renter/presentation/screens/wallet/widgets/wallet_add_credit_button.dart';
import 'package:sahely/features/renter/presentation/screens/wallet/widgets/wallet_balance_card.dart';
import 'package:sahely/features/renter/presentation/screens/wallet/widgets/wallet_recent_activity.dart';
import 'package:sahely/features/renter/presentation/screens/wallet/widgets/wallet_stats_tiles.dart';
import 'package:sahely/features/renter/presentation/screens/wallet/pages/add_credit_sheet.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  void _showAddCreditSheet(BuildContext context) {
    showModalBottomSheet(
      useRootNavigator: true, context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddCreditSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        elevation: 0,
        leadingWidth: 70,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Center(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Icon(
                  Icons.chevron_left,
                  color: AppColors.navy,
                  size: 22,
                ),
              ),
            ),
          ),
        ),
        title: Text(
          'Wallet',
          style: AppTheme.dm(
            size: 18,
            weight: FontWeight.w700,
            color: AppColors.navy,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Balance Card (EGP 250 = 25000 piastres)
              const WalletBalanceCard(
                balance: 25000,
                subtitle: 'Use credit toward bookings & services',
              ),

              const SizedBox(height: 16),

              // Add Credit Button
              WalletAddCreditButton(
                onAddCredit: () => _showAddCreditSheet(context),
              ),

              const SizedBox(height: 20),

              // Stats Tiles
              const WalletStatsTiles(
                addedThisSeason: 120000, // EGP 1,200
                openViolations: 1,
              ),

              const SizedBox(height: 24),

              // Recent Activity Section
              WalletRecentActivity(
                transactions: const [
                  {
                    'type': 'booking',
                    'title': 'Booking · Azure Villa',
                    'subtitle': 'Jun 14',
                    'amount': -2109000, // EGP -21,090
                  },
                  {
                    'type': 'credit_added',
                    'title': 'Credit added',
                    'subtitle': 'Jun 10 · Visa ••42',
                    'amount': 50000, // EGP +500
                  },
                  {
                    'type': 'violation',
                    'title': 'Late checkout fine',
                    'subtitle': 'Jun 9 · Violation',
                    'amount': -30000, // EGP -300
                  },
                ],
                onViewAll: () => AppNavigation.goToTransactionHistory(context),
              ),

              const SizedBox(height: 24),

              // View Full History Link
              Center(
                child: GestureDetector(
                  onTap: () => AppNavigation.goToTransactionHistory(context),
                  child: Text(
                    'View Full History →',
                    style: AppTheme.dm(
                      size: 14,
                      weight: FontWeight.w600,
                      color: AppColors.gold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
