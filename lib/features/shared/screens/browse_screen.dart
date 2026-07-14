import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';
import '../../../data/models.dart';
import '../../../data/sample_data.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/common.dart';
import '../../../core/widgets/cream_background.dart';
import '../../../core/widgets/floating_nav.dart';
import '../../../core/widgets/property_card.dart';
import '../widgets/browse_empty_state.dart';
import '../widgets/search_header_with_input.dart';
import '../widgets/small_prop_card.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _appliedSearchQuery = '';
  String _sortBy = 'Recommended';
  Map<String, dynamic>? _filters;
  bool _isInit = true;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is String) {
        _searchController.text = args;
        _appliedSearchQuery = args;
      } else if (args is Map<String, dynamic>) {
        _filters = args;
      }
      _isInit = false;
    }
  }

  List<Property> get _filteredResults {
    List<Property> results = List.from(Sample.allTrending);

    if (_appliedSearchQuery.isNotEmpty) {
      results = results.where((p) {
        final searchLower = _appliedSearchQuery.toLowerCase();
        return p.name.toLowerCase().contains(searchLower) ||
            p.area.toLowerCase().contains(searchLower) ||
            p.type.toLowerCase().contains(searchLower);
      }).toList();
    }

    final activeFilters = _filters;
    if (activeFilters != null) {
      results = results.where((p) {
        if (activeFilters['type'] != null && activeFilters['type'] != 'All') {
          if (p.type != activeFilters['type']) return false;
        }
        if (activeFilters['beds'] != null && activeFilters['beds'] != 'Any') {
          final bedsStr = (activeFilters['beds'] as String).replaceAll('+', '');
          final filterBeds = int.tryParse(bedsStr) ?? 0;
          if (activeFilters['beds'].toString().contains('+')) {
            if (p.beds < filterBeds) return false;
          } else {
            if (p.beds != filterBeds) return false;
          }
        }
        if (activeFilters['guests'] != null && activeFilters['guests'] > 0) {
          if (p.guests < (activeFilters['guests'] as int)) return false;
        }
        final minPrice = activeFilters['minPrice'] as double?;
        final maxPrice = activeFilters['maxPrice'] as double?;
        if (minPrice != null && maxPrice != null) {
          if (p.price < minPrice || p.price > maxPrice) return false;
        }
        final selectedAmenities = activeFilters['amenities'] as List<String>?;
        if (selectedAmenities != null && selectedAmenities.isNotEmpty) {
          if (!selectedAmenities.every((am) => p.tags.contains(am))) return false;
        }
        final selectedRules = activeFilters['rules'] as List<String>?;
        if (selectedRules != null && selectedRules.contains('Pets allowed')) {
          if (!p.petsOk) return false;
        }
        return true;
      }).toList();
    }

    if (_sortBy == 'Price: Low to High') {
      results.sort((a, b) => a.price.compareTo(b.price));
    } else if (_sortBy == 'Price: High to Low') {
      results.sort((a, b) => b.price.compareTo(a.price));
    } else if (_sortBy == 'Top Rated') {
      results.sort((a, b) => b.rating.compareTo(a.rating));
    }

    return results;
  }

  void _showSortMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text('Sort by', style: AppTheme.dm(size: 16, weight: FontWeight.w700, color: AppColors.navy)),
            ),
            ...['Recommended', 'Top Rated', 'Price: Low to High', 'Price: High to Low'].map((s) => ListTile(
                  title: Text(s,
                      style: AppTheme.dm(
                          size: 14,
                          color: _sortBy == s ? AppColors.gold : AppColors.navy,
                          weight: _sortBy == s ? FontWeight.w700 : FontWeight.w400)),
                  trailing: _sortBy == s ? const Icon(Icons.check, color: AppColors.gold) : null,
                  onTap: () {
                    setState(() => _sortBy = s);
                    Navigator.pop(ctx);
                  },
                )),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final results = _filteredResults;

    return PhoneScaffold(
      child: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
            children: [
              SearchHeaderWithInput(
                controller: _searchController,
                onSubmitted: (v) => setState(() => _appliedSearchQuery = v),
                onBack: () => context.pop(),
                onFilter: () async {
                  final result = await context.push('/filters');
                  if (result is Map<String, dynamic>) {
                    setState(() => _filters = result);
                  }
                },
              ),
              if (_filters != null) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (_filters!['dates'] != null) Pill('📅 ${_filters!['dates']}', bg: AppColors.goldSoft, fg: AppColors.navy),
                    if (_filters!['guests'] != null && _filters!['guests'] > 0)
                      Pill('👥 ${_filters!['guests']} Guests', bg: AppColors.goldSoft, fg: AppColors.navy),
                    Pill('💰 ${_filters!['price']}', bg: AppColors.goldSoft, fg: AppColors.navy),
                    if (_filters!['type'] != null) Pill('🏠 ${_filters!['type']}', bg: AppColors.goldSoft, fg: AppColors.navy),
                    if (_filters!['beds'] != null) Pill('🛏️ ${_filters!['beds']} Beds', bg: AppColors.goldSoft, fg: AppColors.navy),
                    for (var rule in (_filters!['rules'] as List? ?? [])) Pill('📋 $rule', bg: AppColors.goldSoft, fg: AppColors.navy),
                    for (var amenity in (_filters!['amenities'] as List? ?? []))
                      Pill('✨ $amenity', bg: AppColors.goldSoft, fg: AppColors.navy),
                  ],
                ),
              ],
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${results.length} properties found',
                      style: AppTheme.dm(size: 14, weight: FontWeight.w600, color: AppColors.muted)),
                  GestureDetector(
                    onTap: _showSortMenu,
                    behavior: HitTestBehavior.opaque,
                    child: Row(children: [
                      Text('Sort: $_sortBy', style: AppTheme.dm(size: 13, weight: FontWeight.w600, color: AppColors.navy)),
                      const Icon(Icons.keyboard_arrow_down, size: 16, color: AppColors.navy),
                    ]),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (results.isEmpty)
                const BrowseEmptyState()
              else
                for (var p in results) ...[
                  PropertyCard(
                    property: p,
                    onTap: () => context.push('/property', extra: p),
                  ),
                  const SizedBox(height: 16),
                ],
              if (results.isNotEmpty && _appliedSearchQuery.isEmpty) ...[
                const SectionHeader(title: 'Top Rated in North Coast', action: null),
                const SizedBox(height: 12),
                SizedBox(
                  height: 240,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    clipBehavior: Clip.none,
                    children: [
                      SmallPropCard(image: Sample.lagoon.image, name: 'Cyan Chalet', price: '3,200', rating: '4.9'),
                      const SizedBox(width: 12),
                      SmallPropCard(image: Sample.dunes.image, name: 'Sand Loft', price: '2,800', rating: '4.8'),
                      const SizedBox(width: 12),
                      SmallPropCard(image: Sample.lagoon.image, name: 'Wave Villa', price: '5,500', rating: '5.0'),
                    ],
                  ),
                ),
              ],
            ],
          ),
          const FloatingNav(active: 0),
        ],
      ),
    );
  }
}
