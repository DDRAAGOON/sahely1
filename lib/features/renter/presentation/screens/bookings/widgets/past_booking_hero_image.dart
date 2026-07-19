import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import '../pages/gallery/photo_viewer_screen.dart';

class PastBookingHeroImage extends StatelessWidget {
  final String imageUrl;
  final String propertyName;
  final String location;
  final VoidCallback onBackTap;
  final List<String>? allPhotos;

  const PastBookingHeroImage({
    super.key,
    required this.imageUrl,
    required this.propertyName,
    required this.location,
    required this.onBackTap,
    this.allPhotos,
  });

  void _openGallery(BuildContext context) {
    final photos = allPhotos ?? [imageUrl];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhotoViewerScreen(
          photos: photos,
          initialIndex: 0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. Hero Image (Grayscale)
        GestureDetector(
          onTap: () => _openGallery(context),
          child: AspectRatio(
            aspectRatio: 1.15, // Height ratio to match Golden Dunes image
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
          ),
        ),

        // 2. Smooth Gradient Overlay (Blends image into cream background)
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 140, // Tall enough to cover text area
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  AppColors.cream.withValues(alpha: 0.4),
                  AppColors.cream.withValues(alpha: 0.8),
                  AppColors.cream,
                ],
                stops: const [0.0, 0.4, 0.7, 1.0],
              ),
            ),
          ),
        ),

        // 3. Property Info (Positioned OVER the image bottom)
        Positioned(
          bottom: 12,
          left: 16,
          right: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                propertyName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800, // Extra bold like in image
                  color: AppColors.navy,
                  fontFamily: 'DM Sans',
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined, 
                    size: 14, 
                    color: Color(0xFF717171),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    location,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF717171),
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // 4. Back Button
        Positioned(
          top: 48,
          left: 16,
          child: GestureDetector(
            onTap: onBackTap,
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.chevron_left, color: AppColors.navy, size: 24),
            ),
          ),
        ),

        // 5. Past Badge
        Positioned(
          top: 48,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF1B2744).withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              'Past',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                fontFamily: 'DM Sans',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
