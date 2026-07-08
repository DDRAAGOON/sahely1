import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';

class PremiumServicesList extends StatelessWidget {
  final int userLevel;
  final List<Map<String, dynamic>> services; // استقبال القائمة من الخارج للفلترة
  final Function(String, int) onRequest;

  const PremiumServicesList({
    super.key,
    required this.userLevel,
    required this.services,
    required this.onRequest,
  });

  @override
  Widget build(BuildContext context) {
    if (services.isEmpty) return const SizedBox.shrink();

    final bool showMawsemBadge = userLevel >= 3;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Premium & Concierge',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
            fontFamily: 'DM Sans',
          ),
        ),
        const SizedBox(height: 16),

        ...services.map((service) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _PremiumServiceCard(
              name: service['name'],
              price: service['price'],
              imageUrl: service['imageUrl'],
              showDiscountBadge: showMawsemBadge,
              onRequest: () => onRequest(service['name'], service['price']),
            ),
          );
        }).toList(),
      ],
    );
  }
}

class _PremiumServiceCard extends StatelessWidget {
  final String name;
  final int price;
  final String imageUrl;
  final bool showDiscountBadge;
  final VoidCallback onRequest;

  const _PremiumServiceCard({
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.showDiscountBadge,
    required this.onRequest,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 2.1 / 1,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.border,
                        child: const Icon(Icons.image, color: AppColors.placeholder, size: 48),
                      );
                    },
                  ),
                ),
                if (showDiscountBadge)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.gold,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '15% off',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.navy, fontFamily: 'DM Sans'),
                          ),
                          SizedBox(width: 4),
                          Icon(Icons.star, size: 12, color: AppColors.navy),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.navy, fontFamily: 'DM Sans')),
                      const SizedBox(height: 4),
                      Text('From EGP ${price.toStringAsFixed(0)}', style: const TextStyle(fontSize: 13, color: AppColors.secondary, fontFamily: 'DM Sans')),
                    ],
                  ),
                ),
                SizedBox(
                  height: 36,
                  child: ElevatedButton(
                    onPressed: onRequest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.navy,
                      foregroundColor: AppColors.white,
                      minimumSize: const Size(90, 36),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    child: const Text('Request', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, fontFamily: 'DM Sans')),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
