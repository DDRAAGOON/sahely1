import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';

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
    const months = ['Jun', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final hour = dateTime.hour == 0 ? 12 : (dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour);
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '${months[dateTime.month - 1]} ${dateTime.day}, $hour:$minute $period';
  }

  String _formatPrice(int piastres) {
    final amount = piastres / 100;
    return 'EGP ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (Match m) => "${m[1]},")}';
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
              const Text(
                'Total paid',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                  fontFamily: 'DM Sans',
                ),
              ),
              Text(
                _formatPrice(totalPaid),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                  fontFamily: 'DM Sans',
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
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w400,
            fontFamily: 'DM Sans',
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.navy,
            fontWeight: FontWeight.w700,
            fontFamily: 'DM Sans',
          ),
        ),
      ],
    );
  }
}
