import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';

class PortfolioPropertyCard extends StatelessWidget {
  final Map<String, dynamic> property;
  final VoidCallback onTap;

  const PortfolioPropertyCard({
    super.key,
    required this.property,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final status = property['status']?.toString() ?? '';
    final isLive = status == 'Live';
    final isPending = status == 'Pending';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            // Property Image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                property['imageUrl']?.toString() ?? '',
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 80,
                    height: 80,
                    color: AppColors.border,
                    child: const Icon(
                      Icons.image,
                      color: AppColors.secondary,
                      size: 32,
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
                  // Name & Status
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          property['name']?.toString() ?? '',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.navy,
                            fontFamily: 'DM Sans',
                          ),
                        ),
                      ),
                      // Status Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isLive
                              ? AppColors.green
                              : isPending
                              ? AppColors.gold
                              : AppColors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          status,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontFamily: 'DM Sans',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Owner
                  Text(
                    'Owner: ${property['owner']}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.secondary,
                      fontFamily: 'DM Sans',
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Bookings & Commission
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Bookings',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.secondary,
                              fontFamily: 'DM Sans',
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${property['bookings']}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.navy,
                              fontFamily: 'DM Sans',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Your commission',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.secondary,
                              fontFamily: 'DM Sans',
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            property['commission'] != null
                                ? 'EGP ${property['commission']}'
                                : '—',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: property['commission'] != null
                                  ? AppColors.green
                                  : AppColors.secondary,
                              fontFamily: 'DM Sans',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}