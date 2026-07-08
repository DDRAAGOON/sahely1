import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';

class RatingRow extends StatelessWidget {
  const RatingRow({super.key, required this.rating, this.reviews, this.suffix, this.size = 13});
  final double rating;
  final int? reviews;
  final String? suffix;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.star, size: size, color: AppColors.gold),
        const SizedBox(width: 5),
        Text(rating.toString(), style: AppTheme.dm(size: size, weight: FontWeight.w700)),
        if (reviews != null || suffix != null)
          Flexible(
            child: Text(
              '${reviews != null ? " ($reviews reviews)" : ""}${suffix != null ? "  ·  $suffix" : ""}',
              style: AppTheme.dm(size: size, color: AppColors.muted),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
    );
  }
}
