import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';

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
            child: Text(
              'View My Bookings',
              style: AppTheme.dm(
                size: 15,
                weight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
