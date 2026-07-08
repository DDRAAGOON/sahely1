import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../data/models.dart';
import '../widgets/broker_header.dart';
import '../widgets/broker_search_bar.dart';
import '../widgets/broker_level_progress_card.dart';
import '../widgets/broker_promo_banner.dart';
import '../widgets/broker_filter_chips.dart';
import '../widgets/broker_dashboard_section.dart';
import '../widgets/upcoming_checkins_section.dart';
import '../widgets/refer_property_banner.dart';
import '../widgets/broker_property_card.dart';

class BrokerHomePage extends StatefulWidget {
  const BrokerHomePage({super.key});

  @override
  State<BrokerHomePage> createState() => _BrokerHomePageState();
}

class _BrokerHomePageState extends State<BrokerHomePage> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Villa', 'Chalet', 'Penthouse'];

  // Mock Data
  final Map<String, dynamic> _brokerData = {
    'name': 'Karim Adel',
    'role': 'Broker',
    'level': 'Wave Rider',
    'levelIcon': Icons.waves,
    'currentStars': 47,
    'starsToNextLevel': 33,
    'nextLevelName': 'Coastal Regular',
    'thisMonthEarnings': '18.2k',
    'liveProps': 51,
    'needHelp': 2,
    'upcomingCheckins': [
      {
        'id': '1',
        'name': 'Palm Chalet',
        'client': 'Nour A.',
        'date': 'Jun 19',
        'profit': '+EGP 320 profit',
        'imageUrl': 'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=200',
        'status': 'Soon',
      },
      {
        'id': '2',
        'name': 'Dune House',
        'client': 'Sara M.',
        'date': 'Jun 22',
        'profit': '+EGP 260 profit',
        'imageUrl': 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=200',
        'status': 'Soon',
      },
    ],
    'trendingProperties': [
      {
        'id': '1',
        'name': 'Azure Beach Villa',
        'location': 'North Coast',
        'rating': 4.8,
        'reviews': 124,
        'beds': 3,
        'type': 'Villa',
        'pricePerNight': 450000,
        'imageUrl': 'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=800',
        'isWishlisted': true,
      },
      {
        'id': '2',
        'name': 'Lagoon Retreat',
        'location': 'Marassi',
        'rating': 4.9,
        'reviews': 86,
        'beds': 4,
        'type': 'Chalet',
        'pricePerNight': 620000,
        'imageUrl': 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=800',
        'isWishlisted': false,
      },
      {
        'id': '3',
        'name': 'Skyline Penthouse',
        'location': 'Hacienda Red',
        'rating': 4.7,
        'reviews': 42,
        'beds': 2,
        'type': 'Penthouse',
        'pricePerNight': 380000,
        'imageUrl': 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=800',
        'isWishlisted': false,
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
        },
        color: AppColors.gold,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BrokerHeader(
                name: _brokerData['name'],
                role: _brokerData['role'],
              ),
              const SizedBox(height: 16),
              BrokerSearchBar(
                onSearchTap: () => Navigator.pushNamed(context, '/browse'),
                onFilterTap: () => Navigator.pushNamed(context, '/filters'),
                onChatTap: () => Navigator.pushNamed(context, '/ai-chat'),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: BrokerLevelProgressCard(
                  currentLevelName: _brokerData['level'],
                  levelIcon: _brokerData['levelIcon'],
                  currentStars: _brokerData['currentStars'],
                  starsToNextLevel: _brokerData['starsToNextLevel'],
                  nextLevelName: _brokerData['nextLevelName'],
                  onTap: () => Navigator.pushNamed(context, '/mawsem'),
                ),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: BrokerPromoBanner(),
              ),
              const SizedBox(height: 20),
              BrokerFilterChips(
                filters: _filters,
                selectedFilter: _selectedFilter,
                onFilterSelected: (filter) {
                  setState(() {
                    _selectedFilter = filter;
                  });
                },
              ),
              const SizedBox(height: 24),
              // 1. Trending Now
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Trending Now',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                        fontFamily: 'DM Sans',
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/all-properties'),
                      child: const Text(
                        'See All',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.gold,
                          fontFamily: 'DM Sans',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: Column(
                  key: ValueKey(_selectedFilter),
                  children: List<Map<String, dynamic>>.from(_brokerData['trendingProperties'])
                      .where((p) => _selectedFilter == 'All' || p['type'] == _selectedFilter)
                      .map((property) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
                      child: BrokerPropertyCard(
                        property: property,
                        onTap: () {
                          final p = Property(
                            name: property['name'],
                            area: property['location'],
                            image: property['imageUrl'],
                            price: (property['pricePerNight'] / 100).toInt(),
                            rating: property['rating'],
                            reviews: property['reviews'],
                            type: property['type'],
                          );
                          Navigator.pushNamed(context, '/property', arguments: p);
                        },
                        onWishlistTap: () {},
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24),
              // 2. Your Dashboard
              BrokerDashboardSection(
                thisMonthEarnings: _brokerData['thisMonthEarnings'],
                liveProps: _brokerData['liveProps'],
                needHelp: _brokerData['needHelp'],
                onReferOwnerTap: () => Navigator.pushNamed(context, '/broker/refer'),
              ),
              const SizedBox(height: 24),
              // 3. Upcoming Check-ins
              UpcomingCheckinsSection(
                checkins: List<Map<String, dynamic>>.from(_brokerData['upcomingCheckins']),
                onCheckinTap: (checkin) {},
              ),
              const SizedBox(height: 24),
              // Extra Banners or space
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ReferPropertyBanner(
                  onTap: () => Navigator.pushNamed(context, '/broker/refer'),
                ),
              ),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }
}
