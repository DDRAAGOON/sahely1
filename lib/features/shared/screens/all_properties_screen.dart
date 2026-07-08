import 'package:flutter/material.dart';
import '../../../data/sample_data.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../widgets/chips.dart';
import '../widgets/cream_background.dart';
import '../widgets/hero_property_card.dart';

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
    return PhoneScaffold(
      child: Column(
        children: [
          // 1. Custom Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      border: Border.all(color: AppColors.border),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.chevron_left, size: 20, color: AppColors.navy),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, size: 18, color: AppColors.gold),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: (v) => setState(() => _query = v),
                            decoration: InputDecoration(
                              hintText: 'Search properties',
                              hintStyle: AppTheme.dm(size: 13, color: AppColors.faint),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                            style: AppTheme.dm(size: 13, color: AppColors.navy),
                          ),
                        ),
                        if (_query.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              _searchController.clear();
                              setState(() => _query = '');
                            },
                            child: const Icon(Icons.close, size: 16, color: AppColors.faint),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () async {
                    final result = await Navigator.pushNamed(context, '/filters');
                    if (result is Map<String, dynamic> && context.mounted) {
                      // Optionally navigate to browse results with these filters
                      Navigator.pushNamed(context, '/browse', arguments: result);
                    }
                  },
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.navy,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.tune, color: AppColors.gold, size: 20),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/ai-chat'),
                  child: Stack(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD4B982),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.chat_bubble_outline, color: AppColors.navy, size: 20),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: const Color(0xFF34C759),
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.cream, width: 2),
                          ),
                        ),
                      ),
                    ],
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
                for (var f in ['All', 'Trending Now', 'Best Offers', 'Newly Added']) ...[
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

          // 3. Properties List with Sections
          Expanded(
            child: _query.isNotEmpty ? _buildSearchResults() : _buildSections(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    final results = Sample.allTrending.where((p) {
      final q = _query.toLowerCase();
      return p.name.toLowerCase().contains(q) || p.area.toLowerCase().contains(q);
    }).toList();

    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 64, color: AppColors.faint),
            const SizedBox(height: 16),
            Text('No properties found for "$_query"', style: AppTheme.dm(size: 14, color: AppColors.muted)),
          ],
        ),
      );
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
            badgeColor: p.rating >= 4.8 ? const Color(0xFFB22222) : AppColors.gold,
          ),
        );
      },
    );
  }

  Widget _buildSections() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
      children: [
        if (_selectedFilter == 'All' || _selectedFilter == 'Trending Now') ...[
          _sectionHeader('🔥 TRENDING NOW'),
          const HeroPropertyCard(
            property: Sample.azure,
            badge: 'Trending',
            badgeColor: Color(0xFFB22222),
          ),
          const SizedBox(height: 16),
          const HeroPropertyCard(
            property: Sample.lagoon,
            badge: 'Trending',
            badgeColor: Color(0xFFB22222),
          ),
          const SizedBox(height: 24),
        ],
        if (_selectedFilter == 'All' || _selectedFilter == 'Best Offers') ...[
          _sectionHeader('💰 BEST OFFERS'),
          const HeroPropertyCard(
            property: Sample.dunes,
            badge: '-15%',
            badgeColor: Color(0xFF1B6B3A),
            grayscale: true,
          ),
          const SizedBox(height: 24),
        ],
        if (_selectedFilter == 'All' || _selectedFilter == 'Newly Added') ...[
          _sectionHeader('✨ NEWLY ADDED'),
          const HeroPropertyCard(
            property: Sample.lagoon,
            badge: 'New',
            badgeColor: Color(0xFFC9A84C),
            nameOverride: 'Marina Loft',
          ),
          const SizedBox(height: 16),
          const HeroPropertyCard(
            property: Sample.azure,
            badge: 'New',
            badgeColor: Color(0xFFC9A84C),
            nameOverride: 'Palm Chalet',
          ),
        ],
      ],
    );
  }

  Widget _sectionHeader(String title) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: AppTheme.dm(size: 13, weight: FontWeight.w700, color: AppColors.muted, letterSpacing: 0.5)),
          ],
        ),
      );
}
