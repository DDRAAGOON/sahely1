import 'package:flutter/material.dart';
import '../../../../../../core/navigation/app_navigation.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../widgets/portfolio_header.dart';
import '../widgets/commission_earned_card.dart';
import '../widgets/referral_code_card.dart';
import '../widgets/portfolio_filter_chips.dart';
import '../widgets/portfolio_property_list.dart';
import '../widgets/not_live_section.dart';

class BrokerPortfolioScreen extends StatefulWidget {
  const BrokerPortfolioScreen({super.key});

  @override
  State<BrokerPortfolioScreen> createState() => _BrokerPortfolioScreenState();
}

class _BrokerPortfolioScreenState extends State<BrokerPortfolioScreen> {
  String _selectedFilter = 'All';
  int _totalCount = 55;
  int _liveCount = 51;
  int _pendingCount = 2;
  int _issueCount = 1;
  int _cancelledCount = 1;

  // Mock Data
  final List<Map<String, dynamic>> _topEarners = [
    {
      'name': 'Azure Beach Villa',
      'owner': 'Layla M.',
      'status': 'Live',
      'bookings': 24,
      'commission': '41,200',
      'imageUrl': 'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=400',
    },
    {
      'name': 'Lagoon Retreat',
      'owner': 'Sara A.',
      'status': 'Live',
      'bookings': 18,
      'commission': '33,600',
      'imageUrl': 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=400',
    },
    {
      'name': 'Golden Dunes',
      'owner': 'Tarek S.',
      'status': 'Pending',
      'bookings': 0,
      'commission': null,
      'imageUrl': 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=400',
    },
  ];

  final List<Map<String, dynamic>> _notLiveProperties = [
    {
      'name': 'Golden Dunes',
      'owner': 'Owner: Tarek S.',
      'status': 'Pending',
      'statusDetail': 'under review',
      'imageUrl': 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=200',
    },
    {
      'name': 'Marina Loft',
      'owner': 'Owner: —',
      'status': 'Issue',
      'statusDetail': 'needs better photos',
      'imageUrl': 'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=200',
    },
    {
      'name': 'Palm Chalet',
      'owner': 'Owner: —',
      'status': 'Cancelled',
      'statusDetail': 'owner withdrew listing',
      'imageUrl': 'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=200',
    },
  ];

  void _copyReferralCode() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Referral code copied'),
        backgroundColor: AppColors.green,
      ),
    );
  }

  void _referProperty() {
    AppNavigation.goToBrokerRefer(context);
  }

  void _handlePropertyTap(Map<String, dynamic> property) {
    if (property['status'] == 'Issue') {
      AppNavigation.goToBrokerReferralIssue(context);
    } else if (property['status'] == 'Live') {
      AppNavigation.goToBrokerReferredDetail(context);
    } else {
      // For Pending or Cancelled, maybe show details too
      AppNavigation.goToBrokerReferredDetail(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            PortfolioHeader(
              totalCount: _totalCount,
              liveCount: _liveCount,
              onReferTap: _referProperty,
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Commission Earned Card
                    GestureDetector(
                      onTap: () => AppNavigation.goToBrokerWallet(context),
                      child: CommissionEarnedCard(
                        totalEarned: '312,400',
                        liveCount: _liveCount,
                        pendingCount: _pendingCount,
                        issueCount: _issueCount,
                        cancelledCount: _cancelledCount,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Referral Code Card
                    ReferralCodeCard(
                      code: 'KARIM-4821',
                      onCopy: _copyReferralCode,
                    ),

                    const SizedBox(height: 16),

                    // Filter Chips
                    PortfolioFilterChips(
                      totalCount: _totalCount,
                      liveCount: _liveCount,
                      pendingCount: _pendingCount,
                      issueCount: _issueCount,
                      cancelledCount: _cancelledCount,
                      selectedFilter: _selectedFilter,
                      onFilterSelected: (filter) {
                        setState(() {
                          _selectedFilter = filter;
                        });
                        if (filter.contains('Live')) {
                          AppNavigation.goToBrokerReferredProperties(context);
                        } else if (filter.contains('Issue')) {
                          AppNavigation.goToBrokerReferralIssue(context);
                        }
                      },
                    ),

                    const SizedBox(height: 24),

                    // Top Earners Section
                    PortfolioPropertyList(
                      title: 'TOP EARNERS',
                      properties: _topEarners,
                      onPropertyTap: _handlePropertyTap,
                    ),

                    const SizedBox(height: 24),

                    // Not Live Section
                    NotLiveSection(
                      properties: _notLiveProperties,
                      onPropertyTap: _handlePropertyTap,
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