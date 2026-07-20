import 'package:flutter/material.dart';
import 'package:sahely/core/providers/bookings_provider.dart';
import 'package:sahely/core/theme/app_colors.dart';

class PastStaysSection extends StatelessWidget {
  final List<Booking> pastBookings;
  final Function(Booking)? onCardTap;

  const PastStaysSection({
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
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'PAST STAYS',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Color(0xFF717171),
              letterSpacing: 0.8,
              fontFamily: 'DM Sans',
            ),
          ),
        ),
        const SizedBox(height: 12),
        ...pastBookings.map((booking) => _buildPastCard(context, booking)),
      ],
    );
  }

  Widget _buildPastCard(BuildContext context, Booking booking) {
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
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1B2744),
                          fontFamily: 'DM Sans',
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF9A9A9A).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Past',
                          style: TextStyle(
                            color: Color(0xFF717171),
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'DM Sans',
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
                        booking.location,
                        style: const TextStyle(
                          color: Color(0xFF9A9A9A),
                          fontSize: 11,
                          fontFamily: 'DM Sans',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    booking.dates,
                    style: const TextStyle(
                      color: Color(0xFF717171),
                      fontSize: 11,
                      fontFamily: 'DM Sans',
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
