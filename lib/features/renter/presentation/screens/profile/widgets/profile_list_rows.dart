import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/providers/currency_provider.dart';
import 'package:sahely/core/providers/locale_provider.dart';
import '../../../verification/pages/add_payment_card_screen.dart';
import '../../reviews/pages/my_reviews_screen.dart';
import '../../wallet/pages/wallet_screen.dart';
import '../pages/language_selection_screen.dart';
import '../pages/currency_selector_sheet.dart';
import '../pages/change_password_screen.dart';
import '../pages/notification_settings_screen.dart';

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
            label: 'Wallet & Credit',
            trailing: Text(
              'EGP $walletBalance',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.gold,
                fontFamily: 'Cairo',
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const WalletScreen(),
                ),
              );
            },
          ),
          _Divider(),
          // My Reviews
          _ListRow(
            icon: Icons.star_outline,
            label: 'My Reviews',
            trailing: Text(
              '$reviewsGiven given · $reviewsReceived received',
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.secondary,
                fontFamily: 'Cairo',
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyReviewsScreen(),
                ),
              );
            },
          ),
          _Divider(),
          // Payment Methods
          _ListRow(
            icon: Icons.credit_card_outlined,
            label: 'Payment Methods',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddPaymentCardScreen(),
                ),
              );
            },
          ),
          _Divider(),
          // Notifications
          _ListRow(
            icon: Icons.notifications_outlined,
            label: 'Notifications',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationSettingsScreen(),
                ),
              );
            },
          ),
          _Divider(),
          // Change Password
          _ListRow(
            icon: Icons.lock_outline,
            label: 'Change Password',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChangePasswordScreen(),
                ),
              );
            },
          ),
          _Divider(),
          // Language
          _ListRow(
            icon: Icons.language,
            label: 'Language',
            trailing: Text(
              context.watch<LocaleProvider>().locale.languageCode == 'ar' ? 'العربية' : 'English',
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.secondary,
                fontFamily: 'Cairo',
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LanguageSelectionScreen(),
                ),
              );
            },
          ),
          _Divider(),
          // Currency
          _ListRow(
            icon: Icons.help_outline, // Matching the gold icon in the image
            iconColor: AppColors.gold,
            label: 'Currency',
            trailing: Text(
              context.watch<CurrencyProvider>().selectedCurrency,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.navy,
                fontFamily: 'Cairo',
              ),
            ),
            onTap: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                builder: (context) => const CurrencySelectorSheet(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ListRow extends StatelessWidget {
  final IconData icon;
  final Color? iconColor; // Added iconColor to match the image
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
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.dark,
                  fontFamily: 'Cairo',
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
              color: AppColors.secondary,
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
