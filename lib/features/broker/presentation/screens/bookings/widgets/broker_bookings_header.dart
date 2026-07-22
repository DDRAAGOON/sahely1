import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';

class BrokerBookingsHeader extends StatelessWidget {
  const BrokerBookingsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Text(
        'Broker Bookings',
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
