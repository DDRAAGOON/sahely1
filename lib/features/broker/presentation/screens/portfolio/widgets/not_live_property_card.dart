import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';

class NotLivePropertyCard extends StatelessWidget {
  final Map<String, dynamic> property;
  final VoidCallback onTap;

  const NotLivePropertyCard({
    super.key,
    required this.property,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final status = property['status']?.toString() ?? '';
    final statusDetail = property['statusDetail']?.toString();

    Color getStatusColor() {
      switch (status) {
        case 'Pending':
          return AppColors.gold;
        case 'Issue':
          return AppColors.red;
        case 'Cancelled':
          return AppColors.secondary;
        default:
          return AppColors.navy;
      }
    }

    return GestureDetector(
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
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                property['imageUrl']?.toString() ?? '',
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 56,
                    height: 56,
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
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property['name']?.toString() ?? '',
                    style: AppTheme.dm(
                      size: 14,
                      weight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    property['owner']?.toString() ?? '',
                    style: AppTheme.dm(
                      size: 12,
                      color: AppColors.secondary,
                    ),
                  ),
                  if (statusDetail != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      statusDetail,
                      style: AppTheme.dm(
                        size: 11,
                        color: AppColors.red,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Status Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: getStatusColor(),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                status,
                style: AppTheme.dm(
                  size: 11,
                  weight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}