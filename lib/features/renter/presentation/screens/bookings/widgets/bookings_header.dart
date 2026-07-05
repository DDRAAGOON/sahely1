import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';

class BookingsHeader extends StatelessWidget {
  const BookingsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Text(
        'My Bookings',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: AppColors.navy,
          fontFamily: 'DM Sans',
        ),
      ),
    );
  }
}
