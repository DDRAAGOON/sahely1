import 'package:flutter/material.dart';
import 'package:sahely/core/navigation/app_navigation.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/features/renter/presentation/screens/property/widgets/description_section.dart';
import 'package:sahely/features/renter/presentation/screens/property/widgets/feature_chips_section.dart';
import 'package:sahely/features/renter/presentation/screens/property/widgets/house_rules_section.dart';
import 'package:sahely/features/renter/presentation/screens/property/widgets/map_teaser.dart';
import 'package:sahely/features/renter/presentation/screens/property/widgets/property_image_gallery.dart';
import 'package:sahely/features/renter/presentation/screens/property/widgets/property_info_section.dart';
import 'package:sahely/features/renter/presentation/screens/property/widgets/reviews_section.dart';
import 'package:sahely/features/renter/presentation/screens/property/widgets/smart_lock_badge.dart';
import 'package:sahely/features/renter/presentation/screens/property/widgets/sticky_bottom_bar.dart';
import 'package:sahely/core/widgets/entrance_faded.dart';
import 'package:sahely/core/theme/system_ui.dart';
import 'package:sahely/core/di/service_locator.dart' show sl;
import 'package:sahely/features/renter/domain/repositories/renter_repository.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';

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

  /// The listing itself (`GET /properties/:id`). Null until it arrives; the
  /// sections that describe it stay hidden until then rather than showing
  /// stand-in text.
  Property? _property;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final property =
          await sl<RenterRepository>().getProperty(widget.propertyId);
      if (mounted) setState(() => _property = property);
    } catch (_) {
      // The header keeps what the card that opened this screen passed in.
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LightStatusBar(
      child: Scaffold(
        backgroundColor: AppColors.cream,
        body: EntranceFaded(
          child: Stack(
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
                    unit: _property?.unit ?? '',
                    floor: _property?.floor,
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 16)),

                  // 3. Feature Chips
                  FeatureChipsSection(property: _property),

                  const SliverToBoxAdapter(child: SizedBox(height: 16)),

                  // 4. Description
                  DescriptionSection(text: _property?.description ?? ''),

                  const SliverToBoxAdapter(child: SizedBox(height: 16)),

                  // 5. Smart Lock Badge
                  SmartLockBadge(enabled: _property?.smartLock ?? false),

                  const SliverToBoxAdapter(child: SizedBox(height: 16)),

                  // 6. House Rules
                  HouseRulesSection(property: _property),

                  const SliverToBoxAdapter(child: SizedBox(height: 24)),

                  // 7. Map Teaser
                  MapTeaser(
                    latitude: _property?.latitude,
                    longitude: _property?.longitude,
                    label: widget.location,
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 24)),

                  // 8. Reviews
                  ReviewsSection(
                    propertyId: widget.propertyId,
                    propertyName: widget.propertyName,
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
                      'name': widget.propertyName,
                      'imageUrl': widget.propertyImage,
                      'price': widget.pricePerNight,
                      'location': widget.location,
                      'rating': widget.rating,
                      'reviews': widget.reviewCount,
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
