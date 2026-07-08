import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/ui.dart';

class SmallPropCard extends StatelessWidget {
  const SmallPropCard({
    super.key,
    required this.image,
    required this.name,
    required this.price,
    required this.rating,
  });

  final String image, name, price, rating;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Color(0x0F1B2744), blurRadius: 10, offset: Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SahelyImage(
            imageUrl: image,
            height: 110,
            width: 160,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            fadeHeight: 40,
            enableViewer: false,
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTheme.dm(size: 13, weight: FontWeight.w700, color: AppColors.navy),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text('EGP $price/night', style: AppTheme.dm(size: 11, weight: FontWeight.w600, color: AppColors.gold)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.star, size: 10, color: AppColors.gold),
                    const SizedBox(width: 3),
                    Text(rating, style: AppTheme.dm(size: 10, weight: FontWeight.w700)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
