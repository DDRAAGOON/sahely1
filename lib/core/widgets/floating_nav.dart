import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:sahely/data/models.dart';
import 'package:sahely/data/role_state.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/bouncy_button.dart';
import 'package:sahely/l10n/app_localizations.dart';

class NavItem {
  const NavItem(this.icon, this.activeIcon, this.label, [this.route]);

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String? route;
}

/// The translucent, blurred "floating island" bottom nav from the design —
/// 64px tall, inset 16px, 34px radius, frosted navy glass.
class FloatingNav extends StatelessWidget {
  const FloatingNav({super.key, required this.active, this.items, this.onTap});

  final int active;
  final List<NavItem>? items;
  final void Function(int index, NavItem item)? onTap;

  static List<NavItem> renterTabs(AppLocalizations l) => [
        NavItem(Icons.home_outlined, Icons.home, l.navHome, '/renter/home'),
        NavItem(Icons.favorite_border, Icons.favorite, l.navWishlist,
            '/renter/wishlist'),
        NavItem(Icons.calendar_today_outlined, Icons.calendar_today,
            l.navBookings, '/renter/bookings'),
        NavItem(Icons.room_service_outlined, Icons.room_service, l.navServices,
            '/renter/services'),
        NavItem(Icons.person_outline, Icons.person, l.navProfile,
            '/renter/profile'),
      ];

  static List<NavItem> ownerTabs(AppLocalizations l) => [
        NavItem(Icons.home_outlined, Icons.home, l.navHome, '/owner/home'),
        NavItem(Icons.favorite_border, Icons.favorite, l.navWishlist,
            '/owner/wishlist'),
        NavItem(Icons.calendar_today_outlined, Icons.calendar_today,
            l.navBookings, '/owner/bookings'),
        NavItem(Icons.room_service_outlined, Icons.room_service, l.navServices,
            '/owner/services'),
        NavItem(
            Icons.person_outline, Icons.person, l.navManage, '/owner/profile'),
      ];

  static List<NavItem> brokerTabs(AppLocalizations l) => [
        NavItem(Icons.home_outlined, Icons.home, l.navHome, '/broker/home'),
        NavItem(Icons.workspace_premium_outlined, Icons.workspace_premium,
            l.navMyRole, '/broker/dashboard'),
        NavItem(Icons.apartment_outlined, Icons.apartment, l.navReferrals,
            '/broker/referred'),
        NavItem(Icons.account_balance_wallet_outlined,
            Icons.account_balance_wallet, l.navWallet, '/broker/wallet'),
        NavItem(Icons.person_outline, Icons.person, l.navProfile,
            '/broker/profile'),
      ];

  void _defaultOnTap(BuildContext context, int index, NavItem item) {
    if (item.route != null) {
      context.go(item.route!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final role = RoleState().currentRole;
    final l = AppLocalizations.of(context);
    final displayItems = items ??
        (role == Role.owner
            ? ownerTabs(l)
            : (role == Role.broker ? brokerTabs(l) : renterTabs(l)));

    return Positioned(
      left: 14,
      right: 14,
      bottom: 12,
      // On tablets / desktop keep the island phone-sized and centered
      // instead of stretching edge-to-edge.
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Container(
            height: 62,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.62),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2), width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 30,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    for (var i = 0; i < displayItems.length; i++)
                      _NavButton(
                        item: displayItems[i],
                        selected: i == active,
                        onTap: () => (onTap != null)
                            ? onTap!(i, displayItems[i])
                            : _defaultOnTap(context, i, displayItems[i]),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton(
      {required this.item, required this.selected, required this.onTap});

  final NavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return BouncyButton(
      onTap: onTap,
      scale: 0.9,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            selected ? item.activeIcon : item.icon,
            size: 23,
            color: selected
                ? AppColors.navy
                : AppColors.navy.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 4),
          Text(
            item.label,
            style: AppTheme.dm(
              size: 11,
              weight: FontWeight.w600,
              color: selected
                  ? AppColors.navy
                  : AppColors.navy.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }
}
