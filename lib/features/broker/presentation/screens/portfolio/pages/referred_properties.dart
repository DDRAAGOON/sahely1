import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../widgets/referred_properties_header.dart';
import '../widgets/referred_properties_description.dart';
import '../widgets/referred_properties_filters.dart';
import '../widgets/referred_property_card.dart';

class ReferredPropertiesScreen extends StatefulWidget {
  const ReferredPropertiesScreen({super.key});

  @override
  State<ReferredPropertiesScreen> createState() =>
      _ReferredPropertiesScreenState();
}

class _ReferredPropertiesScreenState extends State<ReferredPropertiesScreen> {
  String _selectedFilter = 'All';
  int _totalCount = 55;
  int _activeCount = 51;
  int _notListedCount = 4;

  // Mock Data
  final List<Map<String, dynamic>> _properties = [
    {
      'name': 'Azure Beach Villa',
      'location': 'Hacienda Bay',
      'rating': 4.8,
      'reviews': 124,
      'pricePerNight': 450000, // in piastres
      'imageUrl': 'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=800',
      'amenities': ['Villa', '6 Guests', 'Pool', 'Pets'],
      'status': 'Accepted - Live',
    },
    {
      'name': 'Lagoon Retreat',
      'location': 'Marassi',
      'rating': 4.9,
      'reviews': 86,
      'pricePerNight': 620000,
      'imageUrl': 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800',
      'amenities': ['Chalet', '8 Guests', 'Sea view'],
      'status': 'Accepted - Live',
    },
    {
      'name': 'Golden Dunes',
      'location': 'Marassi',
      'rating': 4.7,
      'reviews': 53,
      'pricePerNight': 380000,
      'imageUrl': 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=800',
      'amenities': ['Villa', '4 Guests', 'Beach'],
      'status': 'Accepted - Live',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            const ReferredPropertiesHeader(
              title: 'Referred Properties',
              subtitle: '51 accepted & live · guest-ready',
            ),

            // Description
            const ReferredPropertiesDescription(
              text:
              'Only properties accepted by Sahely and live for guests appear here — with the details renters see.',
            ),

            const SizedBox(height: 12),

            // Filter Chips
            ReferredPropertiesFilters(
              totalCount: _totalCount,
              activeCount: _activeCount,
              notListedCount: _notListedCount,
              selectedFilter: _selectedFilter,
              onFilterSelected: (filter) {
                setState(() {
                  _selectedFilter = filter;
                });
              },
            ),

            const SizedBox(height: 16),

            // Property List
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _properties.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final property = _properties[index];
                  return ReferredPropertyCard(
                    property: property,
                    onTap: () {
                      // Navigate to property detail (as renter sees it)
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}