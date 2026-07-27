import 'package:flutter/material.dart';
import 'package:sahely/core/navigation/app_navigation.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/chips.dart';
import 'package:sahely/data/sample_data.dart';
import 'package:sahely/features/shared/widgets/browse_empty_state.dart';
import 'package:sahely/features/shared/widgets/hero_property_card.dart';

class AllPropertiesScreen extends StatefulWidget {
  const AllPropertiesScreen({super.key});

  @override
  State<AllPropertiesScreen> createState() => _AllPropertiesScreenState();
}

class _AllPropertiesScreenState extends State<AllPropertiesScreen> {
  String _selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

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
        child: Column(
          children: [
            // 1. Custom Header (Slim Version)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.chevron_left,
                          size: 20, color: AppColors.navy),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 42,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(21),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search,
                              size: 18, color: AppColors.gold),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              onChanged: (v) => setState(() => _query = v),
                              decoration: InputDecoration(
                                hintText: 'Search properties',
                                hintStyle: AppTheme.dm(
                                    size: 12,
                                    color: AppColors.navy.withValues(alpha: 0.5)),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                              style: AppTheme.dm(size: 13, color: AppColors.navy),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () async {
                      await AppNavigation.goToFilters(context);
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: AppColors.navy,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child:
                          const Icon(Icons.tune, color: AppColors.gold, size: 18),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => AppNavigation.goToAiChat(context),
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: AppColors.gold,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const Icon(Icons.chat_bubble_outline,
                              color: AppColors.navy, size: 18),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: AppColors.success,
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: AppColors.gold, width: 1.5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 2. Horizontal Categories
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

            // 3. Properties List (Discovery sections or Filtered results)
            Expanded(
              child: isSearching ? _buildFilteredResults() : _buildDiscoverySections(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilteredResults() {
    final results = Sample.allTrending.where((p) {
      // 1. Search Query Filter
      if (_query.isNotEmpty) {
        final q = _query.toLowerCase();
        if (!p.name.toLowerCase().contains(q) && !p.area.toLowerCase().contains(q)) {
          return false;
        }
      }

      // 2. Category Filter (Simplified mapping to existing data)
      if (_selectedFilter == 'Trending Now') {
        if (p.rating < 4.5) return false;
      } else if (_selectedFilter == 'Best Offers') {
        // Mock logic for best offers: prices below a certain point or even index
        if (p.price > 10000) return false;
      } else if (_selectedFilter == 'Newly Added') {
        // Mock logic for new: guest favourites or high index
        if (!p.guestFavourite) return false;
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
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: HeroPropertyCard(
            property: p,
            badge: p.rating >= 4.8 ? 'Top Rated' : 'Featured',
            badgeColor: p.rating >= 4.8 ? AppColors.error : AppColors.gold,
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
        const HeroPropertyCard(
          property: Sample.azure,
          badge: 'Trending',
          badgeColor: AppColors.error,
        ),
        const SizedBox(height: 16),
        const HeroPropertyCard(
          property: Sample.lagoon,
          badge: 'Trending',
          badgeColor: AppColors.error,
        ),
        const SizedBox(height: 24),

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
