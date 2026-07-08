import 'package:flutter/material.dart';
import 'package:sahely/data/models.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'common.dart';
import 'image.dart';

class HeroPropertyCard extends StatelessWidget {
  const HeroPropertyCard({
    super.key,
    required this.property,
    required this.badge,
    required this.badgeColor,
    this.grayscale = false,
    this.nameOverride,
  });

  final Property property;
  final String badge;
  final Color badgeColor;
  final bool grayscale;
  final String? nameOverride;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/property', arguments: property),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [BoxShadow(color: Color(0x1F000000), blurRadius: 10, offset: Offset(0, 4))],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            SizedBox(
              height: 180,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  grayscale
                      ? ColorFiltered(
                          colorFilter: const ColorFilter.matrix(<double>[
                            0.2126, 0.7152, 0.0722, 0, 0,
                            0.2126, 0.7152, 0.0722, 0, 0,
                            0.2126, 0.7152, 0.0722, 0, 0,
                            0,      0,      0,      1, 0,
                          ]),
                          child: SahelyImage(
                            imageUrl: property.image,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                            showFade: true,
                            fadeHeight: 60,
                            fadeColor: AppColors.white,
                            enableViewer: false,
                          ),
                        )
                      : SahelyImage(
                          imageUrl: property.image,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                          showFade: true,
                          fadeHeight: 60,
                          fadeColor: AppColors.white,
                          enableViewer: false,
                        ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(color: badgeColor, borderRadius: BorderRadius.circular(8)),
                      child: Text(badge, style: AppTheme.dm(size: 10, weight: FontWeight.w800, color: Colors.white)),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: const Icon(Icons.favorite_border, size: 18, color: AppColors.navy),
                    ),
                  ),
                ],
              ),
            ),
            // Info Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          nameOverride ?? property.name,
                          style: AppTheme.dm(size: 17, weight: FontWeight.w700, color: AppColors.navy),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(text: 'EGP ${property.price.toString().replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (Match m) => "${m[1]},")}', style: AppTheme.dm(size: 16, weight: FontWeight.w700, color: AppColors.navy)),
                            const TextSpan(text: ' /night', style: TextStyle(fontSize: 11, color: Color(0xFF5B5B5B))),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 14, color: Color(0xFF5B5B5B)),
                      const SizedBox(width: 4),
                      Text(property.area, style: AppTheme.dm(size: 13, color: const Color(0xFF5B5B5B))),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: AppColors.gold),
                      const SizedBox(width: 4),
                      Text('${property.rating}', style: AppTheme.dm(size: 13, weight: FontWeight.w700, color: AppColors.navy)),
                      Text('  ·  ${property.beds} beds · ${property.type} · Sea view', style: AppTheme.dm(size: 13, color: const Color(0xFF5B5B5B))),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Pill('Beachfront', bg: AppColors.white, fg: AppColors.navy, radius: 10, border: AppColors.border),
                      Pill('Pool', bg: AppColors.white, fg: AppColors.navy, radius: 10, border: AppColors.border),
                      Pill('WiFi', bg: AppColors.white, fg: AppColors.navy, radius: 10, border: AppColors.border),
                      Pill('AC', bg: AppColors.white, fg: AppColors.navy, radius: 10, border: AppColors.border),
                      Pill('Sea View', bg: AppColors.white, fg: AppColors.navy, radius: 10, border: AppColors.border),
                      Pill('🐾 Pets OK', bg: Color(0xFFD7EEDD), fg: AppColors.success, radius: 10),
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
