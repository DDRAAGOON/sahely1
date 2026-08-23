import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';

import 'package:sahely/features/renter/presentation/screens/bookings/pages/gallery/photo_viewer_screen.dart';

class BookingPhotoGallery extends StatelessWidget {
  final List<String> photos;

  const BookingPhotoGallery({
    super.key,
    required this.photos,
  });

  void _openGallery(BuildContext context, int index) {
    if (photos.isEmpty) return;
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => PhotoViewerScreen(
          photos: photos,
          initialIndex: index,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (photos.isEmpty) {
      return Container(
        height: 120,
        decoration: BoxDecoration(
          color: AppColors.border,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(child: Icon(Icons.image_not_supported_outlined)),
      );
    }

    return Row(
      children: [
        // Large Photo
        Expanded(
          flex: 2,
          child: GestureDetector(
            onTap: () => _openGallery(context, 0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                photos[0],
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 120,
                    color: AppColors.border,
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Small Photos Stack
        Expanded(
          flex: 1,
          child: Column(
            children: [
              GestureDetector(
                onTap: () => _openGallery(context, photos.length > 1 ? 1 : 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    photos.length > 1 ? photos[1] : photos[0],
                    height: 56,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 56,
                        color: AppColors.border,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _openGallery(context, photos.length > 2 ? 2 : 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    children: [
                      Image.network(
                        photos.length > 2 ? photos[2] : photos[0],
                        height: 56,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 56,
                            color: AppColors.border,
                          );
                        },
                      ),
                      if (photos.length > 3)
                        Container(
                          height: 56,
                          width: double.infinity,
                          color: Colors.black.withValues(alpha: 0.4),
                          child: Center(
                            child: Text(
                              '+${photos.length - 2}',
                              style: AppTheme.dm(
                                size: 14,
                                weight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
