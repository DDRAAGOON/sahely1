import 'package:flutter/material.dart';

class BrokerCheckInOutFooter extends StatelessWidget {
  final DateTime checkIn;
  final DateTime checkOut;

  const BrokerCheckInOutFooter({
    super.key,
    required this.checkIn,
    required this.checkOut,
  });

  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Check-in: ${_formatDate(checkIn)} · Check-out: ${_formatDate(checkOut)}',
        style: const TextStyle(
          fontSize: 13,
          color: Color(0xFFC49F45),
          fontWeight: FontWeight.w500,
          fontFamily: 'DM Sans',
        ),
      ),
    );
  }
}
