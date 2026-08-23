import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/features/broker/domain/entities/broker_booking.dart';

class BrokerPastStaysSection extends StatelessWidget {
  final List<BrokerBooking> pastBookings;
  final Function(BrokerBooking)? onCardTap;

  const BrokerPastStaysSection({
    super.key,
    required this.pastBookings,
    this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    if (pastBookings.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'PAST STAYS',
            style: AppTheme.dm(
              size: 11,
              weight: FontWeight.w700,
              color: const Color(0xFF717171),
              letterSpacing: 0.8,
            ),
          ),
        ),
        const SizedBox(height: 12),
        ...pastBookings.map((booking) => _buildPastCard(context, booking)),
      ],
    );
  }

  Widget _buildPastCard(BuildContext context, BrokerBooking booking) {
    return GestureDetector(
      onTap: () => onCardTap?.call(booking),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
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
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                booking.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        booking.propertyName,
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
                          color: const Color(0xFF9A9A9A).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Past',
                          style: AppTheme.dm(
                            color: const Color(0xFF717171),
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
                        booking.area,
                        style: AppTheme.dm(
                          color: const Color(0xFF9A9A9A),
                          size: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    booking.dates,
                    style: AppTheme.dm(
                      color: const Color(0xFF717171),
                      size: 11,
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
