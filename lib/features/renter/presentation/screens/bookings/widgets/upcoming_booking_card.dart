import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/image.dart';

class UpcomingBookingCard extends StatelessWidget {
  final String propertyName;
  final String location;
  final String dates;
  final String orderNumber;
  final String imageUrl;
  final VoidCallback onTap;

  const UpcomingBookingCard({
    super.key,
    required this.propertyName,
    required this.location,
    required this.dates,
    required this.orderNumber,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AppNetworkImage(url: imageUrl, width: 80, height: 80),
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        propertyName,
                        style: AppTheme.dm(
                          size: 15,
                          weight: FontWeight.w700,
                          color: const Color(0xFF1B2744),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1B2744),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Upcoming',
                          style: AppTheme.dm(
                            color: Colors.white,
                            size: 10,
                            weight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          color: Color(0xFF9A9A9A), size: 12),
                      const SizedBox(width: 4),
                      Text(
                        location,
                        style: AppTheme.dm(
                          color: const Color(0xFF9A9A9A),
                          size: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dates,
                    style: AppTheme.dm(
                      color: const Color(0xFF717171),
                      size: 11,
                    ),
                  ),
                  const SizedBox(height: 4),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Order no. ',
                          style: AppTheme.dm(
                              color: const Color(0xFF717171), size: 11),
                        ),
                        TextSpan(
                          text: orderNumber,
                          style: AppTheme.dm(
                            color: const Color(0xFF1B2744),
                            size: 11,
                            weight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
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
