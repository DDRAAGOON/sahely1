import 'package:flutter/material.dart';
import 'package:sahely/core/navigation/app_navigation.dart';
import 'package:sahely/core/widgets/property_card_base.dart' as base;
import 'package:sahely/features/shared/properties/domain/entities/property.dart';

/// Small compact property card for horizontal lists (Browse screen top rated).
/// Uses [PropertyCardBase] under the hood for consistent look across roles.
class SmallPropCard extends StatelessWidget {
  const SmallPropCard({
    super.key,
    required this.image,
    required this.name,
    required this.price,
    required this.rating,
    this.onTap,
  });

  final String image, name, price, rating;
  final VoidCallback? onTap;

  /// Constructs a [SmallPropCard] from a [Property] object directly.
  factory SmallPropCard.fromProperty(Property p, {VoidCallback? onTap}) {
    return SmallPropCard(
      image: p.image,
      name: p.name,
      price: '${p.price}',
      rating: p.rating.toStringAsFixed(1),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Convert price string like '3,200' to int: remove commas, parse
    final priceNum = int.tryParse(price.replaceAll(',', '')) ?? 0;
    final ratingNum = double.tryParse(rating) ?? 0.0;

    final prop = Property(
      name: name,
      area: 'North Coast',
      image: image,
      price: priceNum,
      rating: ratingNum,
      reviews: 120,
      type: 'Chalet',
    );

    return SizedBox(
      width: 160,
      child: base.PropertyCardBase(
        property: prop,
        imageHeight: 110,
        showGuestFav: false,
        onTap: onTap ?? () => AppNavigation.goToPropertyDetail(context, extra: prop),
      ),
    );
  }
}
