import 'package:flutter/material.dart';
import 'package:sahely/core/navigation/app_navigation.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/data/sample_data.dart';
import 'package:sahely/features/shared/widgets/browse_empty_state.dart';
import 'package:sahely/features/shared/widgets/hero_property_card.dart';
import 'package:sahely/core/widgets/entrance_faded.dart';
import 'package:sahely/core/widgets/smooth_transition.dart';
import 'package:sahely/core/widgets/kit.dart';

class AllPropertiesScreen extends StatefulWidget {
  const AllPropertiesScreen({super.key});

  @override
  State<AllPropertiesScreen> createState() => _AllPropertiesScreenState();
}

class _AllPropertiesScreenState extends State<AllPropertiesScreen> {
  String _selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();
  final String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine if we are in "Discovery Mode" (showing sections) or "Result Mode" (showing list)
    final bool isSearching = _query.isNotEmpty || _selectedFilter != 'All';

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: EntranceFaded(
          child: Column(
            children: [
              // 1. Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Column(
                  children: [
                    const TopBar(
                      title: 'Market Insights',
                      subtitle: 'Trending, Offers & New Listings',
                    ),
                    const SizedBox(height: 16),
                    SearchHeaderRow(
                      placeholder: 'Search properties...',
                      onSearchTap: () => AppNavigation.goToBrowse(context),
                      onFilter: () => AppNavigation.goToFilters(context),
                      onChatTap: () => AppNavigation.goToAiChat(context),
                      showBack: false,
                    ),
                  ],
                ),
              ),

              // 2. Categories
              SizedBox(
                height: 38,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    for (var f in [
                      'All',
                      'Trending Now',
                      'Best Offers',
                      'Newly Added'
                    ]) ...[
                      ChoiceChipPill(
                        f,
                        selected: _selectedFilter == f,
                        height: 38,
                        onTap: () => setState(() => _selectedFilter = f),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ],
                ),
              ),

              // 3. Properties List
              Expanded(
                child: SmoothListTransition(
                  transitionKey: '$_selectedFilter$_query',
                  child: isSearching
                      ? _buildFilteredResults()
                      : _buildDiscoverySections(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilteredResults() {
    final results = Sample.allTrending.where((p) {
      if (_query.isNotEmpty) {
        final q = _query.toLowerCase();
        if (!p.name.toLowerCase().contains(q) && !p.area.toLowerCase().contains(q)) {
          return false;
        }
      }
      if (_selectedFilter == 'Trending Now') {
        // Trending items are usually high rated and popular
        return p.rating >= 4.6;
      } else if (_selectedFilter == 'Best Offers') {
        // Offers are lower price or have specific value
        return p.price < 5000;
      } else if (_selectedFilter == 'Newly Added') {
        // Mocking 'new' as guest favorites or specific IDs
        return p.guestFavourite || int.parse(p.id) > 10;
      }
      return true;
    }).toList();

    if (results.isEmpty) {
      return const BrowseEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final p = results[index];
        
        String badge = 'Featured';
        Color badgeColor = AppColors.gold;
        
        if (_selectedFilter == 'Trending Now') {
          badge = 'Trending';
          badgeColor = AppColors.error;
        } else if (_selectedFilter == 'Best Offers') {
          badge = '-15%';
          badgeColor = AppColors.success;
        } else if (_selectedFilter == 'Newly Added') {
          badge = 'New';
          badgeColor = AppColors.gold;
        } else if (p.rating >= 4.8) {
          badge = 'Top Rated';
          badgeColor = AppColors.error;
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: HeroPropertyCard(
            property: p,
            badge: badge,
            badgeColor: badgeColor,
          ),
        );
      },
    );
  }

  Widget _buildDiscoverySections() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
      children: [
        _sectionHeader('🔥 TRENDING NOW'),
        ...Sample.allTrending.take(2).map((p) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: HeroPropertyCard(
            property: p,
            badge: 'Trending',
            badgeColor: AppColors.error,
          ),
        )),
        const SizedBox(height: 8),

        _sectionHeader('💰 BEST OFFERS'),
        const HeroPropertyCard(
          property: Sample.dunes,
          badge: '-15%',
          badgeColor: AppColors.success,
        ),
        const SizedBox(height: 24),

        _sectionHeader('✨ NEWLY ADDED'),
        const HeroPropertyCard(
          property: Sample.lagoon,
          badge: 'New',
          badgeColor: AppColors.gold,
          nameOverride: 'Marina Loft',
        ),
        const SizedBox(height: 16),
        const HeroPropertyCard(
          property: Sample.azure,
          badge: 'New',
          badgeColor: AppColors.gold,
          nameOverride: 'Palm Chalet',
        ),
      ],
    );
  }

  Widget _sectionHeader(String title) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style: AppTheme.dm(
                    size: 13,
                    weight: FontWeight.w700,
                    color: AppColors.muted,
                    letterSpacing: 0.5)),
          ],
        ),
      );
}
