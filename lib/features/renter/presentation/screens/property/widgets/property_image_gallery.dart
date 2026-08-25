import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';

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

  final List<String> _images = [
    'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=800',
    'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=800',
    'https://images.unsplash.com/photo-1580587771525-78b9dba3b914?w=800',
  ];

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
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      if (!mounted) return;
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
            PageView.builder(
              controller: _pageController,
              itemCount: _images.length,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _openGallery(index),
                  child: AppNetworkImage(url: _images[index], width: double.infinity),
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
                children: List.generate(_images.length, (index) {
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

