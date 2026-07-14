import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/cream_background.dart';
import '../../../core/widgets/ui.dart';
import '../widgets/auth_success_badge.dart';

// =================================================== 09b · Password Updated
class PasswordUpdatedScreen extends StatelessWidget {
  const PasswordUpdatedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PhoneScaffold(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AuthSuccessBadge(navy: false),
            const SizedBox(height: 30),
            Text('Password Updated', style: AppTheme.dm(size: 26, weight: FontWeight.w700, color: AppColors.navy)),
            const SizedBox(height: 10),
            Text('Your password has been reset.\nSign in to continue.',
                textAlign: TextAlign.center, style: AppTheme.dm(size: 15, color: AppColors.muted, height: 1.5)),
            const SizedBox(height: 34),
            NavyButton(
                label: 'Sign In Now',
                onTap: () => Navigator.popUntil(context, ModalRoute.withName('/signin'))),
          ],
        ),
      ),
    );
  }
}
