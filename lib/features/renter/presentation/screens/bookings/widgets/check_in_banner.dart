import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';

class CheckInBanner extends StatelessWidget {
  final int daysUntilCheckIn;

  const CheckInBanner({
    super.key,
    required this.daysUntilCheckIn,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF9F0),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE4C56A), width: 1),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.access_time,
            color: Color(0xFFB1974C),
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Check-in in $daysUntilCheckIn days · passcode unlocks within 2 km',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF9A7A22),
                fontFamily: 'DM Sans',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
