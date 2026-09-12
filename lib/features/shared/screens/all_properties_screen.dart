import 'package:flutter/material.dart';
import 'package:sahely/core/utils/responsive.dart';
import 'package:sahely/core/navigation/app_navigation.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/features/shared/widgets/browse_empty_state.dart';
import 'package:sahely/features/shared/widgets/hero_property_card.dart';
import 'package:sahely/core/widgets/entrance_faded.dart';
import 'package:sahely/core/widgets/smooth_transition.dart';
import 'package:sahely/core/widgets/kit.dart';
import 'package:sahely/core/di/service_locator.dart' show sl;
import 'package:sahely/features/renter/domain/repositories/renter_repository.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';

typedef _Feeds = ({
  List<Property> trending,
  List<Property> offers,
  List<Property> all,
});

class AllPropertiesScreen extends StatefulWidget {
  const AllPropertiesScreen({super.key});

  @override
  State<AllPropertiesScreen> createState() => _AllPropertiesScreenState();
}

class _AllPropertiesScreenState extends State<AllPropertiesScreen> {
  String _selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();
  final String _query = '';
  late Future<_Feeds> _feeds = _loadFeeds();

  Future<_Feeds> _loadFeeds() async {
    final repo = sl<RenterRepository>();
    final trending = await repo.getTrending();
    final offers = await repo.getOffers();
    final all = await repo.getAllProperties();
    return (trending: trending, offers: offers, all: all);
  }

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
                child: FutureBuilder<_Feeds>(
                  future: _feeds,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(
                          child:
                              CircularProgressIndicator(color: AppColors.gold));
                    }
                    final feeds = snapshot.data;
                    if (feeds == null) {
                      return Center(
                        child: TextButton(
                          onPressed: () =>
                              setState(() => _feeds = _loadFeeds()),
                          child: Text(
                              'Could not load properties. Tap to retry.',
                              style: AppTheme.dm(
                                  size: 14, color: AppColors.muted)),
                        ),
                      );
                    }
                    return SmoothListTransition(
                      transitionKey: '$_selectedFilter$_query',
                      child: isSearching
                          ? _buildFilteredResults(feeds)
                          : _buildDiscoverySections(feeds),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilteredResults(_Feeds feeds) {
    final source = switch (_selectedFilter) {
      'Trending Now' => feeds.trending,
      'Best Offers' => feeds.offers,
      _ => feeds.all,
    };
    final q = _query.toLowerCase();
    final results = q.isEmpty
        ? source
        : source
            .where((p) =>
                p.name.toLowerCase().contains(q) ||
                p.area.toLowerCase().contains(q))
            .toList();

    if (results.isEmpty) {
      return const BrowseEmptyState();
    }

    (String, Color) badgeFor(Property p) {
      if (_selectedFilter == 'Trending Now') {
        return ('Trending', AppColors.error);
      }
      if (_selectedFilter == 'Best Offers') return ('Offer', AppColors.success);
      if (_selectedFilter == 'Newly Added') return ('New', AppColors.gold);
      if (p.rating >= 4.8) return ('Top Rated', AppColors.error);
      return ('Featured', AppColors.gold);
    }

    // Responsive: single-column cards on phones; 2-3 column grid on tablets.
    return LayoutBuilder(builder: (context, constraints) {
      final cols = Responsive.gridColumns(constraints.maxWidth);
      if (cols == 1) {
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
          itemCount: results.length,
          itemBuilder: (context, index) {
            final p = results[index];
            final (badge, color) = badgeFor(p);
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: HeroPropertyCard(
                  property: p, badge: badge, badgeColor: color),
            );
          },
        );
      }

      return GridView.builder(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: cols,
          mainAxisSpacing: 16,
          crossAxisSpacing: 14,
          childAspectRatio: 0.62,
        ),
        itemCount: results.length,
        itemBuilder: (context, index) {
          final p = results[index];
          final (badge, color) = badgeFor(p);
          return HeroPropertyCard(property: p, badge: badge, badgeColor: color);
        },
      );
    });
  }

  Widget _buildDiscoverySections(_Feeds feeds) {
    final offer = feeds.offers.isEmpty ? null : feeds.offers.first;
    if (feeds.trending.isEmpty && offer == null && feeds.all.isEmpty) {
      return const BrowseEmptyState();
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
      children: [
        if (feeds.trending.isNotEmpty) ...[
          _sectionHeader('🔥 TRENDING NOW'),
          ...feeds.trending.take(2).map((p) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: HeroPropertyCard(
                  property: p,
                  badge: 'Trending',
                  badgeColor: AppColors.error,
                ),
              )),
          const SizedBox(height: 8),
        ],
        if (offer != null) ...[
          _sectionHeader('💰 BEST OFFERS'),
          HeroPropertyCard(
            property: offer,
            badge: 'Offer',
            badgeColor: AppColors.success,
          ),
          const SizedBox(height: 24),
        ],
        if (feeds.all.isNotEmpty) ...[
          _sectionHeader('✨ NEWLY ADDED'),
          for (final p in feeds.all.take(2)) ...[
            HeroPropertyCard(
              property: p,
              badge: 'New',
              badgeColor: AppColors.gold,
            ),
            const SizedBox(height: 16),
          ],
        ],
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
