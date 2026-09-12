import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/image.dart';
import 'package:sahely/l10n/app_localizations.dart';

class ReviewPropertyCard extends StatelessWidget {
  final String propertyName;
  final String propertyImage;
  final String stayDates;

  const ReviewPropertyCard({
    super.key,
    required this.propertyName,
    required this.propertyImage,
    required this.stayDates,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // Property Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: AppNetworkImage(
                url: propertyImage,
                width: 72,
                height: 72,
                errorWidget: (context, error, stackTrace) {
                  return Container(
                    width: 72,
                    height: 72,
                    color: AppColors.border,
                    child: const Icon(
                      Icons.image,
                      color: AppColors.secondary,
                      size: 32,
                    ),
                  );
                }),
          ),
          const SizedBox(width: 12),
          // Property Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  propertyName,
                  style: AppTheme.dm(
                    size: 15,
                    weight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${AppLocalizations.of(context).stayed} $stayDates',
                  style: AppTheme.dm(
                    size: 12,
                    color: AppColors.secondary,
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
