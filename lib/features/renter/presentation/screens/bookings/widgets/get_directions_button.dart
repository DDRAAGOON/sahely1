import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_theme.dart';

class GetDirectionsButton extends StatelessWidget {
  final VoidCallback onTap;

  const GetDirectionsButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFC49F45),
            foregroundColor: const Color(0xFF0F172A), // Dark navy
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            elevation: 0,
          ),
          child: Text(
            'Get Directions',
            style: AppTheme.dm(
              size: 16,
              weight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
