import 'package:flutter/material.dart';
import 'package:sahely/core/navigation/app_navigation.dart';
import 'package:sahely/core/theme/app_colors.dart';

import 'package:sahely/features/renter/presentation/screens/property/widgets/amenities_section.dart';
import 'package:sahely/features/renter/presentation/screens/property/widgets/description_section.dart';
import 'package:sahely/features/renter/presentation/screens/property/widgets/feature_chips_section.dart';
import 'package:sahely/features/renter/presentation/screens/property/widgets/house_rules_section.dart';
import 'package:sahely/features/renter/presentation/screens/property/widgets/map_teaser.dart';
import 'package:sahely/features/renter/presentation/screens/property/widgets/property_image_gallery.dart';
import 'package:sahely/features/renter/presentation/screens/property/widgets/property_info_section.dart';
import 'package:sahely/features/renter/presentation/screens/property/widgets/reviews_section.dart';
import 'package:sahely/features/renter/presentation/screens/property/widgets/smart_lock_badge.dart';
import 'package:sahely/features/renter/presentation/screens/property/widgets/sticky_bottom_bar.dart';

class PropertyDetailScreen extends StatefulWidget {
  final String propertyId;
  final String propertyName;
  final String location;
  final String propertyImage;
  final double rating;
  final int reviewCount;
  final int pricePerNight;

  const PropertyDetailScreen({
    super.key,
    required this.propertyId,
    required this.propertyName,
    required this.propertyImage,
    required this.location,
    required this.rating,
    required this.reviewCount,
    required this.pricePerNight,
  });

  @override
  State<PropertyDetailScreen> createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // 1. Image Gallery
              PropertyImageGallery(
                propertyId: widget.propertyId,
                propertyName: widget.propertyName,
                propertyImage: widget.propertyImage,
              ),

              // 2. Property Info
              PropertyInfoSection(
                propertyName: widget.propertyName,
                location: widget.location,
                rating: widget.rating,
                reviewCount: widget.reviewCount,
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 16)),

              // 3. Feature Chips
              const FeatureChipsSection(),

              const SliverToBoxAdapter(child: SizedBox(height: 16)),

              // 4. Description
              const DescriptionSection(),

              const SliverToBoxAdapter(child: SizedBox(height: 16)),

              // 5. Smart Lock Badge
              const SmartLockBadge(),

              const SliverToBoxAdapter(child: SizedBox(height: 16)),

              // 6. Amenities
              const AmenitiesSection(),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // 7. House Rules
              const HouseRulesSection(),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // 8. Map Teaser
              const MapTeaser(),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // 9. Reviews
              ReviewsSection(
                rating: widget.rating,
                reviewCount: widget.reviewCount,
              ),

              // Bottom spacing for sticky bar
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),

          // 10. Sticky Bottom Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: StickyBottomBar(
              pricePerNight: widget.pricePerNight,
              onBookNowTap: () {
                AppNavigation.goToBooking(context, extra: {
                  'propertyName': widget.propertyName,
                  'propertyImage': widget.propertyImage,
                  'pricePerNight': widget.pricePerNight,
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
