import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/bouncy_button.dart';

class UpcomingCheckinCard extends StatelessWidget {
  final Map<String, dynamic> checkin;
  final VoidCallback onTap;

  const UpcomingCheckinCard({
    super.key,
    required this.checkin,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BouncyButton(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            // Property Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                checkin['imageUrl']?.toString() ?? '',
                width: 64,
                height: 64,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 64,
                    height: 64,
                    color: AppColors.border,
                    child: const Icon(
                      Icons.image,
                      color: AppColors.secondary,
                      size: 24,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            // Property Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    checkin['name']?.toString() ?? '',
                    style: AppTheme.dm(
                      size: 15,
                      weight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${checkin['client'] ?? ''} · ${checkin['date'] ?? ''} · ${checkin['nights'] ?? ''} nights',
                    style: AppTheme.dm(
                      size: 12,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ),
            // Margin
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  checkin['margin']?.toString() ?? checkin['profit']?.toString() ?? '',
                  style: AppTheme.dm(
                    size: 15,
                    weight: FontWeight.w700,
                    color: AppColors.green,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'your margin',
                  style: AppTheme.dm(
                    size: 10,
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}