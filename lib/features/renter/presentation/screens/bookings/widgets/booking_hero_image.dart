import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/features/renter/presentation/screens/bookings/pages/gallery/photo_viewer_screen.dart';
import 'package:sahely/core/widgets/image.dart';

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
    Navigator.of(context, rootNavigator: true).push(
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
            child: AppNetworkImage(
              url: imageUrl,
              errorWidget: (context, error, stackTrace) {
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
            child: Text(
              'Upcoming',
              style: AppTheme.dm(
                size: 12,
                weight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
