import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sahely/core/di/service_locator.dart' show sl;
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/features/renter/domain/repositories/renter_repository.dart';

import 'package:sahely/features/renter/presentation/screens/bookings/pages/gallery/photo_viewer_screen.dart';
import 'package:sahely/features/renter/presentation/screens/wishlist/presentation/widgets/heart_button.dart';
import 'package:sahely/core/widgets/image.dart';

class PropertyImageGallery extends StatefulWidget {
  final String propertyId;
  final String propertyName;
  final String propertyImage;

  const PropertyImageGallery({
    super.key,
    required this.propertyId,
    required this.propertyName,
    required this.propertyImage,
  });

  @override
  State<PropertyImageGallery> createState() => _PropertyImageGalleryState();
}

class _PropertyImageGalleryState extends State<PropertyImageGallery> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _autoSlideTimer;

  /// The listing's own photos. Starts with the cover the previous screen
  /// already showed, so the page never flashes empty, then becomes the full
  /// set from `GET /properties/:id`.
  List<String> _images = const [];

  /// Fetches the photos the owner uploaded for this listing.
  Future<void> _loadImages() async {
    try {
      final property = await sl<RenterRepository>().getProperty(
        widget.propertyId,
      );
      if (!mounted || property.images.isEmpty) return;
      setState(() {
        _images = property.images;
        if (_currentPage >= _images.length) _currentPage = 0;
      });
    } catch (_) {
      // Keep the cover photo we already have.
    }
  }

  void _openGallery(int index) {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => PhotoViewerScreen(
          photos: _images,
          initialIndex: index,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _images = widget.propertyImage.isEmpty ? const [] : [widget.propertyImage];
    _loadImages();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      if (!mounted || _images.length < 2) return;
      final next = (_currentPage + 1) % _images.length;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 380,
        child: Stack(
          children: [
            // Swipeable PageView
            if (_images.isEmpty)
              Container(color: AppColors.cardWarm)
            else
              PageView.builder(
                controller: _pageController,
                itemCount: _images.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _openGallery(index),
                    child: AppNetworkImage(
                        url: _images[index], width: double.infinity),
                  );
                },
              ),

            // Bottom Fade Gradient
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 100,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.cream.withValues(alpha: 0.9),
                    ],
                  ),
                ),
              ),
            ),

            // Back Button
            Positioned(
              top: 44,
              left: 16,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.chevron_left,
                    color: AppColors.navy,
                    size: 22,
                  ),
                ),
              ),
            ),

            // Wishlist Button
            Positioned(
              top: 44,
              right: 16,
              child: HeartButton(
                propertyId: widget.propertyId,
                propertyName: widget.propertyName,
                propertyImage: widget.propertyImage,
                size: 38,
              ),
            ),

            // Dot Indicators
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_images.length < 2 ? 0 : _images.length,
                    (index) {
                  final isActive = index == _currentPage;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: isActive ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.gold
                          : Colors.white.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
