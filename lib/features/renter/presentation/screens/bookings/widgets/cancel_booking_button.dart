import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_theme.dart';

class CancelBookingButton extends StatelessWidget {
  final VoidCallback onTap;

  const CancelBookingButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFFB22222), width: 1.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: const Color(0xFFFFF5F5),
          elevation: 0,
        ),
        child: Text(
          'Cancel booking',
          style: AppTheme.dm(
            size: 16,
            weight: FontWeight.w700,
            color: const Color(0xFFB22222),
          ),
        ),
      ),
    );
  }
}
