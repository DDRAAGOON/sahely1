import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/image.dart';

class BookedPropertyHeader extends StatelessWidget {
  final String propertyName;
  final String location;
  final String imageUrl;
  final VoidCallback onBackTap;

  const BookedPropertyHeader({
    super.key,
    required this.propertyName,
    required this.location,
    required this.imageUrl,
    required this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Hero Image
        AspectRatio(
          aspectRatio: 4 / 3,
          child: AppNetworkImage(
            url: imageUrl,
            errorWidget: (context, error, stackTrace) {
              return Container(color: AppColors.border);
            },
          ),
        ),

        // Dark Bottom Gradient
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 140,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.8),
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

        // Checked In Badge
        Positioned(
          top: 48,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF1B6B3A),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 12,
                ),
                const SizedBox(width: 4),
                Text(
                  'Checked In',
                  style: AppTheme.dm(
                    size: 12,
                    weight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Property Name & Location (Restored to White)
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                propertyName,
                style: AppTheme.dm(
                  size: 24,
                  weight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 14,
                    color: Colors.white70,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    location,
                    style: AppTheme.dm(
                      size: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
