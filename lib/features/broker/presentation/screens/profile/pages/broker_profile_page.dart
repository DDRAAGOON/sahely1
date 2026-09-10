import 'package:flutter/material.dart';
import 'package:sahely/core/navigation/app_navigation.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/l10n/app_localizations.dart';
import 'package:sahely/core/widgets/kit.dart';
import 'package:sahely/core/widgets/ui.dart';

class BrokerProfilePage extends StatelessWidget {
  const BrokerProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cream,
      child: Scaffold(
        backgroundColor: AppColors.cream,
        body: SafeArea(
          bottom: false,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
            children: [
              Row(children: [
                Stack(children: [
                  const AvatarCircle(
                      size: 64, colors: [Color(0xFFC9A84C), Color(0xFF8A7330)]),
                  Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                              color: AppColors.gold,
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: AppColors.cream, width: 2)),
                          child: const Icon(Icons.camera_alt,
                              size: 12, color: AppColors.navy))),
                ]),
                const SizedBox(width: 14),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text('Karim Adel',
                          style: AppTheme.dm(
                              size: 18,
                              weight: FontWeight.w700,
                              color: AppColors.navy)),
                      Text('karim@example.com',
                          style: AppTheme.dm(size: 13, color: AppColors.muted)),
                      GestureDetector(
                        onTap: () => AppNavigation.goToEditProfile(context),
                        child: Text(AppLocalizations.of(context).editProfile,
                            style: AppTheme.dm(
                                size: 13,
                                weight: FontWeight.w600,
                                color: AppColors.gold)),
                      ),
                    ])),
              ]),
              const SizedBox(height: 12),
              Align(
                  alignment: Alignment.centerLeft,
                  child: StatusBadge(AppLocalizations.of(context).goldBroker, kind: BadgeKind.gold)),
              const SizedBox(height: 12),
              _brokerCta(
                context,
                'My Role Dashboard',
                'Tier · Commissions · Portfolio',
                Icons.workspace_premium_outlined,
                () => AppNavigation.goToBrokerDashboard(context),
                const [Color(0xFF2F8F86), Color(0xFF1D5E57)],
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => AppNavigation.goToBrokerTier(context),
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [Color(0xFF2A2418), Color(0xFF141D33)]),
                      borderRadius: BorderRadius.circular(14)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                  color: AppColors.gold.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(10)),
                              child: const Icon(Icons.star,
                                  color: AppColors.gold, size: 18)),
                          const SizedBox(width: 12),
                          Expanded(
                              child: Text('Gold Tier · 4% commission',
                                  style: AppTheme.dm(
                                      size: 14,
                                      weight: FontWeight.w700,
                                      color: Colors.white))),
                        ]),
                        const SizedBox(height: 12),
                        ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: const LinearProgressIndicator(
                                value: 0.55,
                                minHeight: 6,
                                backgroundColor: Colors.white24,
                                valueColor:
                                    AlwaysStoppedAnimation(AppColors.gold))),
                        const SizedBox(height: 6),
                        Text('45 properties to Elite (5%)',
                            style: AppTheme.dm(size: 11, color: AppColors.gold)),
                      ]),
                ),
              ),
              const SizedBox(height: 12),
              _brokerCta(
                context,
                'AL MAWSEM Season Pass',
                'Wave Rider · 18 ★ · earn stars when you rent',
                Icons.waves,
                () => AppNavigation.goToMawsem(context),
                const [Color(0xFF2A2418), AppColors.navy],
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => AppNavigation.goToAddCard(context),
                behavior: HitTestBehavior.opaque,
                child: WhiteCard(
                    padding: const EdgeInsets.all(14),
                    child: Row(children: [
                      Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                              color: AppColors.cardWarm,
                              borderRadius: BorderRadius.circular(10)),
                          child: const Icon(Icons.credit_card_outlined,
                              color: AppColors.navy)),
                      const SizedBox(width: 12),
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Text(AppLocalizations.of(context).addPaymentCard,
                                style:
                                    AppTheme.dm(size: 13, weight: FontWeight.w700)),
                            Text(AppLocalizations.of(context).forYourAccount,
                                style:
                                    AppTheme.dm(size: 11, color: AppColors.muted)),
                          ])),
                      Text('Add →',
                          style: AppTheme.dm(
                              size: 12,
                              weight: FontWeight.w700,
                              color: AppColors.gold)),
                    ])),
              ),
              const SizedBox(height: 12),
              DottedBorder(
                  color: AppColors.gold,
                  radius: 14,
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    child: Row(children: [
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Text(AppLocalizations.of(context).yourReferralCode,
                                style: AppTheme.dm(
                                    size: 11, color: AppColors.muted)),
                            Text('KARIM-4821',
                                style: AppTheme.dm(
                                    size: 16,
                                    weight: FontWeight.w700,
                                    color: const Color(0xFF9A7A22),
                                    letterSpacing: 1)),
                          ])),
                      Container(
                          height: 36,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                              color: AppColors.navy,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(children: [
                            const Icon(Icons.copy,
                                size: 14, color: AppColors.gold),
                            const SizedBox(width: 5),
                            Text(AppLocalizations.of(context).copyLabel,
                                style: AppTheme.dm(
                                    size: 12,
                                    weight: FontWeight.w700,
                                    color: Colors.white))
                          ])),
                    ]),
                  )),
              const SizedBox(height: 14),
              WhiteCard(
                  child: Column(children: [
                SettingsRow(
                    icon: Icons.star_outline,
                    label: AppLocalizations.of(context).reviewsIGave,
                    value: '14 reviews',
                    onTap: () => AppNavigation.goToMyReviews(context)),
                SettingsRow(
                    icon: Icons.account_balance_outlined,
                    label: 'Payout Bank · IBAN',
                    value: 'EG••4821',
                    valueColor: AppColors.success,
                    onTap: () => AppNavigation.goToBrokerPayout(context)),
                SettingsRow(
                    icon: Icons.notifications_none,
                    label: AppLocalizations.of(context).notificationsLabel,
                    onTap: () => AppNavigation.goToNotifications(context)),
                SettingsRow(
                    icon: Icons.lock_outline,
                    label: 'Change Password',
                    onTap: () => AppNavigation.goToChangePassword(context)),
                SettingsRow(
                    icon: Icons.language,
                    label: AppLocalizations.of(context).languageLabel,
                    value: AppLocalizations.nativeLanguageName(Localizations.localeOf(context).languageCode),
                    onTap: () => AppNavigation.goToLanguage(context)),
                SettingsRow(
                    icon: Icons.attach_money,
                    label: 'Currency',
                    value: 'EGP',
                    valueColor: AppColors.navy,
                    onTap: () => AppNavigation.goToCurrency(context),
                    last: true),
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
        ),
      ),
    );
  }

  Widget _brokerCta(BuildContext context, String title, String sub,
          IconData icon, VoidCallback onTap, List<Color> colors) =>
      GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: colors),
              borderRadius: BorderRadius.circular(14)),
          child: Row(children: [
            Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, color: AppColors.gold, size: 20)),
            const SizedBox(width: 12),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(title,
                      style: AppTheme.dm(
                          size: 14,
                          weight: FontWeight.w700,
                          color: Colors.white)),
                  Text(sub,
                      style: AppTheme.dm(size: 11, color: AppColors.gold)),
                ])),
            const Icon(Icons.chevron_right, color: AppColors.gold),
          ]),
        ),
      );
}
