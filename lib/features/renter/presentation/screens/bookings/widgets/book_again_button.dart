import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';

class BookAgainButton extends StatelessWidget {
  final VoidCallback onTap;

  const BookAgainButton({
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
          backgroundColor: const Color(0xFFF3EFE7), // Light cream as in image
          side: const BorderSide(color: AppColors.navy, width: 1.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          'Book again',
          style: AppTheme.dm(
            size: 16,
            weight: FontWeight.w700,
            color: AppColors.navy,
          ),
        ),
      ),
    );
  }
}
