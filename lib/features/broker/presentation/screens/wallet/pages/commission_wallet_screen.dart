import 'package:flutter/material.dart';
import '../../../../../../core/navigation/app_navigation.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../widgets/wallet_header.dart';
import '../widgets/account_verification_banner.dart';
import '../widgets/available_balance_card.dart';
import '../widgets/commission_info_card.dart';
import '../widgets/withdraw_button.dart';
import '../widgets/wallet_period_tabs.dart';
import '../widgets/wallet_stats_row.dart';
import '../widgets/tier_info_card.dart';
import '../widgets/recent_commissions_section.dart';

class CommissionWalletScreen extends StatefulWidget {
  const CommissionWalletScreen({super.key});

  @override
  State<CommissionWalletScreen> createState() => _CommissionWalletScreenState();
}

class _CommissionWalletScreenState extends State<CommissionWalletScreen> {
  String _selectedPeriod = 'This Month';
  bool _isAccountVerified = false;

  // Mock Data
  final Map<String, dynamic> _walletData = {
    'availableBalance': '12,840',
    'pendingBalance': '5,400',
    'thisMonth': {
      'earned': '18.2k',
      'pending': '5.4k',
      'bookings': 14,
    },
    'lastMonth': {
      'earned': '15.8k',
      'pending': '0',
      'bookings': 12,
    },
    'tier': 'Gold tier',
    'commissionRate': '4%',
    'avgPerBooking': 'EGP 1,300',
    'progressToElite': 45,
    'recentCommissions': [
      {
        'propertyName': 'Palm Chalet',
        'date': 'Jun 12',
        'amount': '+1,820',
        'status': 'Paid',
      },
      {
        'propertyName': 'Dune House',
        'date': 'Jun 9',
        'amount': '+960',
        'status': 'Pending',
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          children: [
            // Custom Top Bar with Back only
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Icon(Icons.chevron_left, color: AppColors.navy, size: 22),
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Account Verification Banner
                    if (!_isAccountVerified)
                      AccountVerificationBanner(
                        onAddCardTap: () {
                          // Simulating verification for the demo
                          setState(() {
                            _isAccountVerified = true;
                          });
                          AppNavigation.goToAddCard(context);
                        },
                      ),

                    const SizedBox(height: 24),

                    // Page Title
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Commission Wallet',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy,
                          fontFamily: 'DM Sans',
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Available Balance Card
                    AvailableBalanceCard(
                      balance: _walletData['availableBalance'] as String,
                    ),

                    const SizedBox(height: 16),

                    // Commission Info Card
                    CommissionInfoCard(
                      pendingBalance: _walletData['pendingBalance'] as String,
                    ),

                    const SizedBox(height: 24),

                    // Withdraw Button
                    WithdrawButton(
                      isVerified: _isAccountVerified,
                      onTap: () => AppNavigation.goToBrokerWithdraw(context),
                    ),

                    const SizedBox(height: 24),

                    // Period Tabs
                    WalletPeriodTabs(
                      selectedPeriod: _selectedPeriod,
                      onTabSelected: (period) {
                        setState(() {
                          _selectedPeriod = period;
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    // Stats Row
                    WalletStatsRow(
                      earned: _walletData[_selectedPeriod == 'This Month' ? 'thisMonth' : 'lastMonth']['earned'] as String,
                      pending: _walletData[_selectedPeriod == 'This Month' ? 'thisMonth' : 'lastMonth']['pending'] as String,
                      bookings: _walletData[_selectedPeriod == 'This Month' ? 'thisMonth' : 'lastMonth']['bookings'] as int,
                    ),

                    const SizedBox(height: 16),

                    // Tier Info Card
                    TierInfoCard(
                      tier: _walletData['tier'] as String,
                      commissionRate: _walletData['commissionRate'] as String,
                      avgPerBooking: _walletData['avgPerBooking'] as String,
                      progressToElite: _walletData['progressToElite'] as int,
                    ),

                    const SizedBox(height: 24),

                    // Recent Commissions
                    RecentCommissionsSection(
                      commissions: List<Map<String, dynamic>>.from(
                        _walletData['recentCommissions'] as List,
                      ),
                      onViewFullHistory: () => AppNavigation.goToBrokerHistory(context),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}