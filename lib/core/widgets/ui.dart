import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../providers/auth_provider.dart';

export 'buttons.dart';
export 'forms.dart';
export 'image.dart';
export 'branding.dart';

/// Global dialog for logging out.
Future<void> showLogoutDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text('Log Out', style: AppTheme.dm(size: 18, weight: FontWeight.w700, color: AppColors.navy)),
      content: Text('Are you sure you want to log out of your account?', style: AppTheme.dm(size: 14, color: AppColors.muted)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text('Cancel', style: AppTheme.dm(size: 14, weight: FontWeight.w600, color: AppColors.muted)),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: Text('Log Out', style: AppTheme.dm(size: 14, weight: FontWeight.w700, color: AppColors.danger)),
        ),
      ],
    ),
  );

  if (result == true && context.mounted) {
    await context.read<AuthProvider>().logout();
    if (context.mounted) {
      context.go('/signin');
    }
  }
}
