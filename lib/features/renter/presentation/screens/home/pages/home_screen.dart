import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../verification/presentation/bloc/verification_cubit.dart';
import 'package:sahely/core/providers/navigation_provider.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/navigation/app_navigation.dart';
import '../widgets1/greeting_header.dart';
import '../widgets1/search_row.dart';
import '../widgets1/mawsem_card.dart';
import '../widgets1/promo_banner.dart';
import '../widgets1/category_chips.dart';
import '../widgets1/property_card.dart';
import '../widgets1/renter_bottom_nav.dart';

import '../../wishlist/pages/wishlist_screen.dart';
import '../../bookings/pages/my_bookings_screen.dart';
import '../../concierge/pages/concierge_screen.dart';
import '../../profile/pages/profile_screen.dart';
import '../../Search/pages/search_filters_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'All';

  Map<String, dynamic> _appliedFilters = {
    'propertyType': 'All',
    'bedrooms': 'Any',
    'minPrice': 0.0,
    'maxPrice': 100000.0,
    'amenities': <String>[],
    'partyAllowed': true,
    'petsAllowed': false,
    'mixedGroupsOK': true,
  };

  final List<Map<String, dynamic>> _allProperties = [
    {
      'id': '1', 'name': 'Lagoon Retreat', 'location': 'Marassi', 'rating': 4.9, 'reviewCount': 86, 
      'price': 620000, 'type': 'Villa', 'beds': 3, 'features': ['Pool', 'Beachfront'], 'imageUrl': 'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=800',
      'partyAllowed': true, 'petsAllowed': true, 'mixedGroupsOK': true,
    },
    {
      'id': '2', 'name': 'Golden Dunes', 'location': 'Hacienda Bay', 'rating': 4.7, 'reviewCount': 53, 
      'price': 380000, 'type': 'Chalet', 'beds': 2, 'features': ['Pool', 'Budget'], 'imageUrl': 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=800',
      'partyAllowed': false, 'petsAllowed': false, 'mixedGroupsOK': true,
    },
    {
      'id': '3', 'name': 'Azure Villa', 'location': 'North Coast', 'rating': 4.8, 'reviewCount': 124, 
      'price': 450000, 'type': 'Villa', 'beds': 4, 'features': ['Beachfront', 'Pool'], 'imageUrl': 'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=800',
      'partyAllowed': true, 'petsAllowed': false, 'mixedGroupsOK': true,
    },
    {
      'id': '4', 'name': 'Sea Breeze Chalet', 'location': 'Amwaj', 'rating': 4.5, 'reviewCount': 42, 
      'price': 250000, 'type': 'Chalet', 'beds': 2, 'features': ['Beachfront', 'Budget'], 'imageUrl': 'https://images.unsplash.com/photo-1499793983690-e29da59ef1c2?w=800',
      'partyAllowed': false, 'petsAllowed': false, 'mixedGroupsOK': false,
    },
    {
      'id': '5', 'name': 'Royal Palace Villa', 'location': 'Diplomats', 'rating': 5.0, 'reviewCount': 15, 
      'price': 950000, 'type': 'Villa', 'beds': 5, 'features': ['Pool', 'Beachfront'], 'imageUrl': 'https://images.unsplash.com/photo-1580587771525-78b9dba3b914?w=800',
      'partyAllowed': true, 'petsAllowed': true, 'mixedGroupsOK': true,
    },
    {
      'id': '6', 'name': 'Golden Sands Chalet', 'location': 'Telal', 'rating': 4.6, 'reviewCount': 65, 
      'price': 320000, 'type': 'Chalet', 'beds': 2, 'features': ['Beachfront', 'Pool'], 'imageUrl': 'https://images.unsplash.com/photo-1515263487990-61b07816b324?w=800',
      'partyAllowed': true, 'petsAllowed': false, 'mixedGroupsOK': true,
    },
    {
      'id': '7', 'name': 'Pine Wood Villa', 'location': 'Hacienda White', 'rating': 4.9, 'reviewCount': 28, 
      'price': 850000, 'type': 'Villa', 'beds': 4, 'features': ['Pool', 'WiFi'], 'imageUrl': 'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?w=800',
      'partyAllowed': true, 'petsAllowed': true, 'mixedGroupsOK': true,
    },
    {
      'id': '8', 'name': 'Sunset Bay Apartment', 'location': 'Marina 7', 'rating': 4.4, 'reviewCount': 92, 
      'price': 210000, 'type': 'Apartment', 'beds': 1, 'features': ['Budget', 'WiFi'], 'imageUrl': 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=800',
      'partyAllowed': false, 'petsAllowed': false, 'mixedGroupsOK': true,
    },
    {
      'id': '9', 'name': 'Palm Breeze Villa', 'location': 'Fouka Bay', 'rating': 4.8, 'reviewCount': 55, 
      'price': 580000, 'type': 'Villa', 'beds': 3, 'features': ['Beachfront', 'Pool'], 'imageUrl': 'https://images.unsplash.com/photo-1493809842364-78817add7ffb?w=800',
      'partyAllowed': true, 'petsAllowed': false, 'mixedGroupsOK': true,
    },
    {
      'id': '10', 'name': 'Coral Reef Chalet', 'location': 'La Vista Cascada', 'rating': 4.7, 'reviewCount': 34, 
      'price': 420000, 'type': 'Chalet', 'beds': 2, 'features': ['Beachfront', 'WiFi'], 'imageUrl': 'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=800',
      'partyAllowed': true, 'petsAllowed': true, 'mixedGroupsOK': true,
    },
    {
      'id': '11', 'name': 'Urban Loft', 'location': 'New Alamein', 'rating': 4.3, 'reviewCount': 110, 
      'price': 150000, 'type': 'Apartment', 'beds': 1, 'features': ['Budget', 'AC'], 'imageUrl': 'https://images.unsplash.com/photo-1536376074432-8d2a32753b94?w=800',
      'partyAllowed': false, 'petsAllowed': false, 'mixedGroupsOK': true,
    },
    {
      'id': '12', 'name': 'White Pearl Villa', 'location': 'Silver Sands', 'rating': 5.0, 'reviewCount': 12, 
      'price': 1200000, 'type': 'Villa', 'beds': 6, 'features': ['Pool', 'Beachfront', 'WiFi'], 'imageUrl': 'https://images.unsplash.com/photo-1512918766775-d263234b4b73?w=800',
      'partyAllowed': true, 'petsAllowed': true, 'mixedGroupsOK': true,
    },
    {
      'id': '13', 'name': 'Morning Dew Chalet', 'location': 'Mountain View', 'rating': 4.6, 'reviewCount': 78, 
      'price': 350000, 'type': 'Chalet', 'beds': 2, 'features': ['Pool', 'Budget'], 'imageUrl': 'https://images.unsplash.com/photo-1510798831971-661eb04b3739?w=800',
      'partyAllowed': true, 'petsAllowed': false, 'mixedGroupsOK': true,
    },
  ];

  List<Map<String, dynamic>> _filteredProperties = [];

  @override
  void initState() {
    super.initState();
    _filteredProperties = _allProperties;
  }

  void _onTabChanged(int index) {
    context.read<NavigationProvider>().setTab(index);
  }

  void _onCategoryChanged(String category) {
    if (category == 'All') {
      setState(() {
        _selectedCategory = category;
        _applyFilters();
      });
      return;
    }

    // Map category to a filter or search query
    Map<String, dynamic> filters = Map.from(_appliedFilters);
    if (category == 'Pool' || category == 'Beachfront') {
      List<String> currentAmenities = List<String>.from(filters['amenities'] ?? []);
      if (!currentAmenities.contains(category)) {
        currentAmenities.add(category);
      }
      filters['amenities'] = currentAmenities;
    }

    AppNavigation.goToAllProperties(context, filters: filters);
  }

  void _applyFilters() {
    List<Map<String, dynamic>> results = _allProperties;

    // Filter by Category Chip
    if (_selectedCategory != 'All') {
      results = results.where((p) {
        if (_selectedCategory == 'Pool') return (p['features'] as List).contains('Pool');
        if (_selectedCategory == 'Beachfront') return (p['features'] as List).contains('Beachfront');
        return true;
      }).toList();
    }

    // Filter by Bottom Sheet Filters
    if (_appliedFilters['propertyType'] != 'All') {
      results = results.where((p) => p['type'] == _appliedFilters['propertyType']).toList();
    }

    results = results.where((p) {
      double priceEgp = (p['price'] as num).toDouble() / 100;
      return priceEgp >= _appliedFilters['minPrice'] && priceEgp <= _appliedFilters['maxPrice'];
    }).toList();

    setState(() {
      _filteredProperties = results;
    });
  }

  void _showFiltersSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return SearchFiltersSheet(
              initialFilters: _appliedFilters,
              allProperties: _allProperties,
              onApplyFilters: (newFilters) {
                // Return to original agreement: Filter from Home goes to AllProperties (See All)
                AppNavigation.goToAllProperties(this.context, filters: newFilters);
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, nav, child) {
        final currentTab = nav.currentTabIndex;
        return Scaffold(
          backgroundColor: AppColors.cream,
          body: _buildBody(currentTab),
          bottomNavigationBar: RenterBottomNav(
            activeIndex: currentTab,
            onTap: _onTabChanged,
          ),
          extendBody: true,
        );
      },
    );
  }

  Widget _buildBody(int currentTab) {
    switch (currentTab) {
      case 0:
        return _buildHomeContent();
      case 1:
        return const WishlistScreen();
      case 2:
        return const MyBookingsScreen();
      case 3:
        return const ConciergeScreen();
      case 4:
        return const ProfileScreen();
      default:
        return _buildHomeContent();
    }
  }

  Widget _buildHomeContent() {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                // Greeting Header
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 14),
                    child: GreetingHeader(),
                  ),
                ),

                // Search Row
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SearchRow(
                      onFilterTap: _showFiltersSheet,
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 14)),

                // MAWSEM Card
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: MawsemCard(),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 14)),

                // Promo Banner
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: PromoBanner(),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 18)),

                // Category Chips
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: CategoryChips(
                      onCategorySelected: _onCategoryChanged,
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 18)),

                // Section Header - Trending Now
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Trending Now: $_selectedCategory',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        TextButton(
                          onPressed: () => AppNavigation.goToAllProperties(context),
                          child: const Text(
                            'See All',
                            style: TextStyle(
                              color: AppColors.gold,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 4)),

                // Property Cards
                SliverList(
                  key: ValueKey(_selectedCategory),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: PropertyCard(property: _filteredProperties[index]),
                      );
                    },
                    childCount: _filteredProperties.length > 4 ? 4 : _filteredProperties.length,
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 12)),

                // Explore North Coast Section
                SliverToBoxAdapter(
                  child: _buildExploreSection(),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 32)),

                // Referral Banner
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _buildReferralBanner(),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 48)),

                // Footer
                SliverToBoxAdapter(
                  child: _buildFooter(),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 120)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExploreSection() {
    final locations = [
      {'name': 'Marassi', 'image': 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=400'},
      {'name': 'Hacienda Bay', 'image': 'https://images.unsplash.com/photo-1519046904884-53103b34b206?w=400'},
      {'name': 'Telal', 'image': 'https://images.unsplash.com/photo-1506929194765-410711158975?w=400'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('Explore North Coast', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.navy, fontFamily: 'Cairo')),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: locations.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return Container(
                width: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: NetworkImage(locations[index]['image']!),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black.withValues(alpha: 0.6), Colors.transparent],
                    ),
                  ),
                  padding: const EdgeInsets.all(12),
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    locations[index]['name']!,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildReferralBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.referralGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.gold, borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.person_add_alt_1, color: AppColors.navy, size: 24),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Invite friends, earn 15 ★', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
                Text('When they book & complete a stay', style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.gold, size: 20),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        const Text(
          'S A H E L Y',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.navy, letterSpacing: 4),
        ),
        const SizedBox(height: 8),
        const Text(
          'Verified Chalets. Zero Chaos.',
          style: TextStyle(fontSize: 14, color: AppColors.gold, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        Text(
          'You\'ve reached the end · North Coast, Egypt',
          style: TextStyle(fontSize: 12, color: AppColors.secondary.withValues(alpha: 0.6)),
        ),
      ],
    );
  }
}
