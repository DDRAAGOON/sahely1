import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/cream_background.dart';
import '../../../widgets/floating_nav.dart';
import '../../../widgets/kit.dart';
import '../../../widgets/ui.dart';

class RenterProfileScreen extends StatelessWidget {
  const RenterProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PhoneScaffold(
      child: Stack(children: [
        ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
          children: [
            Row(children: [
              Stack(children: [
                const AvatarCircle(size: 64),
                Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                            color: AppColors.gold, shape: BoxShape.circle, border: Border.all(color: AppColors.cream, width: 2)),
                        child: const Icon(Icons.camera_alt, size: 12, color: AppColors.navy))),
              ]),
              const SizedBox(width: 14),
              Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Mariam Hassan', style: AppTheme.dm(size: 18, weight: FontWeight.w700, color: AppColors.navy)),
                Text('mariam@example.com', style: AppTheme.dm(size: 13, color: AppColors.muted)),
                const SizedBox(height: 2),
                Text('Edit Profile', style: AppTheme.dm(size: 13, weight: FontWeight.w600, color: AppColors.gold)),
              ])),
            ]),
            const SizedBox(height: 14),
            WhiteCard(
              padding: const EdgeInsets.all(14),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Sun-chaser & North Coast regular. Always hunting the next great beachfront escape 🏝',
                    style: AppTheme.dm(size: 13, height: 1.4)),
                const SizedBox(height: 10),
                Row(children: [
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(color: AppColors.cream, borderRadius: BorderRadius.circular(10)),
                      child: const Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.camera_alt_outlined, size: 14, color: AppColors.gold),
                        SizedBox(width: 6),
                        Text('@mariam.h')
                      ])),
                  const SizedBox(width: 8),
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(color: AppColors.cream, borderRadius: BorderRadius.circular(10)),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        const Icon(Icons.add, size: 14, color: AppColors.muted),
                        const SizedBox(width: 6),
                        Text('Add social', style: AppTheme.dm(size: 12, color: AppColors.muted))
                      ])),
                ]),
              ]),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/mawsem'),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF22335A), AppColors.navy]),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.gold.withValues(alpha: 0.5))),
                child: Row(children: [
                  Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                          color: AppColors.gold.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.star, color: AppColors.gold, size: 20)),
                  const SizedBox(width: 12),
                  Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('AL MAWSEM Season Pass', style: AppTheme.dm(size: 14, weight: FontWeight.w700, color: Colors.white)),
                    Text('Wave Rider · 47 ★', style: AppTheme.dm(size: 11, color: AppColors.gold)),
                  ])),
                  const Icon(Icons.chevron_right, color: AppColors.gold),
                ]),
              ),
            ),
            const SizedBox(height: 18),
            Row(children: [
              Text('Account Verification', style: AppTheme.dm(size: 14, weight: FontWeight.w600, color: AppColors.navy)),
              const SizedBox(width: 8),
              Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFFD2760A), shape: BoxShape.circle)),
            ]),
            const SizedBox(height: 8),
            WhiteCard(
              child: Column(children: [
                _verifyRow('Email Confirmed', done: true),
                _verifyRow('Phone Verified', done: true),
                _verifyRow('Identity Verified', done: false, action: 'Verify Now →'),
                _verifyRow('Payment Card', done: false, action: 'Add Card →', last: true),
              ]),
            ),
            const SizedBox(height: 14),
            WhiteCard(
              child: Column(children: [
                SettingsRow(
                    icon: Icons.account_balance_wallet_outlined,
                    label: 'Wallet & Credit',
                    value: 'EGP 250',
                    valueColor: AppColors.gold,
                    onTap: () => Navigator.pushNamed(context, '/renter/wallet')),
                SettingsRow(
                    icon: Icons.star_outline,
                    label: 'My Reviews',
                    value: '8 given · 6 received',
                    onTap: () => Navigator.pushNamed(context, '/renter/reviews')),
                const SettingsRow(icon: Icons.credit_card_outlined, label: 'Payment Methods'),
                const SettingsRow(icon: Icons.notifications_none, label: 'Notifications'),
                SettingsRow(
                    icon: Icons.lock_outline,
                    label: 'Change Password',
                    onTap: () => Navigator.pushNamed(context, '/change-password')),
                SettingsRow(
                    icon: Icons.language,
                    label: 'Language',
                    value: 'English',
                    onTap: () => Navigator.pushNamed(context, '/language')),
                SettingsRow(
                    icon: Icons.attach_money,
                    label: 'Currency',
                    value: 'EGP',
                    valueColor: AppColors.navy,
                    onTap: () => Navigator.pushNamed(context, '/currency'),
                    last: true),
              ]),
            ),
            const SizedBox(height: 14),
            WideButton(
              label: 'Log Out',
              icon: Icons.logout,
              color: const Color(0xFFB22222),
              outline: true,
              height: 48,
              onTap: () => showLogoutDialog(context),
            ),
          ],
        ),
        const FloatingNav(active: 4),
      ]),
    );
  }

  Widget _verifyRow(String label, {required bool done, String? action, bool last = false}) => Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: last ? null : const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFF4EFE7)))),
        child: Row(children: [
          Expanded(child: Text(label, style: AppTheme.dm(size: 14))),
          if (done)
            Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle),
                child: const Icon(Icons.check, size: 14, color: Colors.white))
          else ...[
            const Icon(Icons.error_outline, size: 18, color: Color(0xFFD2760A)),
            const SizedBox(width: 8),
            Text(action!, style: AppTheme.dm(size: 12, weight: FontWeight.w700, color: AppColors.gold)),
          ],
        ]),
      );
}
