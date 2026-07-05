import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import '../pages/gallery/photo_viewer_screen.dart';

class PropertyPhotoGallery extends StatelessWidget {
  final List<dynamic>? photos;

  const PropertyPhotoGallery({
    super.key,
    required this.photos,
  });

  void _openGallery(BuildContext context, int index) {
    if (photos == null || photos!.isEmpty) return;
    final photoList = photos!.map((e) => e.toString()).toList();
    Navigator.push(
      context,
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
              child: Image.network(
                photoList[0].toString(),
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
                onTap: () => _openGallery(context, photoList.length > 1 ? 1 : 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    photoList.length > 1 ? photoList[1].toString() : '',
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
                onTap: () => _openGallery(context, photoList.length > 2 ? 2 : 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    children: [
                      Image.network(
                        photoList.length > 2 ? photoList[2].toString() : '',
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
                      if (photoList.length > 3)
                        Container(
                          height: 56,
                          width: double.infinity,
                          color: Colors.black.withOpacity(0.4),
                          child: Center(
                            child: Text(
                              '+${photoList.length - 2}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontFamily: 'DM Sans',
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
