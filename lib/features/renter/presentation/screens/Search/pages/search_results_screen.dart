import 'package:flutter/material.dart';

import 'package:sahely/core/navigation/app_router.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/features/renter/presentation/screens/home/widgets/filter_chips.dart';
import 'package:sahely/features/renter/presentation/screens/Search/widgets/search_result_card.dart';
import 'package:sahely/features/renter/presentation/screens/Search/pages/search_empty_state.dart';
import 'package:sahely/features/renter/presentation/screens/Search/pages/search_filters_sheet.dart';

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
  final String _selectedSort = 'Rating';
  final TextEditingController _searchController = TextEditingController();
  String _activeChip = 'All';

  // حفظ حالة الفلاتر المتقدمة بالكامل
  late Map<String, dynamic> _appliedFilters;

  final List<Map<String, dynamic>> _allProperties = [
    {
      'id': '1',
      'name': 'Lagoon Retreat',
      'location': 'Marassi',
      'distanceToBeach': '3 min to beach',
      'rating': 4.9,
      'reviewCount': 86,
      'price': 620000,
      'type': 'Villa',
      'beds': 3,
      'guests': 6,
      'imageUrl':
          'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=800',
      'features': ['Pool', 'WiFi', 'Beachfront', 'AC'],
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
      'price': 380000,
      'type': 'Chalet',
      'beds': 2,
      'guests': 4,
      'imageUrl':
          'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=800',
      'features': ['Pool', 'Budget'],
      'isFavorite': true,
      'badge': null,
      'isNew': true,
      'partyAllowed': false,
      'petsAllowed': false,
      'mixedGroupsOK': true,
    },
    {
      'id': '3',
      'name': 'Azure Villa',
      'location': 'North Coast',
      'distanceToBeach': '5 min to beach',
      'rating': 4.8,
      'reviewCount': 124,
      'price': 450000,
      'type': 'Villa',
      'beds': 4,
      'guests': 8,
      'imageUrl':
          'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=800',
      'features': ['Beachfront', 'Pool', 'Smart Lock'],
      'isFavorite': false,
      'badge': 'New',
      'isNew': true,
      'partyAllowed': true,
      'petsAllowed': false,
      'mixedGroupsOK': true,
    },
    {
      'id': '4',
      'name': 'Sea Breeze Chalet',
      'location': 'Amwaj',
      'distanceToBeach': '2 min to beach',
      'rating': 4.5,
      'reviewCount': 42,
      'price': 250000,
      'type': 'Chalet',
      'beds': 2,
      'guests': 4,
      'imageUrl':
          'https://images.unsplash.com/photo-1499793983690-e29da59ef1c2?w=800',
      'features': ['Beachfront', 'Budget', 'Parking'],
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
      'price': 950000,
      'type': 'Villa',
      'beds': 5,
      'guests': 12,
      'imageUrl':
          'https://images.unsplash.com/photo-1580587771525-78b9dba3b914?w=800',
      'features': ['Pool', 'Garden', 'Beachfront', 'Sea View'],
      'isFavorite': false,
      'badge': 'Premium',
      'isNew': true,
      'partyAllowed': true,
      'petsAllowed': true,
      'mixedGroupsOK': true,
    },
    {
      'id': '6',
      'name': 'Golden Sands Chalet',
      'location': 'Telal',
      'distanceToBeach': '5 min to beach',
      'rating': 4.6,
      'reviewCount': 65,
      'price': 320000,
      'type': 'Chalet',
      'beds': 2,
      'guests': 4,
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
      'distanceToBeach': '6 min to beach',
      'rating': 4.9,
      'reviewCount': 28,
      'price': 850000,
      'type': 'Villa',
      'beds': 4,
      'guests': 8,
      'imageUrl':
          'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?w=800',
      'features': ['Pool', 'WiFi'],
      'isFavorite': false,
      'badge': null,
      'isNew': false,
      'partyAllowed': true,
      'petsAllowed': true,
      'mixedGroupsOK': true,
    },
    {
      'id': '8',
      'name': 'Sunset Bay Apartment',
      'location': 'Marina 7',
      'distanceToBeach': '10 min to beach',
      'rating': 4.4,
      'reviewCount': 92,
      'price': 210000,
      'type': 'Apartment',
      'beds': 1,
      'guests': 2,
      'imageUrl':
          'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=800',
      'features': ['Budget', 'WiFi'],
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
      'distanceToBeach': '4 min to beach',
      'rating': 4.8,
      'reviewCount': 55,
      'price': 580000,
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
      'price': 420000,
      'type': 'Chalet',
      'beds': 2,
      'guests': 4,
      'imageUrl':
          'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=800',
      'features': ['Beachfront', 'WiFi'],
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
      'distanceToBeach': '15 min to beach',
      'rating': 4.3,
      'reviewCount': 110,
      'price': 150000,
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
      'price': 1200000,
      'type': 'Villa',
      'beds': 6,
      'guests': 12,
      'imageUrl':
          'https://images.unsplash.com/photo-1512918766775-d263234b4b73?w=800',
      'features': ['Pool', 'Beachfront', 'WiFi'],
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
      'price': 350000,
      'type': 'Chalet',
      'beds': 2,
      'guests': 4,
      'imageUrl':
          'https://images.unsplash.com/photo-1510798831971-661eb04b3739?w=800',
      'features': ['Pool', 'Budget'],
      'isFavorite': false,
      'badge': null,
      'isNew': false,
      'partyAllowed': true,
      'petsAllowed': false,
      'mixedGroupsOK': true,
    },
  ];

  List<Map<String, dynamic>> _filteredProperties = [];

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.initialQuery;

    // Initialize with provided filters or defaults
    _appliedFilters = widget.initialFilters ??
        {
          'propertyType': 'All',
          'bedrooms': 'Any',
          'minPrice': 0.0,
          'maxPrice': 100000.0,
          'amenities': <String>[],
          'partyAllowed': true,
          'petsAllowed': false,
          'mixedGroupsOK': true,
        };

    _applyCombinedFilter();
  }

  void _applyCombinedFilter() {
    String searchKeyword = _searchController.text.toLowerCase();
    List<Map<String, dynamic>> results = List.from(_allProperties);

    // 1. الفلترة بكلمة البحث
    if (searchKeyword.isNotEmpty) {
      results = results
          .where((p) =>
              p["name"].toLowerCase().contains(searchKeyword) ||
              p["location"].toLowerCase().contains(searchKeyword))
          .toList();
    }

    // 2. الفلترة بـ Chips العلوية
    if (_activeChip != 'All') {
      if (_activeChip == 'Beachfront') {
        results = results
            .where((p) => (p['features'] as List).contains('Beachfront'))
            .toList();
      } else if (_activeChip == 'Newest')
        results = results.where((p) => p['isNew'] == true).toList();
      else if (_activeChip == 'Top rated')
        results = results.where((p) => p['rating'] >= 4.8).toList();
      // Price ↑ handled at the end as sorting
    }

    // 3. الفلترة من الـ Bottom Sheet
    if (_appliedFilters['propertyType'] != 'All') {
      results = results
          .where((p) => p['type'] == _appliedFilters['propertyType'])
          .toList();
    }

    results = results.where((p) {
      double priceEgp = p['price'] / 100;
      return priceEgp >= _appliedFilters['minPrice'] &&
          priceEgp <= _appliedFilters['maxPrice'];
    }).toList();

    if (_appliedFilters['bedrooms'] != 'Any') {
      int needed = int.parse(_appliedFilters['bedrooms'].replaceAll('+', ''));
      results = results.where((p) => p['beds'] >= needed).toList();
    }

    if ((_appliedFilters['amenities'] as List).isNotEmpty) {
      results = results.where((p) {
        List pFeatures = p['features'] as List;
        return (_appliedFilters['amenities'] as List)
            .every((amenity) => pFeatures.contains(amenity));
      }).toList();
    }

    // فلترة القواعد (House Rules)
    if (_appliedFilters['partyAllowed'] == true)
      results = results.where((p) => p['partyAllowed'] == true).toList();
    if (_appliedFilters['petsAllowed'] == true)
      results = results.where((p) => p['petsAllowed'] == true).toList();
    if (_appliedFilters['mixedGroupsOK'] == true)
      results = results.where((p) => p['mixedGroupsOK'] == true).toList();

    // 4. Sorting for Price ↑
    if (_activeChip == 'Price ↑') {
      results.sort((a, b) => (a['price'] as num).compareTo(b['price'] as num));
    }

    setState(() {
      _filteredProperties = results;
    });
  }

  void _showFiltersSheet() {
    showModalBottomSheet(
      context: rootNavigatorKey.currentContext ?? context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.78,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return SearchFiltersSheet(
              initialFilters: _appliedFilters,
              allProperties: _allProperties,
              // تمرير القائمة للحساب الدقيق للعدد
              onApplyFilters: (newFilters) {
                setState(() {
                  _appliedFilters = newFilters;
                  _applyCombinedFilter();
                });
              },
            );
          },
        );
      },
    );
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
        'partyAllowed': true,
        'petsAllowed': false,
        'mixedGroupsOK': true,
      };
      _applyCombinedFilter();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildTopBar()),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            if (_filteredProperties.isNotEmpty) ...[
              SliverToBoxAdapter(child: _buildResultsHeader()),
              const SliverToBoxAdapter(child: SizedBox(height: 12)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: FilterChips(
                    filters: const ['All', 'Beachfront', 'Newest', 'Top rated', 'Price ↑'],
                    selectedFilter: _activeChip,
                    onFilterSelected: (chip) {
                      _activeChip = chip;
                      _applyCombinedFilter();
                    },
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
              SliverToBoxAdapter(child: _buildShowingCount()),
              const SliverToBoxAdapter(child: SizedBox(height: 12)),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: SearchResultCard(
                            property: _filteredProperties[index]),
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
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(Icons.chevron_left,
                  color: AppColors.navy, size: 20),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 46,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: AppColors.gold, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) => _applyCombinedFilter(),
                      decoration: const InputDecoration(
                        hintText: 'Beachfront villas',
                        hintStyle: TextStyle(
                            fontSize: 14,
                            color: AppColors.placeholder,
                            fontFamily: 'Cairo'),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.dark,
                          fontFamily: 'Cairo'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: _showFiltersSheet,
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.navy,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.tune, color: AppColors.gold, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.secondary,
                fontFamily: 'Cairo',
              ),
              children: [
                TextSpan(
                  text: '${_filteredProperties.length}',
                  style: const TextStyle(
                    color: AppColors.navy,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(text: ' stays in North Coast'),
              ],
            ),
          ),
          Row(
            children: [
              const Icon(Icons.sort, size: 16, color: AppColors.navy),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'Sort: $_selectedSort',
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.navy,
                      fontFamily: 'Cairo'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShowingCount() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Showing 1-${_filteredProperties.length}',
            style: const TextStyle(
                fontSize: 13,
                color: AppColors.placeholder,
                fontFamily: 'Cairo'),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
                color: AppColors.navy, borderRadius: BorderRadius.circular(20)),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star_border_rounded,
                    color: AppColors.gold, size: 18),
                // Gold border, hollow inside
                SizedBox(width: 6),
                Text(
                  'Map view',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                      fontFamily: 'Cairo'), // White text
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
