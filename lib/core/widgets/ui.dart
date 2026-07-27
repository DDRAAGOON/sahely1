import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sahely/core/navigation/app_navigation.dart';
import 'package:sahely/core/providers/auth_provider.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
export 'branding.dart';
export 'buttons.dart';
export 'forms.dart';
export 'image.dart';

/// Global dialog for logging out.
Future<void> showLogoutDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text('Log Out',
          style: AppTheme.dm(
              size: 18, weight: FontWeight.w700, color: AppColors.navy)),
      content: Text('Are you sure you want to log out?',
          style: AppTheme.dm(size: 14, color: AppColors.muted)),
      actionsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text('Cancel',
              style: AppTheme.dm(
                  size: 14, weight: FontWeight.w600, color: AppColors.muted)),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () => Navigator.pop(ctx, true),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
          ),
          child: Text('Log Out',
              style: AppTheme.dm(
                  size: 14, weight: FontWeight.w700, color: Colors.white)),
        ),
      ],
    ),
  );

  if (result == true && context.mounted) {
    await context.read<AuthProvider>().logout();
    if (context.mounted) {
      AppNavigation.safeGo(context, '/signin');
    }
  }
}
