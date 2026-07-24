import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/property_card_base.dart' as base;
import 'package:sahely/features/broker/presentation/screens/wishlist/widgets/broker_heart_button.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';

/// Broker-specific property card with heart/wishlist button and commission info.
class BrokerPropertyCard extends StatelessWidget {
  final Property property;
  final VoidCallback onTap;
  final VoidCallback onWishlistTap;
  final String? commissionLabel;

  const BrokerPropertyCard({
    super.key,
    required this.property,
    required this.onTap,
    required this.onWishlistTap,
    this.commissionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return base.PropertyCardBase(
      property: property,
      imageHeight: 180,
      onTap: onTap,
      showGuestFav: true,
      imageOverlay: Stack(
        children: [
          Positioned(
            top: 12,
            right: 12,
            child: BrokerHeartButton(
              propertyId: property.id,
              propertyName: property.name,
              propertyImage: property.image,
              size: 34,
            ),
          ),
        ],
      ),
      extraInfo: commissionLabel != null
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.gold.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.monetization_on_outlined,
                      size: 14, color: AppColors.gold),
                  const SizedBox(width: 6),
                  Text(
                    commissionLabel!,
                    style: AppTheme.dm(
                      size: 12,
                      weight: FontWeight.w600,
                      color: AppColors.gold,
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
