import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahely/core/di/service_locator.dart';
import 'package:sahely/core/navigation/app_navigation.dart';
import 'package:sahely/features/owner/domain/entities/owner_dashboard.dart';
import 'package:sahely/features/owner/presentation/bloc/owner_home_cubit.dart';
import 'package:sahely/features/owner/presentation/bloc/owner_home_state.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/l10n/app_localizations.dart';
import 'package:sahely/core/widgets/common.dart';
import 'package:sahely/core/widgets/kit.dart';
import 'package:sahely/core/widgets/property_card.dart';
import 'package:sahely/core/widgets/smooth_transition.dart';
import 'package:sahely/core/widgets/entrance_faded.dart';
import 'package:sahely/data/models.dart';
import 'package:sahely/features/renter/presentation/screens/home/widgets/promo_banner.dart';
import 'package:sahely/features/shared/widgets/mawsem/mawsem_card.dart';
import 'package:sahely/features/owner/widgets/pending_request_card.dart';

import '../../../core/widgets/bouncy_button.dart';

class OwnerHomeScreen extends StatefulWidget {
  const OwnerHomeScreen({super.key});

  @override
  State<OwnerHomeScreen> createState() => _OwnerHomeScreenState();
}

class _OwnerHomeScreenState extends State<OwnerHomeScreen> {
  String? _selectedCategory;
  List<Property> _filteredProperties = [];
  OwnerDashboard? _dashboard;

