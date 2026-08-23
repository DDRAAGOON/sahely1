import 'package:flutter/material.dart';

import 'package:sahely/core/navigation/app_navigation.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';
import 'package:sahely/features/renter/presentation/screens/home/widgets/filter_chips.dart';
import 'package:sahely/features/renter/presentation/screens/search/widgets/search_result_card.dart';
import 'package:sahely/features/renter/presentation/screens/search/pages/search_empty_state.dart';
import 'package:sahely/core/widgets/entrance_faded.dart';

class SearchResultsScreen extends StatefulWidget {
  final String initialQuery;
  final Map<String, dynamic>? initialFilters;

  const SearchResultsScreen({
    super.key,
    this.initialQuery = '',
    this.initialFilters,
  });

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _activeChip = 'All';
  bool _priceAscending = true;

  late Map<String, dynamic> _appliedFilters;

  final List<Map<String, dynamic>> _allData = [
    {
      'id': '1',
      'name': 'Lagoon Retreat',
      'location': 'Marassi',
      'distanceToBeach': '3 min to beach',
      'rating': 4.9,
      'reviewCount': 86,
      'price': 6200,
      'type': 'Villa',
      'beds': 3,
      'guests': 6,
      'imageUrl':
          'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=800',
      'features': ['Pool', 'Wi-Fi', 'Beachfront', 'AC'],
      'isFavorite': false,
      'badge': 'Guest favourite',
      'isNew': false,
      'partyAllowed': true,
      'petsAllowed': true,
      'mixedGroupsOK': true,
    },
    {
      'id': '2',
      'name': 'Golden Dunes',
      'location': 'Hacienda Bay',
      'distanceToBeach': '7 min to beach',
      'rating': 4.7,
      'reviewCount': 53,
      'price': 3800,
      'type': 'Chalet',
      'beds': 2,
      'guests': 4,
      'imageUrl':
          'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=800',
      'features': ['Pool', 'Budget'],
      'isFavorite': true,
      'badge': null,
      'isNew': false,
      'partyAllowed': false,
      'petsAllowed': false,
      'mixedGroupsOK': true,
    },
    {
      'id': '3',
      'name': 'Azure Villa',
      'location': 'North Coast',
      'distanceToBeach': '2 min to beach',
      'rating': 4.8,
      'reviewCount': 124,
      'price': 4500,
      'type': 'Villa',
      'beds': 4,
      'guests': 8,
      'imageUrl':
          'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=800',
      'features': ['Beachfront', 'Pool'],
      'isFavorite': false,
      'badge': 'Top Rated',
      'isNew': false,
      'partyAllowed': true,
      'petsAllowed': false,
      'mixedGroupsOK': true,
    },
    {
      'id': '4',
      'name': 'Sea Breeze Chalet',
      'location': 'Amwaj',
      'distanceToBeach': '5 min to beach',
      'rating': 4.5,
      'reviewCount': 42,
      'price': 2500,
      'type': 'Chalet',
      'beds': 2,
      'guests': 4,
      'imageUrl':
          'https://images.unsplash.com/photo-1499793983690-e29da59ef1c2?w=800',
      'features': ['Beachfront', 'Budget'],
      'isFavorite': false,
      'badge': null,
      'isNew': false,
      'partyAllowed': false,
      'petsAllowed': false,
      'mixedGroupsOK': false,
    },
    {
      'id': '5',
      'name': 'Royal Palace Villa',
      'location': 'Diplomats',
      'distanceToBeach': '1 min to beach',
      'rating': 5.0,
      'reviewCount': 15,
      'price': 9500,
      'type': 'Villa',
      'beds': 5,
      'guests': 10,
      'imageUrl':
          'https://images.unsplash.com/photo-1580587771525-78b9dba3b914?w=800',
      'features': ['Pool', 'Beachfront'],
      'isFavorite': false,
      'badge': 'Elite',
      'isNew': true,
      'partyAllowed': true,
      'petsAllowed': true,
      'mixedGroupsOK': true,
    },
    {
      'id': '6',
      'name': 'Golden Sands Chalet',
      'location': 'Telal',
      'distanceToBeach': '3 min to beach',
      'rating': 4.6,
      'reviewCount': 65,
      'price': 3200,
      'type': 'Chalet',
      'beds': 2,
      'guests': 5,
      'imageUrl':
          'https://images.unsplash.com/photo-1515263487990-61b07816b324?w=800',
      'features': ['Beachfront', 'Pool'],
      'isFavorite': false,
      'badge': null,
      'isNew': false,
      'partyAllowed': true,
      'petsAllowed': false,
      'mixedGroupsOK': true,
    },
    {
      'id': '7',
      'name': 'Pine Wood Villa',
      'location': 'Hacienda White',
      'distanceToBeach': '4 min to beach',
      'rating': 4.9,
      'reviewCount': 28,
      'price': 8500,
      'type': 'Villa',
      'beds': 4,
      'guests': 8,
      'imageUrl':
          'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?w=800',
      'features': ['Pool', 'Wi-Fi'],
      'isFavorite': false,
      'badge': 'Premium',
      'isNew': false,
      'partyAllowed': true,
      'petsAllowed': true,
      'mixedGroupsOK': true,
    },
    {
      'id': '8',
      'name': 'Sunset Bay Apartment',
      'location': 'Marina 7',
      'distanceToBeach': '6 min to beach',
      'rating': 4.4,
      'reviewCount': 92,
      'price': 2100,
      'type': 'Apartment',
      'beds': 1,
      'guests': 2,
      'imageUrl':
          'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=800',
      'features': ['Budget', 'Wi-Fi'],
      'isFavorite': false,
      'badge': null,
      'isNew': false,
      'partyAllowed': false,
      'petsAllowed': false,
      'mixedGroupsOK': true,
    },
    {
      'id': '9',
      'name': 'Palm Breeze Villa',
      'location': 'Fouka Bay',
      'distanceToBeach': '2 min to beach',
      'rating': 4.8,
      'reviewCount': 55,
      'price': 5800,
      'type': 'Villa',
      'beds': 3,
      'guests': 6,
      'imageUrl':
          'https://images.unsplash.com/photo-1493809842364-78817add7ffb?w=800',
      'features': ['Beachfront', 'Pool'],
      'isFavorite': false,
      'badge': null,
      'isNew': false,
      'partyAllowed': true,
      'petsAllowed': false,
      'mixedGroupsOK': true,
    },
    {
      'id': '10',
      'name': 'Coral Reef Chalet',
      'location': 'La Vista Cascada',
      'distanceToBeach': '3 min to beach',
      'rating': 4.7,
      'reviewCount': 34,
      'price': 4200,
      'type': 'Chalet',
      'beds': 2,
      'guests': 4,
      'imageUrl':
          'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=800',
      'features': ['Beachfront', 'Wi-Fi'],
      'isFavorite': false,
      'badge': null,
      'isNew': false,
      'partyAllowed': true,
      'petsAllowed': true,
      'mixedGroupsOK': true,
    },
    {
      'id': '11',
      'name': 'Urban Loft',
      'location': 'New Alamein',
      'distanceToBeach': '10 min to beach',
      'rating': 4.3,
      'reviewCount': 110,
      'price': 1500,
      'type': 'Apartment',
      'beds': 1,
      'guests': 2,
      'imageUrl':
          'https://images.unsplash.com/photo-1536376074432-8d2a32753b94?w=800',
      'features': ['Budget', 'AC'],
      'isFavorite': false,
      'badge': null,
      'isNew': false,
      'partyAllowed': false,
      'petsAllowed': false,
      'mixedGroupsOK': true,
    },
    {
      'id': '12',
      'name': 'White Pearl Villa',
      'location': 'Silver Sands',
      'distanceToBeach': '1 min to beach',
      'rating': 5.0,
      'reviewCount': 12,
      'price': 12000,
      'type': 'Villa',
      'beds': 6,
      'guests': 12,
      'imageUrl':
          'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=800',
      'features': ['Pool', 'Beachfront', 'Wi-Fi'],
      'isFavorite': false,
      'badge': 'Elite',
      'isNew': true,
      'partyAllowed': true,
      'petsAllowed': true,
      'mixedGroupsOK': true,
    },
    {
      'id': '13',
      'name': 'Morning Dew Chalet',
      'location': 'Mountain View',
      'distanceToBeach': '8 min to beach',
      'rating': 4.6,
      'reviewCount': 78,
      'price': 3500,
      'type': 'Chalet',
      'beds': 2,
      'guests': 4,
      'imageUrl':
          'https://images.unsplash.com/photo-1515263487990-61b07816b324?w=800',
      'features': ['Pool', 'Budget'],
      'isFavorite': false,
      'badge': null,
      'isNew': false,
      'partyAllowed': true,
      'petsAllowed': false,
      'mixedGroupsOK': true,
    },
  ];

