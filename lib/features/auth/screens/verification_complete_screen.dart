import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/role_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/cream_background.dart';
import '../../../core/widgets/ui.dart';
import '../widgets/auth_success_badge.dart';
import '../../renter/presentation/verification/presentation/bloc/verification_cubit.dart';

// ================================================= 12 · Verification Complete
class VerificationCompleteScreen extends StatelessWidget {
  const VerificationCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final roleStr = args?['role'] as String? ?? 'Renter';

    // Set the global role state
    RoleState().setRoleFromString(roleStr);

    // Automatically mark ID verification as complete in our system state
    try {
      final cubit = context.read<VerificationCubit>();
      cubit.updateIdVerified();
      cubit.updateEmailVerified();
      cubit.updatePhoneVerified();
    } catch (_) {}

    String targetRoute = '/renter/home';
    if (roleStr == 'Property Owner') targetRoute = '/owner/home';
    if (roleStr == 'Broker') targetRoute = '/broker/home';

    return PhoneScaffold(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AuthSuccessBadge(navy: true),
            const SizedBox(height: 28),
            Text('Verified!', style: AppTheme.dm(size: 26, weight: FontWeight.w700, color: AppColors.navy)),
            const SizedBox(height: 10),
            Text('Your identity is confirmed.\nYou now have full access.',
                textAlign: TextAlign.center, style: AppTheme.dm(size: 15, color: AppColors.muted, height: 1.5)),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
              decoration: BoxDecoration(color: AppColors.gold, borderRadius: BorderRadius.circular(20)),
              child: Text('You earned 5 Sahel Stars ★ on AL MAWSEM!',
                  style: AppTheme.dm(size: 13, weight: FontWeight.w700, color: AppColors.navy)),
            ),
            const SizedBox(height: 34),
            GoldButton(
                label: 'Explore Properties',
                onTap: () => Navigator.pushNamedAndRemoveUntil(context, targetRoute, (r) => false)),
          ],
        ),
      ),
    );
  }
}
