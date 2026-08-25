import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sahely/core/navigation/app_navigation.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/utils/currency_formatter.dart';
import 'package:sahely/core/widgets/kit.dart';
import 'package:sahely/core/widgets/ui.dart';

import 'package:sahely/features/owner/widgets/owner_bio_card.dart';
import 'package:sahely/features/owner/widgets/owner_gradient_cta.dart';
import 'package:sahely/features/owner/widgets/owner_profile_header.dart';
import 'package:sahely/core/providers/locale_provider.dart';
import 'package:sahely/l10n/app_localizations.dart';

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
            onEditProfile: () => AppNavigation.goToOwnerEditBio(context),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              OwnerTypeTag(label: AppLocalizations.of(context).roleOwnerTitle),
            ],
          ),
          const SizedBox(height: 12),
          const OwnerBioCard(
            bio:
                'Hosting beachfront villas across Marassi & Hacienda Bay. Superhost since 2023 🏖',
            handle: '@layla.stays',
          ),
          const SizedBox(height: 12),
          OwnerGradientCta(
            title: AppLocalizations.of(context).manageDashboard,
            subtitle: AppLocalizations.of(context).manageSubtitle,
            icon: Icons.dashboard_outlined,
            route: '/owner/manage',
            colors: const [Color(0xFF22335A), AppColors.navy],
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
                label: AppLocalizations.of(context).walletCredit,
                value: CurrencyFormatter.format(1250),
                valueColor: AppColors.gold,
                iconColor: AppColors.gold,
                onTap: () => AppNavigation.goToOwnerEarnings(context),
              ),
              SettingsRow(
                icon: Icons.credit_card_outlined,
                label: AppLocalizations.of(context).paymentCard,
                value: 'Visa ••42',
                iconColor: AppColors.gold,
                onTap: () => AppNavigation.goToAddCard(context),
              ),
              SettingsRow(
                icon: Icons.star_outline,
                label: AppLocalizations.of(context).myReviews,
                value: '★ 4.9',
                iconColor: AppColors.gold,
                onTap: () => AppNavigation.goToMyReviews(context),
              ),
              SettingsRow(
                icon: Icons.account_balance_outlined,
                label: 'Payout Bank · IBAN',
                value: 'EG••4821',
                valueColor: AppColors.success,
                iconColor: AppColors.gold,
                onTap: () => AppNavigation.goToOwnerPayout(context),
              ),
              SettingsRow(
                icon: Icons.notifications_none,
                label: AppLocalizations.of(context).notificationsLabel,
                iconColor: AppColors.gold,
                onTap: () {
                  AppNavigation.goToOwnerNotifications(context);
                },
              ),
              SettingsRow(
                icon: Icons.lock_outline,
                label: AppLocalizations.of(context).changePassword,
                iconColor: AppColors.gold,
                onTap: () => AppNavigation.goToChangePassword(context),
              ),
              SettingsRow(
                icon: Icons.language,
                label: AppLocalizations.of(context).languageLabel,
                value: AppLocalizations.nativeLanguageName(context.watch<LocaleProvider>().locale.languageCode),
                iconColor: AppColors.gold,
                onTap: () => AppNavigation.goToLanguage(context),
              ),
              SettingsRow(
                icon: Icons.attach_money,
                label: AppLocalizations.of(context).currencyLabel,
                value: 'EGP',
                valueColor: AppColors.navy,
                iconColor: AppColors.gold,
                onTap: () => AppNavigation.goToCurrency(context),
                last: true,
              ),
            ]),
          ),
          const SizedBox(height: 14),
          WideButton(
            label: AppLocalizations.of(context).logOut,
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
