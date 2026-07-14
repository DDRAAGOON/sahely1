import 'dart:async';
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
import '../../../core/widgets/floating_nav.dart';
import '../../../core/widgets/kit.dart';
import '../../../core/widgets/property_card.dart';
import '../../../core/widgets/ui.dart';
import '../widgets/pending_request_card.dart';

class OwnerHomeScreen extends StatefulWidget {
  const OwnerHomeScreen({super.key});

  @override
  State<OwnerHomeScreen> createState() => _OwnerHomeScreenState();
}

class _OwnerHomeScreenState extends State<OwnerHomeScreen> {
  final PageController _carouselController = PageController();
  Timer? _carouselTimer;
  int _currentCarouselPage = 0;
  String? _selectedCategory = 'All';

  final List<Map<String, String>> _carouselItems = [
    {
      'title': 'Book with Confidence',
      'subtitle': 'Secure payments, verified\nproperties.',
    },
    {
      'title': 'Maximize Earnings',
      'subtitle': 'Learn how to optimize your\nproperty listings.',
    },
    {
      'title': 'Premium Support',
      'subtitle': 'Get 24/7 assistance for all\nyour hosting needs.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _startCarouselTimer();
  }

  void _startCarouselTimer() {
    _carouselTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (_currentCarouselPage < _carouselItems.length - 1) {
        _currentCarouselPage++;
      } else {
        _currentCarouselPage = 0;
      }
      if (_carouselController.hasClients) {
        _carouselController.animateToPage(
          _currentCarouselPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _carouselTimer?.cancel();
    _carouselController.dispose();
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
        .where((p) => p.tags.contains(_selectedCategory!))
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
            return const Center(child: CircularProgressIndicator(color: Color(0xFFC9A84C)));
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
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Welcome back,', style: AppTheme.dm(size: 13, color: AppColors.muted)),
                    Text(dashboard?.ownerName ?? 'Layla Mansour', style: AppTheme.dm(size: 24, weight: FontWeight.w700, color: AppColors.navy)),
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
                      const Icon(Icons.search, color: AppColors.gold, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Search your bookings...',
                          style: AppTheme.dm(size: 14, color: AppColors.textPlaceholder),
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
                  decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(14)), 
                  child: const Icon(Icons.tune, color: AppColors.gold, size: 22),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => context.push('/owner/ai-chat'),
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: 50, 
                  height: 50, 
                  decoration: BoxDecoration(color: AppColors.gold, borderRadius: BorderRadius.circular(14)), 
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(Icons.chat_bubble_outline, color: AppColors.navy, size: 22),
                      Positioned(top: 10, right: 10, child: Container(width: 10, height: 10, decoration: BoxDecoration(color: const Color(0xFF34C759), shape: BoxShape.circle, border: Border.all(color: AppColors.cream, width: 2)))),
                    ],
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 18),

            // 3. MAWSEM Card (Synced Design)
            _MawsemOwnerCard(onTap: () => context.push('/mawsem')),
            const SizedBox(height: 16),

            // 4. Carousel Banners
            SizedBox(
              height: 120,
              child: PageView.builder(
                controller: _carouselController,
                onPageChanged: (index) => setState(() => _currentCarouselPage = index),
                itemCount: _carouselItems.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      gradient: AppColors.goldGradient,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(_carouselItems[index]['title']!, style: AppTheme.dm(size: 17, weight: FontWeight.w700, color: AppColors.navy)),
                      const SizedBox(height: 4),
                      Text(_carouselItems[index]['subtitle']!, style: AppTheme.dm(size: 12, color: AppColors.navy.withValues(alpha: 0.7), height: 1.3)),
                    ]),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Center(child: ProgressDots(count: _carouselItems.length, active: _currentCarouselPage)),
            const SizedBox(height: 20),

                // 5. Dashboard Stats
                Text('Dashboard Overview', style: AppTheme.dm(size: 18, weight: FontWeight.w700, color: AppColors.navy)),
                const SizedBox(height: 12),
                StatRow(cards: [
                  StatCard(value: '${dashboard?.propertiesCount ?? 3}', label: 'Properties', onTap: () => context.push('/owner/properties')),
                  StatCard(value: '${dashboard?.bookingsCount ?? 7}', label: 'Bookings', onTap: () => context.push('/owner/bookings')),
                  StatCard(value: '${dashboard?.monthlyEarnings ?? '68k'}', label: 'EGP/mo', onTap: () => context.push('/owner/earnings')),
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
                    width: 42, height: 42,
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.add_home_work, color: AppColors.navy, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('List a new property', style: AppTheme.dm(size: 15, weight: FontWeight.w700, color: AppColors.navy)),
                    Text('Reach more verified guests', style: AppTheme.dm(size: 11, color: AppColors.navy.withValues(alpha: 0.6))),
                  ])),
                  const Icon(Icons.chevron_right, color: AppColors.navy),
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
            PendingRequestCard(onTap: () => context.push('/owner/request-detail')),
            const SizedBox(height: 24),

            // 8. Categories & Portfolio
            Text('Your Properties', style: AppTheme.dm(size: 18, weight: FontWeight.w700, color: AppColors.navy)),
            const SizedBox(height: 12),
            Row(children: [
              ChoiceChipPill('All', selected: _selectedCategory == 'All', onTap: () {
                setState(() {
                  _selectedCategory = 'All';
                  _filteredProperties = _getFilteredFromDashboard();
                });
              }), 
              const SizedBox(width: 8),
              ChoiceChipPill('Villa', selected: _selectedCategory == 'Villa', onTap: () {
                setState(() {
                  _selectedCategory = 'Villa';
                  _filteredProperties = _getFilteredFromDashboard();
                });
              }), 
              const SizedBox(width: 8),
              ChoiceChipPill('Chalet', selected: _selectedCategory == 'Chalet', onTap: () {
                setState(() {
                  _selectedCategory = 'Chalet';
                  _filteredProperties = _getFilteredFromDashboard();
                });
              }),
            ]),
            const SizedBox(height: 16),
                if (_filteredProperties.isEmpty)
                   Center(child: Padding(padding: const EdgeInsets.all(32), child: Text('No properties in this category', style: AppTheme.dm(color: AppColors.muted))))
                else
                  for (var p in _filteredProperties) ...[
                    PropertyCard(property: p, onTap: () => context.push('/owner/insights', extra: p)),
                    const SizedBox(height: 14),
                  ],

            const SizedBox(height: 12),
            _buildExploreSection(),
            const SizedBox(height: 24),

            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => context.push('/owner/portfolio'),
              behavior: HitTestBehavior.opaque,
              child: WhiteCard(
                padding: const EdgeInsets.all(16),
                child: Row(children: [
                  const Icon(Icons.insights, color: AppColors.gold, size: 24),
                  const SizedBox(width: 14),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Full Portfolio Insights', style: AppTheme.dm(size: 14, weight: FontWeight.w700, color: AppColors.navy)),
                    Text('Performance, occupancy, and trends', style: AppTheme.dm(size: 12, color: AppColors.muted)),
                  ])),
                  const Icon(Icons.chevron_right, color: AppColors.faint, size: 18),
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

  Widget _buildExploreSection() {
    final locations = [
      {'name': 'Marassi', 'image': 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=400'},
      {'name': 'Hacienda Bay', 'image': 'https://images.unsplash.com/photo-1519046904884-53103b34b206?w=400'},
      {'name': 'Telal', 'image': 'https://images.unsplash.com/photo-1506929194765-410711158975?w=400'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Explore North Coast', style: AppTheme.dm(size: 18, weight: FontWeight.w700, color: AppColors.navy)),
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: ListView.separated(
            padding: EdgeInsets.zero,
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
          style: TextStyle(fontSize: 12, color: AppColors.muted.withValues(alpha: 0.6)),
        ),
      ],
    );
  }
}

class _MawsemOwnerCard extends StatelessWidget {
  const _MawsemOwnerCard({this.onTap});
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: AppColors.navyGradient,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
        ),
        child: Column(children: [
          Row(children: [
            Container(width: 32, height: 32, alignment: Alignment.center, decoration: BoxDecoration(color: const Color(0xFF2E8B8B), borderRadius: BorderRadius.circular(8)), child: const Text('🌊', style: TextStyle(fontSize: 16))),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Host Level: Wave Rider', style: AppTheme.dm(size: 14, weight: FontWeight.w700, color: Colors.white)),
              Text('47 ★ earned from bookings', style: AppTheme.dm(size: 11, color: AppColors.gold)),
            ])),
            const Icon(Icons.chevron_right, color: AppColors.gold, size: 18),
          ]),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: const LinearProgressIndicator(value: 0.6, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(AppColors.gold), minHeight: 6),
          ),
          const SizedBox(height: 8),
          Align(alignment: Alignment.centerLeft, child: Text('33 ★ to Elite Host perks', style: AppTheme.dm(size: 11, color: Colors.white54))),
        ]),
      ),
    );
  }
}
