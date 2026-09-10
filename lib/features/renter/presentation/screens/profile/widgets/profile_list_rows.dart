import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sahely/core/navigation/app_navigation.dart';
import 'package:sahely/core/providers/currency_provider.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/l10n/app_localizations.dart';


class ProfileListRows extends StatelessWidget {
  final int walletBalance;
  final int reviewsGiven;
  final int reviewsReceived;

  const ProfileListRows({
    super.key,
    required this.walletBalance,
    required this.reviewsGiven,
    required this.reviewsReceived,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // Wallet & Credit
          _ListRow(
            icon: Icons.account_balance_wallet_outlined,
            label: AppLocalizations.of(context).walletCredit,
            trailing: Text(
              'EGP $walletBalance',
              style: AppTheme.dm(
                size: 14,
                weight: FontWeight.w600,
                color: AppColors.gold,
              ),
            ),
            onTap: () => AppNavigation.goToWallet(context),
          ),
          _Divider(),
          // My Reviews
          _ListRow(
            icon: Icons.star_outline,
            label: 'My Reviews',
            trailing: Text(
              '$reviewsGiven given · $reviewsReceived received',
              style: AppTheme.dm(
                size: 13,
                color: AppColors.secondary,
              ),
            ),
            onTap: () => AppNavigation.goToMyReviews(context),
          ),
          _Divider(),
          // Payment Methods
          _ListRow(
            icon: Icons.credit_card_outlined,
            label: AppLocalizations.of(context).paymentMethods,
            onTap: () => AppNavigation.goToAddCard(context),
          ),
          _Divider(),
          // Notifications
          _ListRow(
            icon: Icons.notifications_outlined,
            label: AppLocalizations.of(context).notificationsLabel,
            onTap: () => AppNavigation.goToNotifications(context),
          ),
          _Divider(),
          // Change Password
          _ListRow(
            icon: Icons.lock_outline,
            label: AppLocalizations.of(context).changePassword,
            onTap: () => AppNavigation.goToChangePassword(context),
          ),
          _Divider(),
          // Language
          _ListRow(
            icon: Icons.language,
            label: AppLocalizations.of(context).languageLabel,
            trailing: Text(
              AppLocalizations.nativeLanguageName(
                  Localizations.localeOf(context).languageCode),
              style: AppTheme.dm(
                size: 13,
                color: AppColors.secondary,
              ),
            ),
            onTap: () => AppNavigation.goToLanguage(context),
          ),
          _Divider(),
          // Currency
          _ListRow(
            icon: Icons.help_outline,
            // Matching the gold icon in the image
            iconColor: AppColors.gold,
            label: AppLocalizations.of(context).currencyLabel,
            trailing: Text(
              context.watch<CurrencyProvider>().selectedCurrency,
              style: AppTheme.dm(
                size: 14,
                weight: FontWeight.w700,
                color: AppColors.navy,
              ),
            ),
            onTap: () => AppNavigation.goToCurrency(context),
          ),
        ],
      ),
    );
  }
}

class _ListRow extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String label;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _ListRow({
    required this.icon,
    this.iconColor,
    required this.label,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 20, color: iconColor ?? AppColors.gold),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: AppTheme.dm(
                  size: 14,
                  color: AppColors.dark,
                ),
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 8),
              trailing!,
            ],
            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right,
              size: 18,
              color: AppColors.navy,
            ),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      color: AppColors.border,
      indent: 0,
      endIndent: 0,
    );
  }
}
