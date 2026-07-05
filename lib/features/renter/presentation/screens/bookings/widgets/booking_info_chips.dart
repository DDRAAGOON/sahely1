import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';

class BookingInfoChips extends StatelessWidget {
  final String orderNumber;
  final String dates;
  final String guests;

  const BookingInfoChips({
    super.key,
    required this.orderNumber,
    required this.dates,
    required this.guests,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _InfoChip(label: 'Order', value: orderNumber),
        _InfoChip(label: 'Dates', value: dates),
        _InfoChip(label: 'Guests', value: guests),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;

  const _InfoChip({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.secondary,
              fontFamily: 'DM Sans',
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.navy,
              fontFamily: 'DM Sans',
            ),
          ),
        ],
      ),
    );
  }
}
