import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahely/core/navigation/app_navigation.dart';
import 'package:sahely/features/broker/data/datasources/mock_broker_data_source.dart';
import 'package:sahely/features/broker/data/repositories/broker_repository_impl.dart';
import 'package:sahely/features/broker/presentation/bloc/broker_home_cubit.dart';
import 'package:sahely/features/broker/presentation/bloc/broker_home_state.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';
import 'package:sahely/features/broker/presentation/widgets/broker_dashboard_section.dart';
import 'package:sahely/features/broker/presentation/widgets/broker_filter_chips.dart';
import 'package:sahely/features/broker/presentation/widgets/broker_header.dart';
import 'package:sahely/features/broker/presentation/widgets/broker_level_progress_card.dart';
import 'package:sahely/features/broker/presentation/widgets/broker_promo_banner.dart';
import 'package:sahely/features/broker/presentation/widgets/broker_property_card.dart';
import 'package:sahely/features/broker/presentation/widgets/broker_search_bar.dart';
import 'package:sahely/features/broker/presentation/widgets/refer_property_banner.dart';
import 'package:sahely/features/broker/presentation/widgets/upcoming_checkins_section.dart';

class BrokerHomePage extends StatefulWidget {
  const BrokerHomePage({super.key});

  @override
  State<BrokerHomePage> createState() => _BrokerHomePageState();
}

class _BrokerHomePageState extends State<BrokerHomePage> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Villa', 'Chalet', 'Penthouse'];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BrokerHomeCubit(
        repository: BrokerRepositoryImpl(
          remoteDataSource: MockBrokerDataSource(),
        ),
      )..loadDashboard(),
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
                return RefreshIndicator(
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
                                onTap: () =>
                                    AppNavigation.goToAllProperties(context),
                                behavior: HitTestBehavior.opaque,
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
                        // 2. Your Dashboard
                        BrokerDashboardSection(
                          thisMonthEarnings: dashboard.thisMonthEarnings,
                          liveProps: dashboard.liveProps,
                          needHelp: dashboard.needHelp,
                          onReferOwnerTap: () =>
                              AppNavigation.goToBrokerRefer(context),
                        ),
                        const SizedBox(height: 24),
                        // 3. Upcoming Check-ins
                        UpcomingCheckinsSection(
                          checkins: List<Map<String, dynamic>>.from(
                              dashboard.upcomingCheckins),
                          onSeeAllTap: () =>
                              AppNavigation.goToBrokerBookings(context),
                          onCheckinTap: (checkin) {},
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
