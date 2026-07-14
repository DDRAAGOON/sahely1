import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/widgets/floating_nav.dart';
import 'package:sahely/core/widgets/kit.dart';
import 'package:sahely/core/widgets/ui.dart';
import '../widgets/owner_profile_header.dart';
import '../widgets/owner_bio_card.dart';
import '../widgets/owner_gradient_cta.dart';

class OwnerProfileScreen extends StatelessWidget {
  const OwnerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
        children: [
          OwnerProfileHeader(
              name: 'Layla Mansour',
              email: 'layla@example.com',
              onEditProfile: () => context.push('/owner/edit-bio'),
            ),
            const SizedBox(height: 12),
            const Row(
              children: [
                OwnerTypeTag(label: 'Property Owner'),
              ],
            ),
            const SizedBox(height: 12),
            const OwnerBioCard(
              bio: 'Hosting beachfront villas across Marassi & Hacienda Bay. Superhost since 2023 🏖',
              handle: '@layla.stays',
            ),
            const SizedBox(height: 12),
            const OwnerGradientCta(
              title: 'Manage Dashboard',
              subtitle: 'Properties · Requests · Wallet',
              icon: Icons.dashboard_outlined,
              route: '/owner/manage',
              colors: [Color(0xFF22335A), AppColors.navy],
            ),
            const SizedBox(height: 12),
            const OwnerGradientCta(
              title: 'AL MAWSEM Season Pass',
              subtitle: 'Shore Explorer · 22 ★ · earn stars when you rent',
              icon: Icons.star,
              route: '/mawsem',
              colors: [Color(0xFF2A2418), AppColors.navy],
            ),
            const SizedBox(height: 14),
            WhiteCard(
              child: Column(children: [
                SettingsRow(
                  icon: Icons.account_balance_wallet_outlined,
                  label: 'Wallet & Credit',
                  value: 'EGP 1,250',
                  valueColor: AppColors.gold,
                  iconColor: AppColors.gold,
                  onTap: () => context.push('/owner/earnings'),
                ),
                const SettingsRow(
                  icon: Icons.credit_card_outlined,
                  label: 'Payment Card',
                  value: 'Visa ••42',
                  iconColor: AppColors.gold,
                ),
                const SettingsRow(
                  icon: Icons.star_outline,
                  label: 'My Reviews',
                  value: '★ 4.9',
                  iconColor: AppColors.gold,
                ),
                SettingsRow(
                  icon: Icons.account_balance_outlined,
                  label: 'Payout Bank · IBAN',
                  value: 'EG••4821',
                  valueColor: AppColors.success,
                  iconColor: AppColors.gold,
                  onTap: () => context.push('/owner/payout'),
                ),
                SettingsRow(
                  icon: Icons.notifications_none,
                  label: 'Notifications',
                  iconColor: AppColors.gold,
                  onTap: () {
                    context.push('/owner/notifications');
                  },
                ),
                SettingsRow(
                  icon: Icons.lock_outline,
                  label: 'Change Password',
                  iconColor: AppColors.gold,
                  onTap: () => context.push('/change-password'),
                ),
                SettingsRow(
                  icon: Icons.language,
                  label: 'Language',
                  value: 'English',
                  iconColor: AppColors.gold,
                  onTap: () => context.push('/language'),
                  last: true,
                ),
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
    );
  }
}
