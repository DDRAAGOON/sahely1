import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sahely/core/di/service_locator.dart' show sl;
import 'package:sahely/core/navigation/app_navigation.dart';
import 'package:sahely/core/network/api_envelope.dart';
import 'package:sahely/core/providers/profile_provider.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/utils/currency_formatter.dart';
import 'package:sahely/core/widgets/kit.dart';
import 'package:sahely/core/widgets/ui.dart';
import 'package:sahely/features/owner/widgets/owner_bio_card.dart';
import 'package:sahely/features/owner/widgets/owner_gradient_cta.dart';
import 'package:sahely/features/owner/widgets/owner_profile_header.dart';
import 'package:sahely/features/payments/data/datasources/payment_remote_data_source.dart';
import 'package:sahely/features/wallet/data/datasources/wallet_remote_data_source.dart';
import 'package:sahely/l10n/app_localizations.dart';
import 'package:sahely/l10n/app_localizations_ext.dart';

/// The owner's account: identity from the profile, the withdrawable balance
/// from `/wallets/me` and the saved card from `/payments/cards`.
class OwnerProfileScreen extends StatefulWidget {
  const OwnerProfileScreen({super.key});

  @override
  State<OwnerProfileScreen> createState() => _OwnerProfileScreenState();
}

class _OwnerProfileScreenState extends State<OwnerProfileScreen> {
  double? _walletEgp;
  String? _cardLast4;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<ProfileProvider>().fetchProfileData();
    });
    _loadAccount();
  }

  Future<void> _loadAccount() async {
    final wallet = await sl<WalletRemoteDataSource>().getMyWallet();
    final cards = await sl<PaymentRemoteDataSource>().getPaymentCards();
    if (!mounted) return;
    setState(() {
      wallet.fold((_) {}, (w) {
        final piastres =
            asNum(pick(w, 'withdrawable_piastres')) ?? asNum(w['balance']) ?? 0;
        _walletEgp = piastres / 100;
      });
      cards.fold((_) {}, (list) {
        _cardLast4 = list.isEmpty ? null : list.first.lastFourDigits;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileProvider>();
    final level = profile.levelData;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
        children: [
          OwnerProfileHeader(
            name: profile.name,
            email: profile.email,
            onEditProfile: () => AppNavigation.goToOwnerEditBio(context),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              OwnerTypeTag(label: AppLocalizations.of(context).roleOwnerTitle),
            ],
          ),
          const SizedBox(height: 12),
          if (profile.bio.isNotEmpty ||
              (profile.instagram ?? '').isNotEmpty) ...[
            OwnerBioCard(
              bio: profile.bio,
              handle: profile.instagram ?? '',
            ),
            const SizedBox(height: 12),
          ],
          OwnerGradientCta(
            title: AppLocalizations.of(context).manageDashboard,
            subtitle: AppLocalizations.of(context).manageSubtitle,
            icon: Icons.dashboard_outlined,
            route: '/owner/manage',
            colors: const [Color(0xFF22335A), AppColors.navy],
          ),
          const SizedBox(height: 12),
          OwnerGradientCta(
            title: 'AL MAWSEM Season Pass',
            subtitle:
                '${level['name']} · ${profile.stars} ★ · earn stars when you rent',
            icon: Icons.star,
            route: '/mawsem',
            colors: const [Color(0xFF2A2418), AppColors.navy],
          ),
          const SizedBox(height: 14),
          WhiteCard(
            child: Column(children: [
              SettingsRow(
                icon: Icons.account_balance_wallet_outlined,
                label: AppLocalizations.of(context).walletCredit,
                value: _walletEgp == null
                    ? '—'
                    : CurrencyFormatter.format(_walletEgp!.round()),
                valueColor: AppColors.gold,
                iconColor: AppColors.gold,
                onTap: () => AppNavigation.goToOwnerEarnings(context),
              ),
              SettingsRow(
                icon: Icons.credit_card_outlined,
                label: AppLocalizations.of(context).paymentCard,
                value: _cardLast4 == null ? null : '••$_cardLast4',
                iconColor: AppColors.gold,
                onTap: () => AppNavigation.goToAddCard(context),
              ),
              SettingsRow(
                icon: Icons.star_outline,
                label: AppLocalizations.of(context).myReviews,
                value: profile.reviewsReceived > 0
                    ? '${profile.reviewsReceived}'
                    : null,
                iconColor: AppColors.gold,
                onTap: () => AppNavigation.goToMyReviews(context),
              ),
              SettingsRow(
                icon: Icons.account_balance_outlined,
                label: 'Payout Bank · IBAN',
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
                value: AppLocalizations.of(context).languageNameFor(
                    Localizations.localeOf(context).languageCode),
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
