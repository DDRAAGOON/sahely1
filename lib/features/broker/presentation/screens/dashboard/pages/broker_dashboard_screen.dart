import 'package:flutter/material.dart';
import '../../../../../../core/navigation/app_navigation.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../widgets/broker_dashboard_header.dart';
import '../widgets/broker_tier_card.dart';
import '../widgets/broker_quick_actions.dart';
import '../widgets/broker_stats_row.dart';
import '../widgets/referred_properties_card.dart';
import '../widgets/upcoming_checkins_section.dart';
import '../widgets/top_referred_properties_section.dart';

class BrokerDashboardScreen extends StatelessWidget {
  const BrokerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Data
    final brokerData = {
      'name': 'Karim',
      'tier': 'Gold Broker',
      'commissionRate': '4%',
      'currentTier': 'Gold Tier',
      'nextTier': 'Elite',
      'progressToNext': 45,
      'properties': 55,
      'totalEarned': '312k',
      'thisMonth': '18.2k',
      'pending': '5.4k',
      'liveProps': 51,
      'upcomingCheckins': [
        {
          'name': 'Palm Chalet',
          'client': 'Nour A.',
          'date': 'Jun 19',
          'nights': 4,
          'margin': '+960',
          'imageUrl': 'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=200',
        },
        {
          'name': 'Dune House',
          'client': 'Sara M.',
          'date': 'Jun 22',
          'nights': 3,
          'margin': '+720',
          'imageUrl': 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=200',
        },
      ],
      'topProperties': [
        {
          'name': 'Palm Chalet',
          'owner': 'Layla M.',
          'daysRented': 86,
          'avgNight': '4,500',
          'profit': '+15.4k',
          'imageUrl': 'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=200',
        },
        {
          'name': 'Dune House',
          'owner': 'Tarek S.',
          'daysRented': 54,
          'avgNight': '3,800',
          'profit': '+8.2k',
          'imageUrl': 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=200',
        },
      ],
    };

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header
            BrokerDashboardHeader(
              name: brokerData['name'] as String,
              tier: brokerData['tier'] as String,
              commissionRate: brokerData['commissionRate'] as String,
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Tier Card
                    BrokerTierCard(
                      currentTier: brokerData['currentTier'] as String,
                      nextTier: brokerData['nextTier'] as String,
                      progressToNext: brokerData['progressToNext'] as int,
                      properties: brokerData['properties'] as int,
                      totalEarned: brokerData['totalEarned'] as String,
                      thisMonth: brokerData['thisMonth'] as String,
                      pending: brokerData['pending'] as String,
                    ),

                    const SizedBox(height: 16),

                    // Quick Actions
                    const BrokerQuickActions(),

                    const SizedBox(height: 16),

                    // Stats Row
                    BrokerStatsRow(
                      thisMonth: brokerData['thisMonth'] as String,
                      totalEarned: brokerData['totalEarned'] as String,
                      liveProps: brokerData['liveProps'] as int,
                    ),

                    const SizedBox(height: 16),

                    // Referred Properties Card
                    ReferredPropertiesCard(
                      liveCount: brokerData['liveProps'] as int,
                      onTap: () => AppNavigation.goToBrokerReferredProperties(context),
                    ),

                    const SizedBox(height: 24),

                    // Upcoming Check-ins
                    UpcomingCheckinsSection(
                      checkins: List<Map<String, dynamic>>.from(
                        brokerData['upcomingCheckins'] as Iterable,
                      ),
                      onSeeAllTap: () => AppNavigation.goToBrokerBookings(context),
                      onCheckinTap: (checkin) => AppNavigation.goToBrokerBookings(context),
                    ),

                    const SizedBox(height: 24),

                    // Top Referred Properties
                    TopReferredPropertiesSection(
                      properties: List<Map<String, dynamic>>.from(
                        brokerData['topProperties'] as Iterable,
                      ),
                      totalCount: brokerData['properties'] as int,
                      onSeeAllTap: () => AppNavigation.goToBrokerPortfolio(context),
                      onPropertyTap: (property) => AppNavigation.goToBrokerReferredDetail(context),
                    ),

                    const SizedBox(height: 120),
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