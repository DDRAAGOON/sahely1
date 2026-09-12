import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/utils/currency_formatter.dart';

class PriceTag extends StatelessWidget {
  const PriceTag(
      {super.key, required this.price, this.size = 17, this.perNight = true});

  final int price;
  final double size;
  final bool perNight;

  @override
  Widget build(BuildContext context) {
    final formatted = CurrencyFormatter.format(price);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(formatted,
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
