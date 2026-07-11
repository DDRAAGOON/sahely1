import 'package:flutter/material.dart';
import 'package:sahely/features/renter/data/datasources/mock_renter_data_source.dart';
import 'package:sahely/features/renter/data/repositories/renter_repository_impl.dart';
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

  // Data loaded from repository instead of hardcoded
  List<Map<String, dynamic>> _masterProperties = [];
  bool _isLoading = true;


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
    _loadProperties();
  }

  Future<void> _loadProperties() async {
    final repository = RenterRepositoryImpl(
      remoteDataSource: MockRenterDataSource(),
    );
    final properties = await repository.getAllProperties();
    if (mounted) {
      setState(() {
        _masterProperties = properties;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.cream,
        body: Center(child: CircularProgressIndicator(color: AppColors.gold)),
      );
    }

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
