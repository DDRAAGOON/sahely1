import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';

class BookingActionButtons extends StatelessWidget {
  final VoidCallback onViewBookings;

  const BookingActionButtons({
    super.key,
    required this.onViewBookings,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 52, // Slightly taller for better prominence
          child: ElevatedButton(
            onPressed: onViewBookings,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.navy,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text(
              'View My Bookings',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                fontFamily: 'Cairo',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
