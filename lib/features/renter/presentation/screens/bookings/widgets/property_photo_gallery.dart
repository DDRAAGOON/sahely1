import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';

import 'package:sahely/features/renter/presentation/screens/bookings/pages/gallery/photo_viewer_screen.dart';
import 'package:sahely/core/widgets/image.dart';

class PropertyPhotoGallery extends StatelessWidget {
  final List<dynamic>? photos;

  const PropertyPhotoGallery({
    super.key,
    required this.photos,
  });

  void _openGallery(BuildContext context, int index) {
    if (photos == null || photos!.isEmpty) return;
    final photoList = photos!.map((e) => e.toString()).toList();
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => PhotoViewerScreen(
          photos: photoList,
          initialIndex: index,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final photoList = photos ?? [];
    if (photoList.isEmpty) return const SizedBox.shrink();

    return Row(
      children: [
        // Large Photo
        Expanded(
          flex: 2,
          child: GestureDetector(
            onTap: () => _openGallery(context, 0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AppNetworkImage(
                  url: photoList[0].toString(),
                  width: double.infinity,
                  height: 120,
                  errorWidget: (context, error, stackTrace) {
                    return Container(
                      height: 120,
                      color: AppColors.border,
                    );
                  }),
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
                onTap: () =>
                    _openGallery(context, photoList.length > 1 ? 1 : 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AppNetworkImage(
                      url: photoList.length > 1 ? photoList[1].toString() : '',
                      width: double.infinity,
                      height: 56,
                      errorWidget: (context, error, stackTrace) {
                        return Container(
                          height: 56,
                          color: AppColors.border,
                        );
                      }),
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () =>
                    _openGallery(context, photoList.length > 2 ? 2 : 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    children: [
                      AppNetworkImage(
                          url: photoList.length > 2
                              ? photoList[2].toString()
                              : '',
                          width: double.infinity,
                          height: 56,
                          errorWidget: (context, error, stackTrace) {
                            return Container(
                              height: 56,
                              color: AppColors.border,
                            );
                          }),
                      if (photoList.length > 3)
                        Container(
                          height: 56,
                          width: double.infinity,
                          color: Colors.black.withValues(alpha: 0.4),
                          child: Center(
                            child: Text(
                              '+${photoList.length - 2}',
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
