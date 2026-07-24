import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahely/core/navigation/app_navigation.dart';
import 'package:sahely/features/renter/presentation/bloc/renter_home_cubit.dart';
import 'package:sahely/features/renter/presentation/bloc/renter_home_state.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';
import 'package:sahely/features/shared/widgets/mawsem/mawsem_card.dart';
import 'package:sahely/features/renter/presentation/screens/Search/pages/search_filters_sheet.dart';
import 'package:sahely/features/renter/presentation/screens/home/widgets/category_chips.dart';
import 'package:sahely/features/renter/presentation/screens/home/widgets/greeting_header.dart';
import 'package:sahely/features/renter/presentation/screens/home/widgets/promo_banner.dart';
import 'package:sahely/features/renter/presentation/screens/home/widgets/search_row.dart';
import 'package:sahely/core/widgets/property_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'All';

  final Map<String, dynamic> _appliedFilters = {
    'propertyType': 'All',
    'bedrooms': 'Any',
    'minPrice': 0.0,
    'maxPrice': 100000.0,
    'amenities': <String>[],
    'partyAllowed': true,
    'petsAllowed': false,
    'mixedGroupsOK': true,
  };

  List<Map<String, dynamic>> _allProperties = [];
  List<Map<String, dynamic>> _filteredProperties = [];

  @override
  void initState() {
    super.initState();
    final cubitState = context.read<RenterHomeCubit>().state;
    if (cubitState is RenterHomeLoaded) {
      _allProperties = cubitState.properties;
      _applyFilters();
    }
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
      List<String> currentAmenities =
          List<String>.from(filters['amenities'] ?? []);
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
        if (_selectedCategory == 'Pool') {
          return (p['features'] as List).contains('Pool');
        }
        if (_selectedCategory == 'Beachfront') {
          return (p['features'] as List).contains('Beachfront');
        }
        return true;
      }).toList();
    }

    // Filter by Bottom Sheet Filters
    if (_appliedFilters['propertyType'] != 'All') {
      results = results
          .where((p) => p['type'] == _appliedFilters['propertyType'])
          .toList();
    }

    results = results.where((p) {
      double priceEgp = (p['price'] as num).toDouble() / 100;
      return priceEgp >= _appliedFilters['minPrice'] &&
          priceEgp <= _appliedFilters['maxPrice'];
    }).toList();

    setState(() {
      _filteredProperties = results;
    });
  }

  void _showFiltersSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
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
                AppNavigation.goToAllProperties(this.context,
                    filters: newFilters);
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RenterHomeCubit, RenterHomeState>(
      listener: (context, state) {
        if (state is RenterHomeLoaded) {
          setState(() {
            _allProperties = state.properties;
            _applyFilters();
          });
        }
      },
      builder: (context, state) {
        if (state is RenterHomeLoading || state is RenterHomeInitial) {
          return const Center(
              child: CircularProgressIndicator(color: AppColors.gold));
        }
        if (state is RenterHomeError) {
          return Center(child: Text(state.message));
        }

        return Container(
          color: AppColors.cream,
          child: SafeArea(
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
                            onChatTap: () =>
                                AppNavigation.goToAiChat(context),
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
                                onPressed: () =>
                                    AppNavigation.goToAllProperties(context),
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
                            final propertyMap = _filteredProperties[index];
                            final property = Property.fromMap(propertyMap);
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 4),
                              child: PropertyCard(
                                property: property,
                                onTap: () => AppNavigation.goToPropertyDetail(
                                    context,
                                    extra: property),
                              ),
                            );
                          },
                          childCount: _filteredProperties.length > 4
                              ? 4
                              : _filteredProperties.length,
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
          ),
        );
      },
    );
  }

  Widget _buildExploreSection() {
    final locations = [
      {
        'name': 'Marassi',
        'image':
            'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=400'
      },
      {
        'name': 'Hacienda Bay',
        'image':
            'https://images.unsplash.com/photo-1519046904884-53103b34b206?w=400'
      },
      {
        'name': 'Telal',
        'image':
            'https://images.unsplash.com/photo-1506929194765-410711158975?w=400'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('Explore North Coast',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                  fontFamily: 'Cairo')),
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
              return GestureDetector(
                onTap: () => AppNavigation.goToAllProperties(context,
                    filters: {'location': locations[index]['name']}),
                child: Container(
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
                        colors: [
                          Colors.black.withValues(alpha: 0.6),
                          Colors.transparent
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(12),
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      locations[index]['name']!,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14),
                    ),
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
    return GestureDetector(
      onTap: () => AppNavigation.goToShareEarn(context),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: AppColors.referralGradient,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: AppColors.gold,
                  borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.person_add_alt_1,
                  color: AppColors.navy, size: 24),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Invite friends, earn 15 ★',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700)),
                  Text('When they book & complete a stay',
                      style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.gold, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        const Text(
          'S A H E L Y',
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: AppColors.navy,
              letterSpacing: 4),
        ),
        const SizedBox(height: 8),
        const Text(
          'Verified Chalets. Zero Chaos.',
          style: TextStyle(
              fontSize: 14, color: AppColors.gold, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        Text(
          'You\'ve reached the end · North Coast, Egypt',
          style: TextStyle(
              fontSize: 12, color: AppColors.secondary.withValues(alpha: 0.6)),
        ),
      ],
    );
  }
}
