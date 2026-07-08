import 'dart:async';
import 'package:flutter/material.dart';
import '../../../data/models.dart';
import '../../../data/sample_data.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/chips.dart';
import '../../../widgets/common.dart';
import '../../../widgets/cream_background.dart';
import '../../../widgets/floating_nav.dart';
import '../../../widgets/kit.dart';
import '../../../widgets/property_card.dart';
import '../../../widgets/ui.dart';
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
  String? _selectedCategory;

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

  List<Property> get _filteredProperties {
    if (_selectedCategory == null || _selectedCategory == 'All') {
      return Sample.allTrending.take(3).toList();
    }
    return Sample.allTrending
        .where((p) => p.tags.contains(_selectedCategory!))
        .take(3)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return PhoneScaffold(
      child: Stack(children: [
        ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
          children: [
            // 1. Header
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Welcome back,', style: AppTheme.dm(size: 13, color: AppColors.muted)),
                Text('Layla Mansour', style: AppTheme.dm(size: 24, weight: FontWeight.w700, color: AppColors.navy)),
              ]),
              const RoleBadge(role: Role.owner),
            ]),
            const SizedBox(height: 16),

            // 2. Search bar row (Fixing Overflow)
            Row(children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/browse'),
                  child: Container(
                    height: 52,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(children: [
                      const Icon(Icons.search, color: AppColors.gold, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Search stay...',
                          style: AppTheme.dm(size: 14, color: AppColors.muted),
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () async {
                  final result = await Navigator.pushNamed(context, '/filters');
                  if (result is Map<String, dynamic> && context.mounted) {
                    Navigator.pushNamed(context, '/browse', arguments: result);
                  }
                },
                child: Container(
                  width: 48, 
                  height: 48, 
                  decoration: const BoxDecoration(color: AppColors.navy, shape: BoxShape.circle), 
                  child: const Icon(Icons.tune, color: AppColors.gold, size: 20),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/owner/ai-chat'),
                child: Stack(children: [
                  Container(
                    width: 48, 
                    height: 48, 
                    decoration: const BoxDecoration(color: Color(0xFFD4B982), shape: BoxShape.circle), 
                    child: const Icon(Icons.chat_bubble_outline, color: AppColors.navy, size: 20),
                  ),
                  Positioned(top: 4, right: 4, child: Container(width: 10, height: 10, decoration: BoxDecoration(color: const Color(0xFF34C759), shape: BoxShape.circle, border: Border.all(color: AppColors.cream, width: 2)))),
                ]),
              ),
            ]),
            const SizedBox(height: 18),

            // 3. Wave Rider Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(16)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Container(width: 32, height: 32, decoration: BoxDecoration(color: const Color(0xFF2E8B8B), borderRadius: BorderRadius.circular(8)), child: const Center(child: Text('🌊', style: TextStyle(fontSize: 16)))),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Wave Rider', style: AppTheme.dm(size: 16, weight: FontWeight.w700, color: Colors.white)),
                    Text('47 ★ this season', style: AppTheme.dm(size: 12, color: AppColors.goldLight)),
                  ])),
                  const Icon(Icons.chevron_right, color: Colors.white54, size: 18),
                ]),
                const SizedBox(height: 14),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(value: 0.6, backgroundColor: Colors.white.withValues(alpha: 0.12), valueColor: const AlwaysStoppedAnimation(AppColors.gold), minHeight: 4),
                ),
                const SizedBox(height: 10),
                Text('33 ★ to Coastal Regular', style: AppTheme.dm(size: 11, weight: FontWeight.w500, color: Colors.white60)),
              ]),
            ),
            const SizedBox(height: 16),

            // 4. Carousel Card (Dynamic & Automatic)
            SizedBox(
              height: 140,
              child: PageView.builder(
                controller: _carouselController,
                onPageChanged: (index) => setState(() => _currentCarouselPage = index),
                itemCount: _carouselItems.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 4),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFC9A84C), 
                      borderRadius: BorderRadius.circular(20),
                      gradient: const RadialGradient(center: Alignment(1.2, 0.4), radius: 1, colors: [Color(0xFFE4C56A), Color(0xFFC9A84C)]),
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(_carouselItems[index]['title']!, style: AppTheme.dm(size: 18, weight: FontWeight.w700, color: AppColors.navy)),
                      const SizedBox(height: 6),
                      Text(_carouselItems[index]['subtitle']!, style: AppTheme.dm(size: 13, color: AppColors.navy.withValues(alpha: 0.7), height: 1.4)),
                    ]),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Center(child: ProgressDots(count: _carouselItems.length, active: _currentCarouselPage)),
            const SizedBox(height: 22),

            // 5. Category Filters
            Row(children: [
              ChoiceChipPill('All', selected: _selectedCategory == 'All', onTap: () => setState(() => _selectedCategory = _selectedCategory == 'All' ? null : 'All')), 
              const SizedBox(width: 8),
              ChoiceChipPill('Beachfront', selected: _selectedCategory == 'Beachfront', onTap: () => setState(() => _selectedCategory = _selectedCategory == 'Beachfront' ? null : 'Beachfront')), 
              const SizedBox(width: 8),
              ChoiceChipPill('Pool', selected: _selectedCategory == 'Pool', onTap: () => setState(() => _selectedCategory = _selectedCategory == 'Pool' ? null : 'Pool')),
            ]),
            const SizedBox(height: 22),

            // 6. Trending Section (Working Filters)
            SectionHeader(
              title: 'Trending Now', 
              onAction: () => Navigator.pushNamed(context, '/all-properties'),
            ),
            const SizedBox(height: 14),
            if (_filteredProperties.isEmpty)
               Padding(
                 padding: const EdgeInsets.symmetric(vertical: 20),
                 child: Center(child: Text('No properties found in this category', style: AppTheme.dm(color: AppColors.muted))),
               )
            else
              for (var p in _filteredProperties) ...[
                PropertyCard(
                  property: p, 
                  onTap: () => Navigator.pushNamed(context, '/property', arguments: p),
                ),
                const SizedBox(height: 16),
              ],

            const SizedBox(height: 16),

            // 7. Your dashboard
            Text('Your dashboard', style: AppTheme.dm(size: 18, weight: FontWeight.w700, color: AppColors.navy)),
            const SizedBox(height: 12),
            const StatRow(cards: [
              StatCard(value: '3', label: 'Properties'),
              StatCard(value: '7', label: 'Active bookings'),
              StatCard(value: '68.4k', label: 'EGP / month'),
            ]),
            const SizedBox(height: 16),

            // 8. List a new property button
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/owner/add-property'),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.gold,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.home_work_outlined, color: AppColors.navy, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('List a new property', style: AppTheme.dm(size: 15, weight: FontWeight.w700, color: AppColors.navy)),
                    Text('Reach thousands of verified renters', style: AppTheme.dm(size: 12, color: AppColors.navy.withValues(alpha: 0.6))),
                  ])),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(color: AppColors.navy, shape: BoxShape.circle),
                    child: const Icon(Icons.add, size: 18, color: AppColors.gold),
                  ),
                ]),
              ),
            ),
            const SizedBox(height: 24),

            // 9. Pending Requests
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Pending Requests', style: AppTheme.dm(size: 18, weight: FontWeight.w700, color: AppColors.navy)),
              GestureDetector(onTap: () => Navigator.pushNamed(context, '/owner/requests'), child: Text('View all · 2', style: AppTheme.dm(size: 13, weight: FontWeight.w600, color: AppColors.gold))),
            ]),
            const SizedBox(height: 12),
            PendingRequestCard(onTap: () => Navigator.pushNamed(context, '/owner/request-detail')),
            const SizedBox(height: 16),

            // 10. Portfolio Insights Card
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/owner/portfolio'),
              child: WhiteCard(
                padding: const EdgeInsets.all(14),
                radius: 20,
                child: Row(children: [
                  Container(
                    width: 44,
                    height: 44, 
                    decoration: BoxDecoration(color: const Color(0xFFF5F0E8), borderRadius: BorderRadius.circular(12)), 
                    child: const Icon(Icons.bar_chart, color: AppColors.navy, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Portfolio Insights', style: AppTheme.dm(size: 14, weight: FontWeight.w700, color: AppColors.navy)),
                    Text('Compare all properties', style: AppTheme.dm(size: 12, color: AppColors.muted)),
                  ])),
                  const Icon(Icons.chevron_right, color: AppColors.faint, size: 18),
                ]),
              ),
            ),
          ],
        ),
        const FloatingNav(active: 0),
      ]),
    );
  }
}
