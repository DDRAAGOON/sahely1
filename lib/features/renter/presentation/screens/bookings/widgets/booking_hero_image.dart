import 'package:flutter/material.dart';

import '../../../../../../core/theme/app_colors.dart';
import '../pages/gallery/photo_viewer_screen.dart';

class BookingHeroImage extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onBackTap;
  final List<String>? allPhotos;

  const BookingHeroImage({
    super.key,
    required this.imageUrl,
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
        // Hero Image
        GestureDetector(
          onTap: () => _openGallery(context),
          child: AspectRatio(
            aspectRatio: 4 / 3,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(color: AppColors.border);
              },
            ),
          ),
        ),

        // Top Gradient
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 100,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.4),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // Back Button
        Positioned(
          top: 48,
          left: 16,
          child: GestureDetector(
            onTap: onBackTap,
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.chevron_left,
                color: AppColors.navy,
                size: 20,
              ),
            ),
          ),
        ),

        // Upcoming Badge
        Positioned(
          top: 48,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.navy,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Upcoming',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontFamily: 'DM Sans',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
