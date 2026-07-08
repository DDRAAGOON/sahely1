import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import '../../bookings/pages/booking_dates_guests_screen.dart';
import '../widgets/property_image_gallery.dart';
import '../widgets/property_info_section.dart';
import '../widgets/feature_chips_section.dart';
import '../widgets/amenities_section.dart';
import '../widgets/house_rules_section.dart';
import '../widgets/reviews_section.dart';
import '../widgets/sticky_bottom_bar.dart';
import '../widgets/map_teaser.dart';
import '../widgets/description_section.dart';
import '../widgets/smart_lock_badge.dart';

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
  bool _isWishlisted = false;

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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingDatesGuestsScreen(
                      propertyName: widget.propertyName,
                      propertyImage: 'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=800',
                      pricePerNight: widget.pricePerNight * 100, // Convert to piastres
                      cleaningFee: 25000, // 250 EGP in piastres
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
