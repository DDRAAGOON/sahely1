import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sahely/core/navigation/app_navigation.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/chips.dart';
import 'package:sahely/core/widgets/common.dart';
import 'package:sahely/core/widgets/floating_nav.dart';
import 'package:sahely/core/widgets/property_card.dart';
import 'package:sahely/data/sample_data.dart';
import 'package:sahely/features/shared/widgets/browse_empty_state.dart';
import 'package:sahely/features/shared/widgets/search_header_with_input.dart';
import 'package:sahely/features/shared/widgets/small_prop_card.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _appliedSearchQuery = '';
  String _sortBy = 'Recommended';
  bool _priceAscending = true;
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
      final args = GoRouterState.of(context).extra;
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
          if (!selectedAmenities.every((am) => p.tags.contains(am))) {
            return false;
          }
        }
        final selectedRules = activeFilters['rules'] as List<String>?;
        if (selectedRules != null && selectedRules.contains('Pets allowed')) {
          if (!p.petsOk) return false;
        }
        return true;
      }).toList();
    }

    if (_sortBy == 'Top Rated') {
      results.sort((a, b) => b.rating.compareTo(a.rating));
    } else if (_sortBy == 'Price ↑') {
      results.sort((a, b) => a.price.compareTo(b.price));
    } else if (_sortBy == 'Price ↓') {
      results.sort((a, b) => b.price.compareTo(a.price));
    } else if (_sortBy == 'Newest') {
      results.sort((a, b) => b.id.compareTo(a.id));
    }

    return results;
  }

  void _showSortMenu() {
    showModalBottomSheet(
      useRootNavigator: true, context: context,
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
              child: Text('Sort by',
                  style: AppTheme.dm(
                      size: 16,
                      weight: FontWeight.w700,
                      color: AppColors.navy)),
            ),
            _sortOption(ctx, 'Recommended', 'Recommended'),
            _sortOption(ctx, 'Newest', 'Newest'),
            _sortOption(ctx, 'Top Rated', 'Top Rated'),
            _sortOption(ctx, 'Price: Low to High', 'Price ↑'),
            _sortOption(ctx, 'Price: High to Low', 'Price ↓'),
          ],
        ),
      ),
    );
  }

  Widget _sortOption(BuildContext ctx, String label, String value) {
    final isSelected = _sortBy == value;
    return ListTile(
      title: Text(label,
          style: AppTheme.dm(
              size: 14,
              color: isSelected ? AppColors.gold : AppColors.navy,
              weight: isSelected ? FontWeight.w700 : FontWeight.w400)),
      trailing: isSelected ? const Icon(Icons.check, color: AppColors.gold) : null,
      onTap: () {
        setState(() {
          _sortBy = value;
          if (value == 'Price ↑') _priceAscending = true;
          if (value == 'Price ↓') _priceAscending = false;
        });
        Navigator.pop(ctx);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final results = _filteredResults;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
              children: [
                SearchHeaderWithInput(
                  controller: _searchController,
                  onSubmitted: (v) => setState(() => _appliedSearchQuery = v),
                  onBack: () => Navigator.pop(context),
                  onFilter: () {
                    AppNavigation.goToFilters(
                      context,
                      initialFilters: _filters,
                      onApplyFilters: (result) {
                        setState(() => _filters = result);
                      },
                    );
                  },
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: AppTheme.dm(size: 14, color: AppColors.textSecondary),
                        children: [
                          TextSpan(
                            text: '${results.length} ',
                            style: AppTheme.dm(weight: FontWeight.w700, color: AppColors.navy),
                          ),
                          const TextSpan(text: 'stays in North Coast'),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: _showSortMenu,
                      behavior: HitTestBehavior.opaque,
                      child: Row(children: [
                        const Icon(Icons.filter_list, size: 14, color: AppColors.navy),
                        const SizedBox(width: 6),
                        Text('Sort: ${_sortBy.replaceAll(' ↑', '').replaceAll(' ↓', '')}',
                            style: AppTheme.dm(
                                size: 13,
                                weight: FontWeight.w600,
                                color: AppColors.navy)),
                      ]),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Filter Chips
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      ChoiceChipPill(
                        'Top rated',
                        selected: _sortBy == 'Top Rated',
                        borderColor: _sortBy == 'Top Rated' ? AppColors.navy : AppColors.border,
                        onTap: () {
                          setState(() {
                            _sortBy = (_sortBy == 'Top Rated') ? 'Recommended' : 'Top Rated';
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      ChoiceChipPill(
                        _sortBy.startsWith('Price') ? (_priceAscending ? 'Price ↑' : 'Price ↓') : 'Price',
                        selected: _sortBy.startsWith('Price'),
                        borderColor: _sortBy.startsWith('Price') ? AppColors.navy : AppColors.border,
                        onTap: () {
                          setState(() {
                            if (_sortBy.startsWith('Price')) {
                              _priceAscending = !_priceAscending;
                            } else {
                              _priceAscending = true;
                            }
                            _sortBy = _priceAscending ? 'Price ↑' : 'Price ↓';
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      ChoiceChipPill(
                        'Newest',
                        selected: _sortBy == 'Newest',
                        borderColor: _sortBy == 'Newest' ? AppColors.navy : AppColors.border,
                        onTap: () {
                          setState(() {
                             _sortBy = (_sortBy == 'Newest') ? 'Recommended' : 'Newest';
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      ChoiceChipPill(
                        'Beachfront',
                        selected: _filters?['type'] == 'Beachfront',
                        borderColor: _filters?['type'] == 'Beachfront' ? AppColors.navy : AppColors.border,
                        onTap: () {
                          setState(() {
                            _filters ??= {};
                            if (_filters!['type'] == 'Beachfront') {
                              _filters!.remove('type');
                            } else {
                              _filters!['type'] = 'Beachfront';
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                if (results.isEmpty)
                  const BrowseEmptyState()
                else ...[
                  for (var p in results) ...[
                    PropertyCard(
                      property: p,
                      onTap: () =>
                          AppNavigation.goToPropertyDetail(context, extra: p),
                    ),
                    const SizedBox(height: 16),
                  ],
                ],
                if (results.isNotEmpty && _appliedSearchQuery.isEmpty && _filters == null) ...[
                  const SectionHeader(
                      title: 'Top Rated in North Coast', action: null),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 240,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      clipBehavior: Clip.none,
                      children: [
                        SmallPropCard(
                            image: Sample.lagoon.image,
                            name: 'Cyan Chalet',
                            price: '3,200',
                            rating: '4.9'),
                        const SizedBox(width: 12),
                        SmallPropCard(
                            image: Sample.dunes.image,
                            name: 'Sand Loft',
                            price: '2,800',
                            rating: '4.8'),
                        const SizedBox(width: 12),
                        SmallPropCard(
                            image: Sample.lagoon.image,
                            name: 'Wave Villa',
                            price: '5,500',
                            rating: '5.0'),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            const FloatingNav(active: 0),
          ],
        ),
      ),
    );
  }
}
