import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';

class ReservationDetailsCard extends StatelessWidget {
  final String orderNumber;
  final String checkIn;
  final String checkOut;
  final String guests;
  final dynamic nights;

  const ReservationDetailsCard({
    super.key,
    required this.orderNumber,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
    required this.nights,
  });

  @override
  Widget build(BuildContext context) {
    // Soft divider color to match the page style
    final Color softDivider = AppColors.border.withValues(alpha: 0.3);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          _buildRow('Order no.', orderNumber),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Divider(height: 1, color: softDivider),
          ),
          _buildRow('Check-in', checkIn),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Divider(height: 1, color: softDivider),
          ),
          _buildRow('Check-out', checkOut),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Divider(height: 1, color: softDivider),
          ),
          _buildRow('Guests', guests),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Divider(height: 1, color: softDivider),
          ),
          _buildRow('Nights', '$nights'),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTheme.dm(
            size: 14,
            color: AppColors.secondary,
          ),
        ),
        Text(
          value,
          style: AppTheme.dm(
            size: 15,
            weight: FontWeight.w700,
            color: AppColors.navy,
          ),
        ),
      ],
    );
  }
}
