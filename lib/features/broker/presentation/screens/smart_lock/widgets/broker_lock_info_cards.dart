import 'package:flutter/material.dart';

class BrokerLockInfoCards extends StatelessWidget {
  final bool isInRange;
  final double distance;
  final DateTime checkOut;

  const BrokerLockInfoCards({
    super.key,
    required this.isInRange,
    required this.distance,
    required this.checkOut,
  });

  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCard(
            isInRange ? 'Valid until' : 'Distance',
            isInRange ? 'Checkout · ${_formatDate(checkOut)}' : '${distance.toStringAsFixed(1)} km away',
          ),
          const SizedBox(width: 10),
          _buildCard(
            isInRange ? 'Code stays' : 'Unlocks within',
            isInRange ? 'The same' : '2 km',
          ),
        ],
      ),
    );
  }

  Widget _buildCard(String label, String value) {
    return Expanded(
      child: Container(
        height: 80, // Fixed height to ensure both match exactly
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B).withOpacity(0.4),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.08),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF94A3B8),
                fontFamily: 'DM Sans',
              ),
            ),
            const SizedBox(height: 6),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontFamily: 'DM Sans',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
