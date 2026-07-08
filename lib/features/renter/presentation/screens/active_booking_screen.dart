import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ActiveBookingScreen extends StatelessWidget {
  const ActiveBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('My Bookings', style: TextStyle(fontFamily: 'Cairo', color: AppColors.navy, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today_outlined, size: 64, color: AppColors.navy.withValues(alpha: 0.2)),
            const SizedBox(height: 16),
            const Text(
              'No active bookings found',
              style: TextStyle(fontFamily: 'Cairo', fontSize: 16, color: AppColors.secondary),
            ),
          ],
        ),
      ),
    );
  }
}
