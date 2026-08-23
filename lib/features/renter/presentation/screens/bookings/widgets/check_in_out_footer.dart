import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_theme.dart';

class CheckInOutFooter extends StatelessWidget {
  final DateTime checkIn;
  final DateTime checkOut;

  const CheckInOutFooter({
    super.key,
    required this.checkIn,
    required this.checkOut,
  });

  String _formatDate(DateTime date) {
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
    return '${months[date.month - 1]} ${date.day}';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Check-in: ${_formatDate(checkIn)} · Check-out: ${_formatDate(checkOut)}',
        style: AppTheme.dm(
          size: 13,
          color: const Color(0xFFC49F45),
          weight: FontWeight.w500,
        ),
      ),
    );
  }
}
