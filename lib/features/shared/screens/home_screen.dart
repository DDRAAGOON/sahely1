import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahely/core/providers/profile_provider.dart';
import 'package:sahely/core/navigation/app_navigation.dart';
import 'package:sahely/features/renter/presentation/bloc/renter_home_cubit.dart';
import 'package:sahely/features/renter/presentation/bloc/renter_home_state.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/widgets/pull_to_refresh.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';
import 'package:sahely/features/shared/widgets/mawsem/mawsem_card.dart';
import 'package:sahely/features/renter/presentation/screens/home/widgets/category_chips.dart';
import 'package:sahely/core/di/service_locator.dart' show sl;
import 'package:sahely/features/renter/domain/repositories/renter_repository.dart';
import 'package:sahely/features/shared/properties/domain/entities/property_query.dart';
import 'package:sahely/features/renter/presentation/screens/home/widgets/greeting_header.dart';
import 'package:sahely/features/renter/presentation/screens/home/widgets/promo_banner.dart';
import 'package:sahely/features/renter/presentation/screens/home/widgets/search_row.dart';
import 'package:sahely/core/widgets/property_card.dart';
import 'package:sahely/core/widgets/smooth_transition.dart';
import 'package:sahely/core/widgets/entrance_faded.dart';

import '../../../core/widgets/bouncy_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _selectedCategory;

  final Map<String, dynamic> _appliedFilters = {
    'propertyType': 'All',
    'bedrooms': 'Any',
    'minPrice': 0.0,
    'maxPrice': 100000.0,
    'amenities': <String>[],
    'partyAllowed': false,
    'petsAllowed': false,
    'mixedGroupsOK': false,
    'adults': 0,
    'children': 0,
  };

  List<Property> _allProperties = [];
  List<Property> _filteredProperties = [];

  /// Guards against a slower category search overwriting a newer one.
  int _categoryRequest = 0;

  @override
  void initState() {
    super.initState();
    // Live identity for the greeting header.
    final profile = context.read<ProfileProvider>();
    Future.microtask(() => profile.fetchProfileData());
    final cubit = context.read<RenterHomeCubit>();
    final cubitState = cubit.state;
    if (cubitState is RenterHomeLoaded) {
      _allProperties = cubitState.properties;
    } else if (cubitState is! RenterHomeLoading) {
      cubit.loadProperties();
    }

    // Set initial category with a tiny delay to trigger the transition animation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _selectedCategory = 'All';
          _applyFilters();
        });
      }
    });
  }

  void _onCategoryChanged(String category) {
    setState(() => _selectedCategory = category);
    _applyFilters();
  }

  /// "All" shows the feed the home cubit loaded; every other chip is a real
  /// search, because a listing's type, distance to the beach and amenities
  /// are only known to the server.
  Future<void> _applyFilters() async {
    final category = _selectedCategory ?? 'All';
    if (category == 'All') {
      setState(() => _filteredProperties = _allProperties);
      return;
    }
    final request = ++_categoryRequest;
    try {
      final result = await sl<RenterRepository>()
          .searchProperties(PropertyQuery.category(category));
      if (!mounted || request != _categoryRequest) return;
      setState(() => _filteredProperties = result.properties);
    } catch (_) {
      if (!mounted || request != _categoryRequest) return;
      setState(() => _filteredProperties = const []);
    }
  }

  /// Pull to refresh: the feed, the account and the current category.
  Future<void> _refresh() async {
    await Future.wait([
      context.read<RenterHomeCubit>().loadProperties(),
      context.read<ProfileProvider>().fetchProfileData(force: true),
    ]);
    await _applyFilters();
  }

  void _showFiltersSheet() {
    AppNavigation.goToFilters(
      context,
      initialFilters: _appliedFilters,
      allProperties: _allProperties,
      onApplyFilters: (newFilters) {
        AppNavigation.goToSearchResults(context, filters: newFilters);
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
            child: EntranceFaded(
              child: Column(
                children: [
                  Expanded(
                    child: PullToRefresh(
                      onRefresh: _refresh,
                      child: CustomScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
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

                          const SliverToBoxAdapter(child: SizedBox(height: 24)),

                          // Category Chips
                          SliverToBoxAdapter(
                            child: CategoryChips(
                              onCategorySelected: _onCategoryChanged,
                            ),
                          ),

                          const SliverToBoxAdapter(child: SizedBox(height: 24)),

                          // Section Header - Trending Now
                          SliverToBoxAdapter(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Trending Now',
                                    style: AppTheme.dm(
                                        size: 18,
                                        weight: FontWeight.w700,
                                        color: AppColors.navy),
                                  ),
                                  BouncyButton(
                                    onTap: () =>
                                        AppNavigation.goToAllProperties(
                                            context),
                                    child: Text(
                                      'See All',
                                      style: AppTheme.dm(
                                        size: 14,
                                        weight: FontWeight.w600,
                                        color: AppColors.gold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SliverToBoxAdapter(child: SizedBox(height: 12)),

                          // Property Cards
                          SliverPadding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            sliver: SliverToBoxAdapter(
                              child: SmoothListTransition(
                                transitionKey: _selectedCategory,
                                child: Column(
                                  children: _filteredProperties.isEmpty
                                      ? [
                                          const SizedBox(
                                            height: 100,
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                  color: AppColors.gold),
                                            ),
                                          )
                                        ]
                                      : _filteredProperties
                                          .take(4)
                                          .map((property) => Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 16),
                                                child: PropertyCard(
                                                  property: property,
                                                  onTap: () => AppNavigation
                                                      .goToPropertyDetail(
                                                          context,
                                                          extra: property),
                                                ),
                                              ))
                                          .toList(),
                                ),
                              ),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: _buildReferralBanner(),
                            ),
                          ),

                          const SliverToBoxAdapter(child: SizedBox(height: 48)),

                          // Footer
                          SliverToBoxAdapter(
                            child: _buildFooter(),
                          ),

                          const SliverToBoxAdapter(
                              child: SizedBox(height: 140)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('Explore North Coast',
              style: AppTheme.dm(
                  size: 18, weight: FontWeight.w700, color: AppColors.navy)),
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
              return RepaintBoundary(
                child: GestureDetector(
                  onTap: () => AppNavigation.goToAllProperties(context,
                      filters: {'location': locations[index]['name']}),
                  child: Container(
                    width: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CachedNetworkImage(
                          imageUrl: locations[index]['image']!,
                          fit: BoxFit.cover,
                          memCacheWidth: 320,
                        ),
                        Container(
                          decoration: BoxDecoration(
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
                            style: AppTheme.dm(
                                color: Colors.white,
                                weight: FontWeight.w700,
                                size: 14),
                          ),
                        ),
                      ],
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
    return BouncyButton(
      onTap: () => AppNavigation.goToShareEarn(context),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: AppColors.referralGradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.navy.withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          ],
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Invite friends, earn 15 ★',
                      style: AppTheme.dm(
                          color: Colors.white,
                          size: 15,
                          weight: FontWeight.w700)),
                  Text('When they book & complete a stay',
                      style: AppTheme.dm(color: Colors.white70, size: 12)),
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
        Text(
          'S A H E L Y',
          style: AppTheme.dm(
              size: 22,
              weight: FontWeight.w900,
              color: AppColors.navy,
              letterSpacing: 4),
        ),
        const SizedBox(height: 8),
        Text(
          'Verified Chalets. Zero Chaos.',
          style: AppTheme.dm(
              size: 14, color: AppColors.gold, weight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        Text(
          "You've reached the end · North Coast, Egypt",
          style: AppTheme.dm(
              size: 12, color: AppColors.secondary.withValues(alpha: 0.6)),
        ),
      ],
    );
  }
}
