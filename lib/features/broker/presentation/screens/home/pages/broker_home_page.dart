import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahely/core/di/service_locator.dart';
import 'package:sahely/core/navigation/app_navigation.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/l10n/app_localizations.dart';
import 'package:sahely/features/broker/presentation/bloc/broker_home_cubit.dart';
import 'package:sahely/features/broker/presentation/bloc/broker_home_state.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/widgets/smooth_transition.dart';
import 'package:sahely/core/widgets/entrance_faded.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';
import 'package:sahely/features/broker/presentation/widgets/broker_dashboard_section.dart';
import 'package:sahely/features/broker/presentation/widgets/broker_filter_chips.dart';
import 'package:sahely/features/broker/presentation/widgets/broker_header.dart';
import 'package:sahely/features/broker/presentation/widgets/broker_level_progress_card.dart';
import 'package:sahely/features/broker/presentation/widgets/broker_promo_banner.dart';
import 'package:sahely/features/broker/presentation/widgets/broker_property_card.dart';
import 'package:sahely/features/broker/presentation/widgets/broker_search_bar.dart';
import 'package:sahely/features/broker/presentation/widgets/refer_property_banner.dart';

import '../../../../../../core/widgets/bouncy_button.dart';

class BrokerHomePage extends StatefulWidget {
  const BrokerHomePage({super.key});

  @override
  State<BrokerHomePage> createState() => _BrokerHomePageState();
}

class _BrokerHomePageState extends State<BrokerHomePage> {
  String? _selectedFilter;
  final List<String> _filters = ['All', 'Villa', 'Chalet', 'Penthouse'];

  @override
  void initState() {
    super.initState();
    // Set initial filter with a tiny delay to trigger the transition animation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _selectedFilter = 'All';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<BrokerHomeCubit>()..loadDashboard(),
      child: Container(
        color: AppColors.cream,
        child: SafeArea(
          bottom: false,
          child: BlocBuilder<BrokerHomeCubit, BrokerHomeState>(
            builder: (context, state) {
              if (state is BrokerHomeLoading || state is BrokerHomeInitial) {
                return const Center(
                    child: CircularProgressIndicator(color: AppColors.gold));
              }

              if (state is BrokerHomeError) {
                return Center(child: Text(state.message));
              }

              if (state is BrokerHomeLoaded) {
                final dashboard = state.dashboard;
                return EntranceFaded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      context.read<BrokerHomeCubit>().loadDashboard();
                    },
                    color: AppColors.gold,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BrokerHeader(
                            name: dashboard.name,
                            role: dashboard.role,
                          ),
                          const SizedBox(height: 16),
                          BrokerSearchBar(
                            onSearchTap: () => AppNavigation.goToBrowse(context),
                            onFilterTap: () => AppNavigation.goToFilters(context),
                            onChatTap: () => AppNavigation.goToAiChat(context),
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: BrokerLevelProgressCard(
                              currentLevelName: dashboard.level,
                              levelIcon: dashboard.levelIcon,
                              currentStars: dashboard.currentStars,
                              starsToNextLevel: dashboard.starsToNextLevel,
                              nextLevelName: dashboard.nextLevelName,
                              onTap: () => AppNavigation.goToMawsem(context),
                            ),
                          ),
                          const SizedBox(height: 24),
                          // 2. Your Dashboard (Moved here)
                          BrokerDashboardSection(
                            thisMonthEarnings: dashboard.thisMonthEarnings,
                            liveProps: dashboard.liveProps,
                            needHelp: dashboard.needHelp,
                            onReferOwnerTap: () =>
                                AppNavigation.goToBrokerRefer(context),
                          ),
                          const SizedBox(height: 16),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: BrokerPromoBanner(),
                          ),
                          const SizedBox(height: 20),
                          BrokerFilterChips(
                            filters: _filters,
                            selectedFilter: _selectedFilter ?? 'All',
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
                                Text(
                                  AppLocalizations.of(context).trendingNow,
                                  style: AppTheme.dm(
                                    size: 18,
                                    weight: FontWeight.w700,
                                    color: AppColors.navy,
                                  ),
                                ),
                                BouncyButton(
                                  onTap: () =>
                                      AppNavigation.goToAllProperties(context),
                                  child: Text(
                                    AppLocalizations.of(context).seeAll,
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
                          const SizedBox(height: 12),
                          SmoothListTransition(
                            transitionKey: _selectedFilter,
                            child: Column(
                              children: List<Map<String, dynamic>>.from(
                                      dashboard.trendingProperties)
                                  .where((p) =>
                                      _selectedFilter == 'All' ||
                                      p['type'] == _selectedFilter)
                                  .map((property) {
                                final data = property;
                                final p = Property(
                                  name: data['name'] ?? '',
                                  area: data['location'] ?? '',
                                  image: data['imageUrl'] ?? '',
                                  price: (data['pricePerNight'] ?? 0) ~/ 100,
                                  rating: (data['rating'] ?? 0.0).toDouble(),
                                  reviews: (data['reviews'] ?? 0).toInt(),
                                  type: data['type'] ?? 'Villa',
                                );
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 16, left: 16, right: 16),
                                  child: BrokerPropertyCard(
                                    property: p,
                                    onTap: () {
                                      AppNavigation.goToPropertyDetail(context,
                                          extra: p);
                                    },
                                    onWishlistTap: () {},
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Extra Banners or space
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: ReferPropertyBanner(
                              onTap: () => AppNavigation.goToBrokerRefer(context),
                            ),
                          ),
                          const SizedBox(height: 120),
                        ],
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
