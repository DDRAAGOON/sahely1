import 'package:flutter/material.dart';
import '../../../../../../core/navigation/app_navigation.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/widgets/kit.dart';
import '../../../../../../core/widgets/ui.dart';

class BrokerProfilePage extends StatelessWidget {
  const BrokerProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
        children: [
          Row(children: [
            Stack(children: [
              const AvatarCircle(size: 64, colors: [Color(0xFFC9A84C), Color(0xFF8A7330)]),
              Positioned(right: 0, bottom: 0, child: Container(width: 24, height: 24, decoration: BoxDecoration(color: AppColors.gold, shape: BoxShape.circle, border: Border.all(color: AppColors.cream, width: 2)), child: const Icon(Icons.camera_alt, size: 12, color: AppColors.navy))),
            ]),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Karim Adel', style: AppTheme.dm(size: 18, weight: FontWeight.w700, color: AppColors.navy)),
              Text('karim@example.com', style: AppTheme.dm(size: 13, color: AppColors.muted)),
              Text('Edit Profile', style: AppTheme.dm(size: 13, weight: FontWeight.w600, color: AppColors.gold)),
            ])),
          ]),
          const SizedBox(height: 12),
          const Align(alignment: Alignment.centerLeft, child: StatusBadge('Gold Broker', kind: BadgeKind.gold)),
          const SizedBox(height: 12),
          _brokerCta(
            context,
            'My Role Dashboard',
            'Tier · Commissions · Portfolio',
            Icons.workspace_premium_outlined,
            () => AppNavigation.goToBrokerTier(context),
            const [Color(0xFF2F8F86), Color(0xFF1D5E57)],
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/broker/tier'),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF2A2418), Color(0xFF141D33)]), borderRadius: BorderRadius.circular(14)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Container(width: 36, height: 36, decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.star, color: AppColors.gold, size: 18)),
                  const SizedBox(width: 12),
                  Expanded(child: Text('Gold Tier · 4% commission', style: AppTheme.dm(size: 14, weight: FontWeight.w700, color: Colors.white))),
                ]),
                const SizedBox(height: 12),
                ClipRRect(borderRadius: BorderRadius.circular(4), child: const LinearProgressIndicator(value: 0.55, minHeight: 6, backgroundColor: Colors.white24, valueColor: AlwaysStoppedAnimation(AppColors.gold))),
                const SizedBox(height: 6),
                Text('45 properties to Elite (5%)', style: AppTheme.dm(size: 11, color: AppColors.gold)),
              ]),
            ),
          ),
          const SizedBox(height: 12),
          _brokerCta(
            context,
            'AL MAWSEM Season Pass',
            'Wave Rider · 18 ★ · earn stars when you rent',
            Icons.waves,
            () => Navigator.pushNamed(context, '/broker/mawsem'),
            const [Color(0xFF2A2418), AppColors.navy],
          ),
          const SizedBox(height: 12),
          WhiteCard(padding: const EdgeInsets.all(14), child: Row(children: [
            Container(width: 38, height: 38, decoration: BoxDecoration(color: AppColors.cardWarm, borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.credit_card_outlined, color: AppColors.navy)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Add a payment card', style: AppTheme.dm(size: 13, weight: FontWeight.w700)),
              Text('For your account', style: AppTheme.dm(size: 11, color: AppColors.muted)),
            ])),
            Text('Add →', style: AppTheme.dm(size: 12, weight: FontWeight.w700, color: AppColors.gold)),
          ])),
          const SizedBox(height: 12),
          DottedBorder(color: AppColors.gold, radius: 14, child: Container(
            padding: const EdgeInsets.all(14),
            child: Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Your referral code', style: AppTheme.dm(size: 11, color: AppColors.muted)),
                Text('KARIM-4821', style: AppTheme.dm(size: 16, weight: FontWeight.w700, color: const Color(0xFF9A7A22), letterSpacing: 1)),
              ])),
              Container(height: 36, padding: const EdgeInsets.symmetric(horizontal: 16), decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(10)), child: Row(children: [const Icon(Icons.copy, size: 14, color: AppColors.gold), const SizedBox(width: 5), Text('Copy', style: AppTheme.dm(size: 12, weight: FontWeight.w700, color: Colors.white))])),
            ]),
          )),
          const SizedBox(height: 14),
           WhiteCard(child: Column(children: [
            const SettingsRow(icon: Icons.star_outline, label: 'Reviews I Gave', value: '14 reviews'),
            SettingsRow(icon: Icons.account_balance_outlined, label: 'Payout Bank · IBAN', value: 'EG••4821', valueColor: AppColors.success, onTap: () => Navigator.pushNamed(context, '/broker/payout')),
            const SettingsRow(icon: Icons.notifications_none, label: 'Notifications'),
            SettingsRow(icon: Icons.lock_outline, label: 'Change Password', onTap: () => Navigator.pushNamed(context, '/change-password')),
            SettingsRow(icon: Icons.language, label: 'Language', value: 'English', onTap: () => Navigator.pushNamed(context, '/language')),
            SettingsRow(icon: Icons.attach_money, label: 'Currency', value: 'EGP', valueColor: AppColors.navy, onTap: () => Navigator.pushNamed(context, '/currency'), last: true),
          ])),
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
    );
  }

  Widget _brokerCta(BuildContext context, String title, String sub, IconData icon, VoidCallback onTap, List<Color> colors) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(gradient: LinearGradient(colors: colors), borderRadius: BorderRadius.circular(14)),
          child: Row(children: [
            Container(width: 38, height: 38, decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: AppColors.gold, size: 20)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: AppTheme.dm(size: 14, weight: FontWeight.w700, color: Colors.white)),
              Text(sub, style: AppTheme.dm(size: 11, color: AppColors.gold)),
            ])),
            const Icon(Icons.chevron_right, color: AppColors.gold),
          ]),
        ),
      );
}
