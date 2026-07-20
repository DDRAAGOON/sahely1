import 'package:flutter/material.dart';

class BrokerLockStatusBadge extends StatelessWidget {
  final bool isInRange;
  final double distance;

  const BrokerLockStatusBadge({
    super.key,
    required this.isInRange,
    required this.distance,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor =
        isInRange ? const Color(0xFF5B926C) : const Color(0xFFE57373);
    final bgColor = isInRange
        ? const Color(0xFFDFEDDE).withValues(alpha: 0.1)
        : const Color(0xFFFBF3DE).withValues(alpha: 0.05);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            isInRange
                ? 'In range · ${distance.toStringAsFixed(1)} km'
                : 'Out of range · ${distance.toStringAsFixed(1)} km',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: statusColor,
              fontFamily: 'DM Sans',
            ),
          ),
        ],
      ),
    );
  }
}
