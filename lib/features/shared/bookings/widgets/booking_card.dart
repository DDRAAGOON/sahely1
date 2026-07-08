import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../widgets/badges.dart';
import '../domain/entities/booking.dart';

class BookingCard extends StatelessWidget {
  final Booking booking;
  final VoidCallback? onTap;
  final Widget? bottomAction;
  final bool showFullDetails;

  const BookingCard({
    super.key,
    required this.booking,
    this.onTap,
    this.bottomAction,
    this.showFullDetails = false,
  });

  @override
  Widget build(BuildContext context) {
    if (showFullDetails) {
      return _buildFullCard(context);
    }
    return _buildSmallRow(context);
  }

  Widget _buildFullCard(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [BoxShadow(color: Color(0x1F000000), blurRadius: 12, offset: Offset(0, 4))],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 160,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(booking.propertyImage, fit: BoxFit.cover),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Color(0x66000000)],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: StatusBadge(
                      booking.status.name.toUpperCase(), 
                      kind: _getBadgeKind(booking.status)
                    ),
                  ),
                  Positioned(
                    left: 16,
                    bottom: 34,
                    child: Text(
                      booking.propertyName,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.white, fontFamily: 'Cairo'),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    bottom: 14,
                    child: Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 12, color: Colors.white70),
                        const SizedBox(width: 4),
                        Text('${booking.location} · North Coast', style: const TextStyle(fontSize: 12, color: Colors.white70, fontFamily: 'Cairo')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _miniKv('Order no.', booking.orderNo),
                  _miniKv('Dates', '${booking.startDate.day} - ${booking.endDate.day} ${_getMonth(booking.startDate)}'),
                  _miniKv('Guests', '${booking.guests} guests'),
                  if (bottomAction != null) ...[
                    const SizedBox(height: 16),
                    bottomAction!,
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallRow(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(color: Color(0x1F000000), blurRadius: 10, offset: Offset(0, 4))],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(booking.propertyImage, width: 84, height: 84, fit: BoxFit.cover),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          booking.propertyName,
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.navy, fontFamily: 'Cairo'),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      StatusBadge(booking.status.name, kind: _getBadgeKind(booking.status)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 11, color: Color(0xFF5B5B5B)),
                      const SizedBox(width: 3),
                      Text(booking.location, style: const TextStyle(fontSize: 12, color: Color(0xFF5B5B5B), fontFamily: 'Cairo')),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('${booking.startDate.day} - ${booking.endDate.day} ${_getMonth(booking.startDate)} · ${booking.guests} guests', 
                      style: const TextStyle(fontSize: 12, color: AppColors.navy, fontWeight: FontWeight.w600, fontFamily: 'Cairo')),
                  const SizedBox(height: 2),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 12, color: Color(0xFF5B5B5B), fontFamily: 'Cairo'),
                      children: [
                        const TextSpan(text: 'Order no. '),
                        TextSpan(
                          text: booking.orderNo,
                          style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.navy),
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

  BadgeKind _getBadgeKind(BookingStatus status) {
    switch (status) {
      case BookingStatus.active: return BadgeKind.green;
      case BookingStatus.upcoming: return BadgeKind.navy;
      case BookingStatus.cancelled: return BadgeKind.red;
      default: return BadgeKind.gray;
    }
  }

  String _getMonth(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[date.month - 1];
  }

  Widget _miniKv(String k, String v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(k, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, fontFamily: 'Cairo')),
            Text(v, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.navy, fontFamily: 'Cairo')),
          ],
        ),
      );
}
