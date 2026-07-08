import 'package:flutter/material.dart';
import '../../data/models.dart';
import '../../data/sample_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../widgets/chips.dart';
import '../../widgets/common.dart';
import '../../widgets/cream_background.dart';
import '../../widgets/floating_nav.dart';
import '../../widgets/property_card.dart';
import '../../widgets/ui.dart';

class RenterHomeScreen extends StatefulWidget {
  const RenterHomeScreen({super.key});

  @override
  State<RenterHomeScreen> createState() => _RenterHomeScreenState();
}

class _RenterHomeScreenState extends State<RenterHomeScreen> {
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return PhoneScaffold(
      child: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
            children: [
              // Greeting + role badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Good morning,', style: AppTheme.dm(size: 13, color: AppColors.muted)),
                      const SizedBox(height: 1),
                      Text('Mariam Hassan',
                          style: AppTheme.dm(size: 22, weight: FontWeight.w700, color: AppColors.navy)),
                    ],
                  ),
                  const RoleBadge(role: Role.renter),
                ],
              ),
              const SizedBox(height: 14),
              SearchHeaderRow(
                onSearchTap: () => Navigator.pushNamed(context, '/browse'),
                onFilter: () async {
                  final result = await Navigator.pushNamed(context, '/filters');
                  if (result is Map<String, dynamic> && context.mounted) {
                    Navigator.pushNamed(context, '/browse', arguments: result);
                  }
                },
              ),
              const SizedBox(height: 12),
              _MawsemMiniCard(onTap: () => Navigator.pushNamed(context, '/mawsem')),
              const SizedBox(height: 14),
              _PromoCard(),
              const SizedBox(height: 10),
              const ProgressDots(count: 3, active: 0),
              const SizedBox(height: 14),
              Row(
                children: [
                  ChoiceChipPill('All', selected: _selectedCategory == 'All', onTap: () => setState(() => _selectedCategory = _selectedCategory == 'All' ? null : 'All')),
                  const SizedBox(width: 8),
                  ChoiceChipPill('Beachfront', selected: _selectedCategory == 'Beachfront', onTap: () => setState(() => _selectedCategory = _selectedCategory == 'Beachfront' ? null : 'Beachfront')),
                  const SizedBox(width: 8),
                  ChoiceChipPill('Pool', selected: _selectedCategory == 'Pool', onTap: () => setState(() => _selectedCategory = _selectedCategory == 'Pool' ? null : 'Pool')),
                ],
              ),
              const SizedBox(height: 18),
              SectionHeader(title: 'Trending Now', onAction: () => Navigator.pushNamed(context, '/all-properties')),
              const SizedBox(height: 12),
              PropertyCard(property: Sample.azure, onTap: () => Navigator.pushNamed(context, '/property', arguments: Sample.azure)),
              const SizedBox(height: 12),
              PropertyMiniCard(property: Sample.lagoon, onTap: () => Navigator.pushNamed(context, '/property', arguments: Sample.lagoon)),
              const SizedBox(height: 12),
              PropertyMiniCard(property: Sample.dunes, onTap: () => Navigator.pushNamed(context, '/property', arguments: Sample.dunes)),
              const SizedBox(height: 12),
              PropertyMiniCard(property: Sample.telal, onTap: () => Navigator.pushNamed(context, '/property', arguments: Sample.telal)),
              const SizedBox(height: 18),
              SectionHeader(title: 'Top Services', onAction: () => Navigator.pushNamed(context, '/services')),
              const SizedBox(height: 12),
              _ServiceRow(),
              const SizedBox(height: 18),
              Text('Explore North Coast',
                  style: AppTheme.dm(size: 18, weight: FontWeight.w600, color: AppColors.navy)),
              const SizedBox(height: 12),
              _DestinationRow(),
              const SizedBox(height: 18),
              _InviteCard(),
              const SizedBox(height: 18),
              _FeedFooter(),
            ],
          ),
          const FloatingNav(active: 0),
        ],
      ),
    );
  }
}

class _MawsemMiniCard extends StatelessWidget {
  const _MawsemMiniCard({this.onTap});
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF22335A), AppColors.navy]),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.gold.withValues(alpha: 0.5)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: const Color(0xFF3A9B8E), borderRadius: BorderRadius.circular(8)),
                  child: const Text('🌊', style: TextStyle(fontSize: 15)),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Wave Rider',
                          style: AppTheme.dm(size: 14, weight: FontWeight.w700, color: AppColors.white)),
                      Text('47 ★ this season', style: AppTheme.dm(size: 11, color: AppColors.gold)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.gold),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: 0.58,
                minHeight: 6,
                backgroundColor: Colors.white.withValues(alpha: 0.15),
                valueColor: const AlwaysStoppedAnimation(AppColors.gold),
              ),
            ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('33 ★ to Coastal Regular', style: AppTheme.dm(size: 11, color: const Color(0xFFCDD4E0))),
            ),
          ],
        ),
      ),
    );
  }
}

class _PromoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [AppColors.gold, Color(0xFFB3923C)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.12), shape: BoxShape.circle),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Book with Confidence',
                    style: AppTheme.dm(size: 17, weight: FontWeight.w700, color: AppColors.navy)),
                const SizedBox(height: 4),
                SizedBox(
                  width: 200,
                  child: Text('Secure payments, verified properties.',
                      style: AppTheme.dm(size: 12, color: const Color(0xFF3A3320))),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 124,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: Sample.services.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final s = Sample.services[i];
          return SizedBox(
            width: 108,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 84,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: s.gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                const SizedBox(height: 7),
                Text(s.name, style: AppTheme.dm(size: 12, weight: FontWeight.w700, color: AppColors.navy)),
                Text(s.fromPrice, style: AppTheme.dm(size: 11, color: AppColors.muted)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _DestinationRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: Sample.destinations.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final (name, url) = Sample.destinations[i];
          return SizedBox(
            width: 140,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(url, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const ColoredBox(color: AppColors.cardWarm)),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Color(0xB31B2744)],
                        stops: [0.45, 1],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 10,
                    bottom: 8,
                    child: Text(name, style: AppTheme.dm(size: 13, weight: FontWeight.w700, color: AppColors.white)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _InviteCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF2A3A64), AppColors.navy], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(color: AppColors.gold, borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.person_add_alt, color: AppColors.navy, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Invite friends, earn 15 ★',
                    style: AppTheme.dm(size: 14, weight: FontWeight.w700, color: AppColors.white)),
                Text('When they book & complete a stay',
                    style: AppTheme.dm(size: 11, color: const Color(0xFFCDD4E0))),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.gold),
        ],
      ),
    );
  }
}

class _FeedFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Column(
        children: [
          Text('SAHELY', style: AppTheme.dm(size: 20, weight: FontWeight.w700, color: AppColors.navy, letterSpacing: 5)),
          const SizedBox(height: 4),
          Text('Verified Chalets. Zero Chaos.', style: AppTheme.dm(size: 12, color: const Color(0xFF9A7A22))),
          const SizedBox(height: 8),
          Text("You've reached the end · North Coast, Egypt",
              style: AppTheme.dm(size: 11, color: AppColors.faint)),
        ],
      ),
    );
  }
}