  List<Property> get _allProperties =>
      _allData.map((m) => Property.fromMap(m)).toList();

  List<Property> _filteredProperties = [];

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.initialQuery;

    _appliedFilters = widget.initialFilters ??
        {
          'propertyType': 'All',
          'bedrooms': 'Any',
          'minPrice': 0.0,
          'maxPrice': 100000.0,
          'amenities': <String>[],
          'partyAllowed': false,
          'petsAllowed': false,
          'mixedGroupsOK': false,
          'adults': 0,
          'children': 0,
        };

    _applyCombinedFilter();
  }

  void _applyCombinedFilter() {
    String searchKeyword = _searchController.text.toLowerCase();
    List<Property> results = List.from(_allProperties);

    // 1. Text Search
    if (searchKeyword.isNotEmpty) {
      results = results
          .where((p) =>
              p.name.toLowerCase().contains(searchKeyword) ||
              p.area.toLowerCase().contains(searchKeyword))
          .toList();
    }

    // 2. Chip Filtering (Categorical)
    if (_activeChip == 'Beachfront') {
      results = results.where((p) => p.tags.contains('Beachfront')).toList();
    }

    // 3. Persistent Filters (from Bottom Sheet)
    if (_appliedFilters['propertyType'] != 'All') {
      results = results
          .where((p) => p.type == _appliedFilters['propertyType'])
          .toList();
    }

    results = results.where((p) {
      // Note: p.price is already in EGP based on the Property class definition
      double priceEgp = p.price.toDouble();
      return priceEgp >= (_appliedFilters['minPrice'] as num).toDouble() &&
          priceEgp <= (_appliedFilters['maxPrice'] as num).toDouble();
    }).toList();

    if (_appliedFilters['bedrooms'] != 'Any') {
      int needed = int.parse(_appliedFilters['bedrooms'].replaceAll('+', ''));
      results = results.where((p) => p.beds >= needed).toList();
    }

    if ((_appliedFilters['amenities'] as List).isNotEmpty) {
      results = results.where((p) {
        return (_appliedFilters['amenities'] as List)
            .every((amenity) => p.tags.contains(amenity));
      }).toList();
    }

    if (_appliedFilters['partyAllowed'] == true) {
      results = results.where((p) => p.partyAllowed).toList();
    }
    if (_appliedFilters['petsAllowed'] == true) {
      results = results.where((p) => p.petsOk).toList();
    }
    if (_appliedFilters['mixedGroupsOK'] == true) {
      results = results.where((p) => p.mixedGroupsOK).toList();
    }

    final int totalGuests = ((_appliedFilters['adults'] ?? 0) as int) +
        ((_appliedFilters['children'] ?? 0) as int);
    if (totalGuests > 0) {
      results = results.where((p) => p.guests >= totalGuests).toList();
    }

    // 4. Sorting (from Chips or Sort Menu)
    if (_activeChip.startsWith('Price')) {
      if (_priceAscending) {
        results.sort((a, b) => a.price.compareTo(b.price));
      } else {
        results.sort((a, b) => b.price.compareTo(a.price));
      }
    } else if (_activeChip == 'Top rated') {
      results.sort((a, b) => b.rating.compareTo(a.rating));
    } else if (_activeChip == 'Newest') {
      results.sort((a, b) => b.id.compareTo(a.id));
    }

    setState(() {
      _filteredProperties = results;
    });
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _activeChip = 'All';
      _appliedFilters = {
        'propertyType': 'All',
        'bedrooms': 'Any',
        'minPrice': 0.0,
        'maxPrice': 100000.0,
        'amenities': <String>[],
        'partyAllowed': false,
        'petsAllowed': false,
        'mixedGroupsOK': false,
        'adults': 0,
        'children': 0,
      };
      _applyCombinedFilter();
    });
  }

  void _showFiltersSheet() {
    AppNavigation.goToFilters(
      context,
      initialFilters: _appliedFilters,
      allProperties: _allProperties,
      onApplyFilters: (newFilters) {
        setState(() {
          _appliedFilters = newFilters;
          _applyCombinedFilter();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        bottom: false,
        child: EntranceFaded(
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 12),
              _buildFilterChips(),
              const SizedBox(height: 16),
              Expanded(
                child: _buildResultsList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(Icons.chevron_left, color: AppColors.navy),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: AppColors.gold, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (_) => _applyCombinedFilter(),
                      onSubmitted: (_) => _applyCombinedFilter(),
                      decoration: const InputDecoration(
                        hintText: 'Where to?',
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: AppTheme.dm(size: 13),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: _showFiltersSheet, // Restore filters sheet
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.navy,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.tune, color: AppColors.gold, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final isPriceActive = _activeChip.startsWith('Price');
    final priceLabel = isPriceActive ? (_priceAscending ? 'Price ↑' : 'Price ↓') : 'Price';
    final filters = ['All', 'Beachfront', 'Newest', 'Top rated', priceLabel];

    return SahelyFilterChips(
      selectedFilter: _activeChip,
      onFilterSelected: (chip) {
        setState(() {
          if (chip == 'Price' || chip.startsWith('Price')) {
            if (isPriceActive) {
              _priceAscending = !_priceAscending;
            } else {
              _priceAscending = true;
            }
            _activeChip = _priceAscending ? 'Price ↑' : 'Price ↓';
          } else {
            if (_activeChip == chip && chip != 'All') {
              _activeChip = 'All';
            } else {
              _activeChip = chip;
            }
          }
          _applyCombinedFilter();
        });
      },
      filters: filters,
    );
  }

  Widget _buildResultsList() {
    return CustomScrollView(
      slivers: [
        if (_filteredProperties.isNotEmpty) ...[
          SliverToBoxAdapter(child: _buildShowingCount()),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return StaggeredListItem(
                    index: index,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: SearchResultCard(
                        property: _filteredProperties[index],
                        onTap: () {},
                      ),
                    ),
                  );
                },
                childCount: _filteredProperties.length,
              ),
            ),
          ),
        ] else
          SliverFillRemaining(
            hasScrollBody: false,
            child: SearchEmptyState(
              searchQuery: _searchController.text,
              onClearFilters: _clearFilters,
              onBack: () => Navigator.pop(context),
            ),
          ),
      ],
    );
  }

  Widget _buildShowingCount() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        'Showing ${_filteredProperties.length} results',
        style: AppTheme.dm(
          size: 13,
          weight: FontWeight.w600,
          color: AppColors.muted,
        ),
      ),
    );
  }
}

class StaggeredListItem extends StatelessWidget {
  final int index;
  final Widget child;

  const StaggeredListItem({
    super.key,
    required this.index,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 400 + (index * 100).clamp(0, 500)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutQuart,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
