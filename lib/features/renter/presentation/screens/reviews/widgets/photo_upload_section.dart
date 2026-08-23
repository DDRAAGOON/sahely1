import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';

class PhotoUploadSection extends StatelessWidget {
  final List<String> uploadedPhotos;
  final ValueChanged<String> onPhotoAdded;
  final ValueChanged<int> onPhotoRemoved;

  const PhotoUploadSection({
    super.key,
    required this.uploadedPhotos,
    required this.onPhotoAdded,
    required this.onPhotoRemoved,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with bonus note
        RichText(
          text: TextSpan(
            style: AppTheme.dm(
              size: 14,
              weight: FontWeight.w600,
            ),
            children: [
              TextSpan(
                text: 'Add photos',
                style: AppTheme.dm(color: AppColors.navy, size: 14, weight: FontWeight.w600),
              ),
              TextSpan(
                text: ' · +5 ★ for photo reviews',
                style: AppTheme.dm(color: AppColors.gold, size: 14, weight: FontWeight.w600),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Photo Grid
        SizedBox(
          height: 88,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              // Uploaded Photos
              ...uploadedPhotos.asMap().entries.map((entry) {
                final index = entry.key;
                final photoUrl = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          photoUrl,
                          width: 88,
                          height: 88,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 88,
                              height: 88,
                              color: AppColors.border,
                              child: const Icon(
                                Icons.image,
                                color: AppColors.secondary,
                                size: 32,
                              ),
                            );
                          },
                        ),
                      ),
                      // Remove button
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => onPhotoRemoved(index),
                          child: Container(
                            width: 22,
                            height: 22,
                            decoration: const BoxDecoration(
                              color: AppColors.red,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),

              // Add Photo Tile
              GestureDetector(
                onTap: () {
                  // TODO: Open image picker
                  // Pick image and add to uploadedPhotos
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Add photo')),
                  );
                },
                child: Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.gold,
                      width: 1.5,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.add,
                        color: AppColors.gold,
                        size: 24,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Photo',
                        style: AppTheme.dm(
                          size: 10,
                          weight: FontWeight.w600,
                          color: AppColors.gold,
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
