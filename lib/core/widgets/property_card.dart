import 'package:flutter/material.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';

import 'package:sahely/core/widgets/common.dart';
import 'package:sahely/core/widgets/property_card_base.dart' as base;

/// Large hero property card (Trending Now / Browse results).
class PropertyCard extends StatelessWidget {
  const PropertyCard(
      {super.key,
      required this.property,
      this.onTap,
      this.imageHeight = 150,
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
      onTap: onTap,
      imageOverlay:
          Positioned(top: 12, right: 12, child: SaveHeart(property: p)),
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
      onTap: onTap,
      imageOverlay:
          Positioned(top: 10, right: 10, child: SaveHeart(property: p)),
    );
  }
}
