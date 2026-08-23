import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';

class BrokerBookingsHeader extends StatelessWidget {
  const BrokerBookingsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Text(
        'Broker Bookings',
        style: AppTheme.dm(
          size: 22,
          weight: FontWeight.w700,
          color: AppColors.navy,
        ),
      ),
    );
  }
}
