import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';

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
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.secondary,
            fontFamily: 'DM Sans',
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
            fontFamily: 'DM Sans',
          ),
        ),
      ],
    );
  }
}
