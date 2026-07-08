import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../widgets/home_header.dart';
import '../widgets/filter_chips.dart';
import '../widgets/property_section.dart';
import '../../Search/pages/search_filters_sheet.dart';
import '../../Search/pages/search_empty_state.dart';
import '../../property/page/property_detail_screen.dart';

class AllPropertiesScreen extends StatefulWidget {
  final Map<String, dynamic>? initialFilters;
  const AllPropertiesScreen({super.key, this.initialFilters});

  @override
  State<AllPropertiesScreen> createState() => _AllPropertiesScreenState();
}

class _AllPropertiesScreenState extends State<AllPropertiesScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Trending Now', 'Best Offers', 'Newly Added'];
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  
  Map<String, dynamic> _appliedFilters = {
    'propertyType': 'All',
    'bedrooms': 'Any',
    'minPrice': 0.0,
    'maxPrice': 100000.0,
    'amenities': <String>[],
    'partyAllowed': true,
    'petsAllowed': false,
    'mixedGroupsOK': true,
  };

  // Master Data List synchronized with Home
  final List<Map<String, dynamic>> _masterProperties = [
    {
      'id': '1', 'name': 'Lagoon Retreat', 'location': 'Marassi', 'rating': 4.9, 'reviewCount': 86, 
      'price': 620000, 'type': 'Villa', 'beds': 3, 'features': ['Pool', 'Beachfront'], 'imageUrl': 'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=800',
      'partyAllowed': true, 'petsAllowed': true, 'mixedGroupsOK': true,
    },
    {
      'id': '2', 'name': 'Golden Dunes', 'location': 'Hacienda Bay', 'rating': 4.7, 'reviewCount': 53, 
      'price': 380000, 'type': 'Chalet', 'beds': 2, 'features': ['Pool', 'Budget'], 'imageUrl': 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=800',
      'partyAllowed': false, 'petsAllowed': false, 'mixedGroupsOK': true,
    },
    {
      'id': '3', 'name': 'Azure Villa', 'location': 'North Coast', 'rating': 4.8, 'reviewCount': 124, 
      'price': 450000, 'type': 'Villa', 'beds': 4, 'features': ['Beachfront', 'Pool'], 'imageUrl': 'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=800',
      'partyAllowed': true, 'petsAllowed': false, 'mixedGroupsOK': true,
    },
    {
      'id': '4', 'name': 'Sea Breeze Chalet', 'location': 'Amwaj', 'rating': 4.5, 'reviewCount': 42, 
      'price': 250000, 'type': 'Chalet', 'beds': 2, 'features': ['Beachfront', 'Budget'], 'imageUrl': 'https://images.unsplash.com/photo-1499793983690-e29da59ef1c2?w=800',
      'partyAllowed': false, 'petsAllowed': false, 'mixedGroupsOK': false,
    },
    {
      'id': '5', 'name': 'Royal Palace Villa', 'location': 'Diplomats', 'rating': 5.0, 'reviewCount': 15, 
      'price': 950000, 'type': 'Villa', 'beds': 5, 'features': ['Pool', 'Beachfront'], 'imageUrl': 'https://images.unsplash.com/photo-1580587771525-78b9dba3b914?w=800',
      'partyAllowed': true, 'petsAllowed': true, 'mixedGroupsOK': true,
    },
    {
      'id': '6', 'name': 'Golden Sands Chalet', 'location': 'Telal', 'rating': 4.6, 'reviewCount': 65, 
      'price': 320000, 'type': 'Chalet', 'beds': 2, 'features': ['Beachfront', 'Pool'], 'imageUrl': 'https://images.unsplash.com/photo-1515263487990-61b07816b324?w=800',
      'partyAllowed': true, 'petsAllowed': false, 'mixedGroupsOK': true,
    },
    {
      'id': '7', 'name': 'Pine Wood Villa', 'location': 'Hacienda White', 'rating': 4.9, 'reviewCount': 28, 
      'price': 850000, 'type': 'Villa', 'beds': 4, 'features': ['Pool', 'WiFi'], 'imageUrl': 'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?w=800',
      'partyAllowed': true, 'petsAllowed': true, 'mixedGroupsOK': true,
    },
    {
      'id': '8', 'name': 'Sunset Bay Apartment', 'location': 'Marina 7', 'rating': 4.4, 'reviewCount': 92, 
      'price': 210000, 'type': 'Apartment', 'beds': 1, 'features': ['Budget', 'WiFi'], 'imageUrl': 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=800',
      'partyAllowed': false, 'petsAllowed': false, 'mixedGroupsOK': true,
    },
    {
      'id': '9', 'name': 'Palm Breeze Villa', 'location': 'Fouka Bay', 'rating': 4.8, 'reviewCount': 55, 
      'price': 580000, 'type': 'Villa', 'beds': 3, 'features': ['Beachfront', 'Pool'], 'imageUrl': 'https://images.unsplash.com/photo-1493809842364-78817add7ffb?w=800',
      'partyAllowed': true, 'petsAllowed': false, 'mixedGroupsOK': true,
    },
    {
      'id': '10', 'name': 'Coral Reef Chalet', 'location': 'La Vista Cascada', 'rating': 4.7, 'reviewCount': 34, 
      'price': 420000, 'type': 'Chalet', 'beds': 2, 'features': ['Beachfront', 'WiFi'], 'imageUrl': 'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=800',
      'partyAllowed': true, 'petsAllowed': true, 'mixedGroupsOK': true,
    },
    {
      'id': '11', 'name': 'Urban Loft', 'location': 'New Alamein', 'rating': 4.3, 'reviewCount': 110, 
      'price': 150000, 'type': 'Apartment', 'beds': 1, 'features': ['Budget', 'AC'], 'imageUrl': 'https://images.unsplash.com/photo-1536376074432-8d2a32753b94?w=800',
      'partyAllowed': false, 'petsAllowed': false, 'mixedGroupsOK': true,
    },
    {
      'id': '12', 'name': 'White Pearl Villa', 'location': 'Silver Sands', 'rating': 5.0, 'reviewCount': 12, 
      'price': 1200000, 'type': 'Villa', 'beds': 6, 'features': ['Pool', 'Beachfront', 'WiFi'], 'imageUrl': 'https://images.unsplash.com/photo-1512918766775-d263234b4b73?w=800',
      'partyAllowed': true, 'petsAllowed': true, 'mixedGroupsOK': true,
    },
    {
      'id': '13', 'name': 'Morning Dew Chalet', 'location': 'Mountain View', 'rating': 4.6, 'reviewCount': 78, 
      'price': 350000, 'type': 'Chalet', 'beds': 2, 'features': ['Pool', 'Budget'], 'imageUrl': 'https://images.unsplash.com/photo-1510798831971-661eb04b3739?w=800',
      'partyAllowed': true, 'petsAllowed': false, 'mixedGroupsOK': true,
    },
  ];

  List<Map<String, dynamic>> _filterList(List<Map<String, dynamic>> list) {
    var filtered = list;

    // 1. Apply Search Query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((p) =>
          p['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p['location'].toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }

    // 2. Apply Bottom Sheet Filters
    final String type = _appliedFilters['propertyType'];
    if (type != 'All') {
      filtered = filtered.where((p) => p['type'] == type).toList();
    }

    final double minPrice = _appliedFilters['minPrice'];
    final double maxPrice = _appliedFilters['maxPrice'];
    filtered = filtered.where((p) {
      double priceEgp = (p['price'] as num) / 100;
      return priceEgp >= minPrice && priceEgp <= maxPrice;
    }).toList();

    final String beds = _appliedFilters['bedrooms'];
    if (beds != 'Any') {
      int count = int.parse(beds.replaceAll('+', ''));
      filtered = filtered.where((p) => (p['beds'] as int) >= count).toList();
    }

    final List<String> amenities = List<String>.from(_appliedFilters['amenities']);
    if (amenities.isNotEmpty) {
      filtered = filtered.where((p) {
        List features = p['features'] as List;
        return amenities.every((a) => features.contains(a));
      }).toList();
    }

    if (_appliedFilters['partyAllowed'] == true) {
      filtered = filtered.where((p) => p['partyAllowed'] == true).toList();
    }
    if (_appliedFilters['petsAllowed'] == true) {
      filtered = filtered.where((p) => p['petsAllowed'] == true).toList();
    }
    if (_appliedFilters['mixedGroupsOK'] == true) {
      filtered = filtered.where((p) => p['mixedGroupsOK'] == true).toList();
    }

    return filtered;
  }

  void _navigateToDetail(Map<String, dynamic> p) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PropertyDetailScreen(
          propertyId: p['id'],
          propertyName: p['name'],
          propertyImage: p['imageUrl'],
          location: p['location'],
          rating: (p['rating'] as num).toDouble(),
          reviewCount: p['reviewCount'] ?? 0,
          pricePerNight: (p['price'] as num).toInt() ~/ 100,
        ),
      ),
    );
  }

  void _showFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => SearchFiltersSheet(
          initialFilters: _appliedFilters,
          allProperties: _masterProperties,
          onApplyFilters: (filters) {
            setState(() {
              _appliedFilters = filters;
            });
          },
        ),
      ),
    );
  }

  void _clearAllFilters() {
    setState(() {
      _searchController.clear();
      _searchQuery = '';
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
      _selectedFilter = 'All';
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialFilters != null) {
      _appliedFilters = Map<String, dynamic>.from(widget.initialFilters!);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Dynamically derive sections from Master Data
    final allFiltered = _filterList(_masterProperties);
    
    final trending = allFiltered.where((p) => (p['rating'] as num) >= 4.8).toList();
    final bestOffers = allFiltered.where((p) => (p['features'] as List).contains('Budget')).toList();
    final newlyAdded = allFiltered.where((p) => (p['id'] as String).compareTo('10') > 0).toList();

    final bool isEmpty = allFiltered.isEmpty;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            HomeHeader(
              searchController: _searchController,
              onSearchChanged: (val) => setState(() => _searchQuery = val),
              onFilterTap: _showFilters,
              onChatTap: () {},
            ),
            const SizedBox(height: 16),
            FilterChips(
              filters: _filters,
              selectedFilter: _selectedFilter,
              onFilterSelected: (f) => setState(() => _selectedFilter = f),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
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
                          text: '${trending.length + bestOffers.length + newlyAdded.length}',
                          style: const TextStyle(
                            color: AppColors.navy,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const TextSpan(text: ' stays found in North Coast'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: isEmpty
                  ? SearchEmptyState(
                      searchQuery: _searchQuery,
                      onClearFilters: _clearAllFilters,
                      onBack: () => Navigator.pop(context),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Trending Now Section
                          if (_selectedFilter == 'All' || _selectedFilter == 'Trending Now')
                            _buildSection(
                              title: 'TRENDING NOW',
                              icon: Icons.local_fire_department,
                              iconColor: const Color(0xFFFF6B35),
                              properties: trending,
                              badgeType: PropertyBadge.trending,
                            ),

                          // Best Offers Section
                          if (_selectedFilter == 'All' || _selectedFilter == 'Best Offers')
                            _buildSection(
                              title: 'BEST OFFERS',
                              icon: Icons.thumb_up,
                              iconColor: AppColors.gold,
                              properties: bestOffers,
                              badgeType: PropertyBadge.discount,
                            ),

                          // Newly Added Section
                          if (_selectedFilter == 'All' || _selectedFilter == 'Newly Added')
                            _buildSection(
                              title: 'NEWLY ADDED',
                              icon: Icons.auto_awesome,
                              iconColor: AppColors.gold,
                              properties: newlyAdded,
                              badgeType: PropertyBadge.newlyAdded,
                            ),

                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<Map<String, dynamic>> properties,
    required PropertyBadge badgeType,
  }) {
    if (properties.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        PropertySection(
          title: title,
          icon: icon,
          iconColor: iconColor,
          properties: properties,
          badgeType: badgeType,
          onPropertyTap: _navigateToDetail,
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
