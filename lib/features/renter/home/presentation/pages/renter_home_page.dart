import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../shared/properties/widgets/property_card.dart';
import '../../../../shared/properties/domain/entities/property.dart';
import '../../../../shared/widgets/inputs/sahely_text_field.dart';

class RenterHomePage extends StatefulWidget {
  const RenterHomePage({super.key});

  @override
  State<RenterHomePage> createState() => _RenterHomePageState();
}

class _RenterHomePageState extends State<RenterHomePage> {
  final List<Property> _properties = [
    const Property(
      id: '1',
      name: 'Lagoon Retreat',
      area: 'Marassi',
      imageUrl: 'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=800',
      pricePerNight: 6200,
      rating: 4.9,
      reviewCount: 86,
    ),
    const Property(
      id: '2',
      name: 'Golden Dunes',
      area: 'Hacienda Bay',
      imageUrl: 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=800',
      pricePerNight: 3800,
      rating: 4.7,
      reviewCount: 53,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: RefreshIndicator(
        onRefresh: () async => await Future.delayed(const Duration(seconds: 1)),
        color: AppColors.gold,
        child: CustomScrollView(
          slivers: [
            _buildHeader(),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 20),
                  const SahelyTextField(
                    hintText: 'Search for chalets...',
                    leading: Icon(Icons.search, color: AppColors.navy),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionHeader('Trending Now'),
                  const SizedBox(height: 16),
                  ..._properties.map((p) => PropertyCard(
                    property: p,
                    onTap: () => Navigator.pushNamed(context, '/property', arguments: p),
                  )),
                  const SizedBox(height: 32),
                  _buildExploreSection(),
                  const SizedBox(height: 120),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.cream,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        title: Text(
          'Find your stay',
          style: AppTheme.dm(size: 20, weight: FontWeight.w700, color: AppColors.navy),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTheme.dm(size: 18, weight: FontWeight.w700, color: AppColors.navy)),
        TextButton(
          onPressed: () {},
          child: Text('See All', style: AppTheme.dm(size: 14, weight: FontWeight.w600, color: AppColors.gold)),
        ),
      ],
    );
  }

  Widget _buildExploreSection() {
    final locations = [
      {'name': 'Marassi', 'image': 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=400'},
      {'name': 'Hacienda Bay', 'image': 'https://images.unsplash.com/photo-1519046904884-53103b34b206?w=400'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Explore North Coast', style: AppTheme.dm(size: 18, weight: FontWeight.w700, color: AppColors.navy)),
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: locations.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return Container(
                width: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: NetworkImage(locations[index]['image']!),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black54, Colors.transparent],
                    ),
                  ),
                  padding: const EdgeInsets.all(12),
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    locations[index]['name']!,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