  @override
  void initState() {
    super.initState();
    // Pre-populate if state is already loaded
    final state = context.read<OwnerHomeCubit>().state;
    if (state is OwnerHomeLoaded) {
      _dashboard = state.dashboard;
    }

    // Set initial category with a tiny delay to trigger the transition animation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _selectedCategory = 'All';
          _filteredProperties = _getFilteredFromDashboard();
        });
      }
    });
  }

  List<Property> _getFilteredFromDashboard() {
    if (_dashboard == null) return [];
    if (_selectedCategory == null || _selectedCategory == 'All') {
      return _dashboard!.trendingProperties.take(3).toList();
    }
    return _dashboard!.trendingProperties
        .where((p) {
          if (_selectedCategory == 'Beachfront') {
            return p.tags.contains('Beachfront') || p.tags.contains('Beach');
          }
          return p.tags.contains(_selectedCategory!);
        })
        .take(3)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<OwnerHomeCubit>()..loadDashboard(),
      child: BlocConsumer<OwnerHomeCubit, OwnerHomeState>(
        listener: (context, state) {
          if (state is OwnerHomeLoaded) {
            setState(() {
              _dashboard = state.dashboard;
              _filteredProperties = _getFilteredFromDashboard();
            });
          }
        },
        builder: (context, state) {
          if (state is OwnerHomeLoading || state is OwnerHomeInitial) {
            return const Center(
                child: CircularProgressIndicator(color: Color(0xFFC9A84C)));
          }
          if (state is OwnerHomeError) {
            return Center(child: Text(state.message));
          }

          final dashboard = _dashboard;
          return SafeArea(
            child: EntranceFaded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
                children: [
                  // 1. Header
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(AppLocalizations.of(context).ownerWelcomeBack,
                                  style: AppTheme.dm(
                                      size: 13, color: AppColors.muted)),
                              Text(dashboard?.ownerName ?? 'Layla Mansour',
                                  style: AppTheme.dm(
                                      size: 24,
                                      weight: FontWeight.w700,
                                      color: AppColors.navy)),
                            ]),
                        const RoleBadge(role: Role.owner),
                      ]),
                  const SizedBox(height: 16),

                  // 2. Search & Tools
                  Row(children: [
                    Expanded(
                      child: BouncyButton(
                        onTap: () => AppNavigation.goToBrowse(context),
                        child: Container(
                          height: 46,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(23),
                            border : null,
                          ),
                          child: Row(children: [
                            const Icon(Icons.search,
                                color: AppColors.gold, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                AppLocalizations.of(context).findYourPerfectStay,
                                style: AppTheme.dm(
                                    size: 11,
                                    color: AppColors.navy.withValues(alpha: 0.5)),
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    BouncyButton(
                      onTap: () {
                        AppNavigation.goToFilters(
                          context,
                          allProperties: _dashboard?.trendingProperties ?? [],
                          onApplyFilters: (result) {
                            AppNavigation.goToSearchResults(context, extra: result);
                          },
                        );
                      },
                      child: Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                            color: AppColors.navy,
                            borderRadius: BorderRadius.circular(12)),
                        child: const Icon(Icons.tune,
                            color: AppColors.gold, size: 20),
                      ),
                    ),
                    const SizedBox(width: 10),
                    BouncyButton(
                      onTap: () => AppNavigation.goToOwnerAiChat(context),
                      child: Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                            color: AppColors.gold,
                            borderRadius: BorderRadius.circular(12)),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const Icon(Icons.chat_bubble_outline,
                                color: AppColors.navy, size: 20),
                            Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                        color: Color(0xFF34C759),
                                        shape: BoxShape.circle,
                                        border : null))),
                          ],
                        ),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 18),

                  // 3. MAWSEM Card
                  const MawsemCard(),
                  const SizedBox(height: 16),

                  // 4. Promo Banner
                  const PromoBanner(),
                  const SizedBox(height: 20),

                  // 8. Categories & Trending
                  SizedBox(
                    height: 38,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.zero,
                      children: [
                        ChoiceChipPill(AppLocalizations.of(context).catAll,
                            selected: _selectedCategory == 'All', onTap: () {
                          setState(() {
                            _selectedCategory = 'All';
                            _filteredProperties = _getFilteredFromDashboard();
                          });
                        }),
                        const SizedBox(width: 8),
                        ChoiceChipPill(AppLocalizations.of(context).catVilla,
                            selected: _selectedCategory == 'Villa', onTap: () {
                          setState(() {
                            _selectedCategory =
                                (_selectedCategory == 'Villa') ? 'All' : 'Villa';
                            _filteredProperties = _getFilteredFromDashboard();
                          });
                        }),
                        const SizedBox(width: 8),
                        ChoiceChipPill(AppLocalizations.of(context).catChalet,
                            selected: _selectedCategory == 'Chalet', onTap: () {
                          setState(() {
                            _selectedCategory =
                                (_selectedCategory == 'Chalet') ? 'All' : 'Chalet';
                            _filteredProperties = _getFilteredFromDashboard();
                          });
                        }),
                        const SizedBox(width: 8),
                        ChoiceChipPill(AppLocalizations.of(context).catPenthouse,
                            selected: _selectedCategory == 'Penthouse',
                            onTap: () {
                          setState(() {
                            _selectedCategory = (_selectedCategory == 'Penthouse')
                                ? 'All'
                                : 'Penthouse';
                            _filteredProperties = _getFilteredFromDashboard();
                          });
                        }),
                        const SizedBox(width: 8),
                        ChoiceChipPill('Beachfront',
                            selected: _selectedCategory == 'Beachfront',
                            onTap: () {
                          setState(() {
                            _selectedCategory = (_selectedCategory == 'Beachfront')
                                ? 'All'
                                : 'Beachfront';
                            _filteredProperties = _getFilteredFromDashboard();
                          });
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Trending Now',
                            style: AppTheme.dm(
                                size: 18,
                                weight: FontWeight.w700,
                                color: AppColors.navy)),
                        BouncyButton(
                          onTap: () =>
                              AppNavigation.goToOwnerAllTrending(context),
                          child: Text('See All',
                              style: AppTheme.dm(
                                  size: 14,
                                  weight: FontWeight.w600,
                                  color: AppColors.gold)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SmoothListTransition(
                    transitionKey: _selectedCategory,
                    child: Column(
                      children: _filteredProperties.isEmpty
                            ? [
                                Center(
                                    child: Padding(
                                        padding: const EdgeInsets.all(32),
                                        child: Text('No properties in this category',
                                            style: AppTheme.dm(
                                                color: AppColors.muted))))
                              ]
                            : _filteredProperties
                                .map((p) => Padding(
                                      padding: const EdgeInsets.only(bottom: 16),
                                      child: PropertyCard(
                                          property: p,
                                          onTap: () =>
                                              AppNavigation.goToPropertyDetail(
                                                  context,
                                                  extra: p)),
                                    ))
                                .toList(),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 5. Dashboard Stats
                  Text('Your dashboard',
                      style: AppTheme.dm(
                          size: 18,
                          weight: FontWeight.w700,
                          color: AppColors.navy)),
                  const SizedBox(height: 12),
                  StatRow(cards: [
                    StatCard(
                        value: '${dashboard?.propertiesCount ?? 3}',
                        label: 'Properties',
                        onTap: () => AppNavigation.goToOwnerProperties(context)),
                    StatCard(
                        value: '${dashboard?.bookingsCount ?? 7}',
                        label: 'Active bookings',
                        onTap: () => AppNavigation.goToOwnerBookings(context)),
                    StatCard(
                        value: dashboard?.monthlyEarnings ?? '68.4k',
                        label: 'EGP / month',
                        onTap: () => AppNavigation.goToOwnerEarnings(context)),
                  ]),
                  const SizedBox(height: 16),

                  // 6. Action: List new property
                  BouncyButton(
                    onTap: () => AppNavigation.goToOwnerAddProperty(context),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.gold,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: AppColors.goldButtonShadow,
                      ),
                      child: Row(children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12)),
                          child: const Icon(Icons.add_home_work,
                              color: AppColors.navy, size: 22),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              Text('List a new property',
                                  style: AppTheme.dm(
                                      size: 15,
                                      weight: FontWeight.w700,
                                      color: AppColors.navy)),
                              Text('Reach thousands of verified renters',
                                  style: AppTheme.dm(
                                      size: 13,
                                      color:
                                          AppColors.navy.withValues(alpha: 0.6))),
                            ])),
                        Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                              color: AppColors.navy, shape: BoxShape.circle),
                          child: const Icon(Icons.add,
                              color: AppColors.gold, size: 20),
                        ),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 7. Pending Requests
                  SectionHeader(
                    title: 'Pending Requests',
                    action: 'View all · 2',
                    onAction: () => AppNavigation.goToOwnerRequests(context),
                  ),
                  const SizedBox(height: 12),
                  PendingRequestCard(
                    onTap: () => AppNavigation.goToOwnerRequestDetail(context, extra: {
                      'guestName': 'Omar Khalil',
                      'rating': '4.9',
                      'verified': true,
                      'propertyName': 'Azure Villa',
                      'stays': '12 stays',
                      'dates': 'Jun 21–25',
                      'total': '18,000',
                      'guests': '4 guests · 2A 2C',
                      'status': 'Pending',
                    }),
                  ),
                  const SizedBox(height: 24),

                  // 9. Portfolio Insights
                  BouncyButton(
                    onTap: () => AppNavigation.goToOwnerPortfolio(context),
                    child: WhiteCard(
                      padding: const EdgeInsets.all(16),
                      child: Row(children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.muted.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.bar_chart,
                              color: AppColors.navy, size: 22),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              Text('Portfolio Insights',
                                  style: AppTheme.dm(
                                      size: 16,
                                      weight: FontWeight.w700,
                                      color: AppColors.navy)),
                              Text('Compare all properties',
                                  style: AppTheme.dm(
                                      size: 13, color: AppColors.muted)),
                            ])),
                        const Icon(Icons.chevron_right,
                            color: AppColors.faint, size: 18),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 10. Refer & Earn (Unified)
                  BouncyButton(
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
                            child: const Icon(Icons.handshake_outlined,
                                color: AppColors.navy, size: 24),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Invite Hosts, earn 100 ★',
                                    style: AppTheme.dm(
                                        color: Colors.white,
                                        size: 15,
                                        weight: FontWeight.w700)),
                                Text('When they list their first property',
                                    style: AppTheme.dm(
                                        color: Colors.white70, size: 12)),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right,
                              color: AppColors.gold, size: 20),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildFooter(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
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
          'You\'ve reached the end · North Coast, Egypt',
          style: AppTheme.dm(
              size: 12, color: AppColors.muted.withValues(alpha: 0.6)),
        ),
      ],
    );
  }
}
