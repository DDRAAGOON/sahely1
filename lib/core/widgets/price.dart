import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

class PriceTag extends StatelessWidget {
  const PriceTag(
      {super.key, required this.price, this.size = 17, this.perNight = true});

  final int price;
  final double size;
  final bool perNight;

  @override
  Widget build(BuildContext context) {
    final formatted = price
        .toString()
        .replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]},');
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text('EGP $formatted',
            style: AppTheme.dm(
                size: size, weight: FontWeight.w700, color: AppColors.navy)),
        if (perNight) ...[
          const SizedBox(width: 3),
          Text('/night',
              style: AppTheme.dm(size: size * 0.65, color: AppColors.muted)),
        ],
      ],
    );
  }
}
