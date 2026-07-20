import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/theme/app_colors.dart';

class WishlistCollectionCard extends StatelessWidget {
  final String name;
  final int count;
  final String? coverImage;
  final bool isShared;
  final int? sharedWith;

  const WishlistCollectionCard({
    super.key,
    required this.name,
    required this.count,
    this.coverImage,
    this.isShared = false,
    this.sharedWith,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Cover Image
            if (coverImage != null)
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: coverImage!,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: AppColors.border,
                    child: const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppColors.gold),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: AppColors.border,
                    child: const Icon(
                      Icons.broken_image,
                      color: AppColors.secondary,
                      size: 32,
                    ),
                  ),
                ),
              )
            else
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.navy, Color(0xFF323D57)],
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.folder_open,
                    color: AppColors.gold.withValues(alpha: 0.5),
                    size: 48,
                  ),
                ),
              ),

            // Bottom Gradient Scrim
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 80,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.navy.withValues(alpha: 0.85),
                    ],
                  ),
                ),
              ),
            ),

            // Shared Badge (top-right)
            if (isShared)
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.navy.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.people,
                        color: AppColors.gold,
                        size: 12,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Shared',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                          fontFamily: 'DM Sans',
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Name & Count (bottom-left)
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                      fontFamily: 'DM Sans',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$count places',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.white70,
                      fontFamily: 'DM Sans',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
