import 'package:flutter/material.dart';
import 'package:sahely/core/navigation/app_navigation.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';

import 'package:sahely/core/widgets/common.dart';
import 'package:sahely/core/widgets/property_card_base.dart' as base;

import 'package:sahely/features/renter/presentation/screens/wishlist/presentation/widgets/heart_button.dart';

/// Large hero property card (Trending Now / Browse results).
class PropertyCard extends StatelessWidget {
  const PropertyCard(
      {super.key,
      required this.property,
      this.onTap,
      this.imageHeight = 180,
      this.showGuestFav = false});

  final Property property;
  final VoidCallback? onTap;
  final double imageHeight;
  final bool showGuestFav;

  @override
  Widget build(BuildContext context) {
    final p = property;
    return base.PropertyCardBase(
      property: p,
      imageHeight: imageHeight,
      showGuestFav: showGuestFav,
      onTap: onTap ?? () => AppNavigation.goToPropertyDetail(context, extra: p),
      imageOverlay: Positioned(
        top: 12,
        right: 12,
        child: HeartButton(
          propertyId: p.name,
          propertyName: p.name,
          propertyImage: p.image,
          size: 34,
        ),
      ),
    );
  }
}

/// Compact list card (Lagoon/Golden Dunes rows on the home feed).
class PropertyMiniCard extends StatelessWidget {
  const PropertyMiniCard({super.key, required this.property, this.onTap});

  final Property property;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final p = property;
    return base.PropertyCardBase(
      property: p,
      imageHeight: 140,
      onTap: onTap ?? () => AppNavigation.goToPropertyDetail(context, extra: p),
      imageOverlay: Positioned(
        top: 10,
        right: 10,
        child: HeartButton(
          propertyId: p.name,
          propertyName: p.name,
          propertyImage: p.image,
          size: 30,
        ),
      ),
    );
  }
}
