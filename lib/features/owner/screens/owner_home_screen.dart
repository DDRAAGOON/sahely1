import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sahely/features/owner/data/datasources/mock_owner_data_source.dart';
import 'package:sahely/features/owner/data/repositories/owner_repository_impl.dart';
import 'package:sahely/features/owner/domain/entities/owner_dashboard.dart';
import 'package:sahely/features/owner/presentation/bloc/owner_home_cubit.dart';
import 'package:sahely/features/owner/presentation/bloc/owner_home_state.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';
import '../../../data/models.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/chips.dart';
import '../../../core/widgets/common.dart';
import '../../../core/widgets/kit.dart';
import '../../../core/widgets/property_card.dart';
import '../widgets/pending_request_card.dart';
import '../../shared/widgets/mawsem/mawsem_card.dart';
import '../../renter/presentation/screens/home/widgets/promo_banner.dart';

class OwnerHomeScreen extends StatefulWidget {
  const OwnerHomeScreen({super.key});

  @override
  State<OwnerHomeScreen> createState() => _OwnerHomeScreenState();
}

class _OwnerHomeScreenState extends State<OwnerHomeScreen> {
  String? _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Property> _filteredProperties = [];
  OwnerDashboard? _dashboard;

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
      create: (context) => OwnerHomeCubit(
        repository: OwnerRepositoryImpl(
          remoteDataSource: MockOwnerDataSource(),
        ),
      )..loadDashboard(),
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
                            Text('Welcome back,',
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

                // 2. Search & Tools (Synced with Renter logic)
                Row(children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => context.push('/browse'),
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        height: 52,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(26),
                          border: Border.all(color: AppColors.borderDefault),
                        ),
                        child: Row(children: [
                          const Icon(Icons.search,
                              color: AppColors.gold, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Find your perfect stay',
                              style: AppTheme.dm(
                                  size: 12,
                                  color: AppColors.navy.withValues(alpha: 0.5)),
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () async {
                      final result = await context.push('/filters');
                      if (result is Map<String, dynamic> && context.mounted) {
                        context.push('/browse', extra: result);
                      }
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          color: AppColors.navy,
                          borderRadius: BorderRadius.circular(14)),
                      child: const Icon(Icons.tune,
                          color: AppColors.gold, size: 22),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => context.push('/owner/ai-chat'),
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          color: AppColors.gold,
                          borderRadius: BorderRadius.circular(14)),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const Icon(Icons.chat_bubble_outline,
                              color: AppColors.navy, size: 22),
                          Positioned(
                              top: 10,
                              right: 10,
                              child: Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                      color: const Color(0xFF34C759),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: AppColors.cream, width: 2)))),
                        ],
                      ),
                    ),
                  ),
                ]),
                const SizedBox(height: 18),

                // 3. MAWSEM Card (Synced Design)
                const MawsemCard(),
                const SizedBox(height: 16),

                // 4. Promo Banner (Copied from Renter)
                const PromoBanner(),
                const SizedBox(height: 20),

                // 8. Categories & Trending (Moved up)
                Row(children: [
                  ChoiceChipPill('All', selected: _selectedCategory == 'All',
                      onTap: () {
                    setState(() {
                      _selectedCategory = 'All';
                      _filteredProperties = _getFilteredFromDashboard();
                    });
                  }),
                  const SizedBox(width: 10),
                  ChoiceChipPill('Beachfront',
                      selected: _selectedCategory == 'Beachfront', onTap: () {
                    setState(() {
                      _selectedCategory = 'Beachfront';
                      _filteredProperties = _getFilteredFromDashboard();
                    });
                  }),
                  const SizedBox(width: 10),
                  ChoiceChipPill('Pool', selected: _selectedCategory == 'Pool',
                      onTap: () {
                    setState(() {
                      _selectedCategory = 'Pool';
                      _filteredProperties = _getFilteredFromDashboard();
                    });
                  }),
                ]),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Trending Now',
                        style: AppTheme.dm(
                            size: 18,
                            weight: FontWeight.w700,
                            color: AppColors.navy)),
                    GestureDetector(
                      onTap: () => context.push('/owner/all-trending'),
                      behavior: HitTestBehavior.opaque,
                      child: Text('See All',
                          style: AppTheme.dm(
                              size: 13,
                              weight: FontWeight.w600,
                              color: AppColors.gold)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (_filteredProperties.isEmpty)
                  Center(
                      child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Text('No properties in this category',
                              style: AppTheme.dm(color: AppColors.muted))))
                else
                  for (var p in _filteredProperties) ...[
                    PropertyCard(
                        property: p,
                        onTap: () => context.push('/property', extra: p)),
                    const SizedBox(height: 14),
                  ],
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
                      onTap: () => context.push('/owner/properties')),
                  StatCard(
                      value: '${dashboard?.bookingsCount ?? 7}',
                      label: 'Active bookings',
                      onTap: () => context.push('/owner/bookings')),
                  StatCard(
                      value: '${dashboard?.monthlyEarnings ?? '68.4k'}',
                      label: 'EGP / month',
                      onTap: () => context.push('/owner/earnings')),
                ]),
                const SizedBox(height: 16),

                // 6. Action: List new property
                GestureDetector(
                  onTap: () => context.push('/owner/add-property'),
                  behavior: HitTestBehavior.opaque,
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
                  onAction: () => context.push('/owner/requests'),
                ),
                const SizedBox(height: 12),
                PendingRequestCard(
                    onTap: () => context.push('/owner/request-detail')),
                const SizedBox(height: 24),

                // 9. Portfolio Insights
                GestureDetector(
                  onTap: () => context.push('/owner/portfolio'),
                  behavior: HitTestBehavior.opaque,
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
                const SizedBox(height: 32),
                _buildFooter(),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
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
              fontSize: 12, color: AppColors.muted.withValues(alpha: 0.6)),
        ),
      ],
    );
  }
}
