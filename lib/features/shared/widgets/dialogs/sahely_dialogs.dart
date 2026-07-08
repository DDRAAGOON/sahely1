import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_theme.dart';

class SahelyDialogs {
  SahelyDialogs._();

  static Future<void> showLogoutDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          'Log Out', 
          style: AppTheme.dm(size: 18, weight: FontWeight.w700, color: AppColors.navy)
        ),
        content: Text(
          'Are you sure you want to log out of your account?', 
          style: AppTheme.dm(size: 14, color: AppColors.textSecondary)
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'Cancel', 
              style: AppTheme.dm(size: 14, weight: FontWeight.w600, color: AppColors.textSecondary)
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              'Log Out', 
              style: AppTheme.dm(size: 14, weight: FontWeight.w700, color: AppColors.error)
            ),
          ),
        ],
      ),
    );

    if (result == true && context.mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/role', (route) => false);
    }
  }

  static void showSnackBar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontFamily: 'Cairo')),
        backgroundColor: isError ? AppColors.error : AppColors.navy,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
