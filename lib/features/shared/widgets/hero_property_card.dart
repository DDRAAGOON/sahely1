import 'package:flutter/material.dart';
import 'package:sahely/core/navigation/app_navigation.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/property_card_base.dart' as base;
import 'package:sahely/core/widgets/wishlist.dart';

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
    final p = property;
    return base.PropertyCardBase(
      property: p,
      imageHeight: 180,
      onTap: () => AppNavigation.goToPropertyDetail(context, extra: p),
      showGuestFav: false,
      imageOverlay: Stack(
        children: [
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                  color: badgeColor, borderRadius: BorderRadius.circular(8)),
              child: Text(badge,
                  style: AppTheme.dm(
                      size: 10, weight: FontWeight.w800, color: Colors.white)),
            ),
          ),
          Positioned(
            top: 12,
            right: 12,
            child: SaveHeart(property: p),
          ),
        ],
      ),
    );
  }
}
