import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';

import '../../../../../../core/widgets/bouncy_button.dart';

import 'package:sahely/features/renter/presentation/screens/wishlist/presentation/widgets/heart_button.dart';

class SearchResultCard extends StatefulWidget {
  final Property property;
  final VoidCallback onTap;

  const SearchResultCard({
    super.key,
    required this.property,
    required this.onTap,
  });

  @override
  State<SearchResultCard> createState() => _SearchResultCardState();
}

class _SearchResultCardState extends State<SearchResultCard> {
  @override
  Widget build(BuildContext context) {
    final p = widget.property;
    return BouncyButton(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppColors.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Stack(
                children: [
                  SizedBox(
                    height: 180,
                    width: double.infinity,
                    child: Image.network(p.image, fit: BoxFit.cover),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.navy.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        p.type,
                        style: AppTheme.dm(size: 10, weight: FontWeight.w700, color: Colors.white),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: HeartButton(
                      propertyId: p.name,
                      propertyName: p.name,
                      propertyImage: p.image,
                      size: 34,
                    ),
                  ),
                ],
              ),
            ),
            // Info Section
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(p.name, style: AppTheme.dm(size: 16, weight: FontWeight.w700, color: AppColors.navy)),
                      Text('EGP ${p.price}', style: AppTheme.dm(size: 16, weight: FontWeight.w800, color: AppColors.gold)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 14, color: AppColors.muted),
                      const SizedBox(width: 4),
                      Text(p.area, style: AppTheme.dm(size: 13, color: AppColors.muted)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: AppColors.gold),
                      const SizedBox(width: 4),
                      Text('${p.rating} (${p.reviews} reviews)', style: AppTheme.dm(size: 12, weight: FontWeight.w600)),
                    ],
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
