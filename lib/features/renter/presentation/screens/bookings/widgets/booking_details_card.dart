import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/utils/currency_formatter.dart';

class BookingDetailsCard extends StatelessWidget {
  final DateTime checkIn;
  final DateTime checkOut;
  final int adults;
  final String unitInfo;
  final String bookingRef;
  final int totalPaid;

  const BookingDetailsCard({
    super.key,
    required this.checkIn,
    required this.checkOut,
    required this.adults,
    required this.unitInfo,
    required this.bookingRef,
    required this.totalPaid,
  });

  String _formatDateTime(DateTime dateTime) {
    const months = [
      'Jun',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    final hour = dateTime.hour == 0
        ? 12
        : (dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour);
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '${months[dateTime.month - 1]} ${dateTime.day}, $hour:$minute $period';
  }

  String _formatPrice(int amount) {
    return CurrencyFormatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withValues(alpha: 0.02),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildRow('Check-in', _formatDateTime(checkIn)),
          const SizedBox(height: 12),
          _buildRow('Check-out', _formatDateTime(checkOut)),
          const SizedBox(height: 12),
          _buildRow('Guests', '$adults adults'),
          const SizedBox(height: 12),
          _buildRow('Unit · Floor', unitInfo),
          const SizedBox(height: 12),
          _buildRow('Booking ref', bookingRef),
          const SizedBox(height: 16),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total paid',
                style: AppTheme.dm(
                  size: 14,
                  weight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
              Text(
                _formatPrice(totalPaid),
                style: AppTheme.dm(
                  size: 14,
                  weight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
            ],
          ),
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
            size: 13,
            color: AppColors.textSecondary,
            weight: FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: AppTheme.dm(
            size: 13,
            color: AppColors.navy,
            weight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
