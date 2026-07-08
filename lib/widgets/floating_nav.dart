import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/models.dart';
import '../data/role_state.dart';

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

  static const renterTabs = [
    NavItem(Icons.home_outlined, Icons.home, 'Home', '/renter/home'),
    NavItem(Icons.favorite_border, Icons.favorite, 'Wishlist', '/wishlist'),
    NavItem(Icons.calendar_today_outlined, Icons.calendar_today, 'Bookings', '/bookings'),
    NavItem(Icons.room_service_outlined, Icons.room_service, 'Services', '/services'),
    NavItem(Icons.person_outline, Icons.person, 'Manage', '/renter/profile'),
  ];

  static const ownerTabs = [
    NavItem(Icons.home_outlined, Icons.home, 'Home', '/owner/home'),
    NavItem(Icons.favorite_border, Icons.favorite, 'Wishlist', '/wishlist'),
    NavItem(Icons.calendar_today_outlined, Icons.calendar_today, 'Bookings', '/owner/bookings'),
    NavItem(Icons.notifications_none, Icons.notifications, 'Services', '/services'),
    NavItem(Icons.dashboard_outlined, Icons.dashboard, 'Manage', '/owner/profile'),
  ];

  static const brokerTabs = [
    NavItem(Icons.home_outlined, Icons.home, 'Home', '/broker/home'),
    NavItem(Icons.workspace_premium_outlined, Icons.workspace_premium, 'My Role', '/broker/dashboard'),
    NavItem(Icons.apartment_outlined, Icons.apartment, 'Referrals', '/broker/referred'),
    NavItem(Icons.account_balance_wallet_outlined, Icons.account_balance_wallet, 'Wallet', '/broker/wallet'),
    NavItem(Icons.person_outline, Icons.person, 'Profile', '/broker/profile'),
  ];

  static const _activeBlue = Color(0xFF3A7BD5);

  void _defaultOnTap(BuildContext context, int index, NavItem item) {
    if (item.route != null) {
      final currentRoute = ModalRoute.of(context)?.settings.name;
      if (currentRoute == item.route) return;

      if (index == 0) {
        Navigator.popUntil(context, (r) => r.isFirst);
      } else {
        Navigator.pushNamedAndRemoveUntil(
          context, 
          item.route!, 
          (route) => route.isFirst,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final role = RoleState().currentRole;
    final displayItems = items ?? (role == Role.owner ? ownerTabs : (role == Role.broker ? brokerTabs : renterTabs));

    return Positioned(
      left: 16,
      right: 16,
      bottom: 14,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(34),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF18223C).withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(34),
              border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
              boxShadow: const [BoxShadow(color: Color(0x52141C32), blurRadius: 20, offset: Offset(0, 10))],
            ),
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
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({required this.item, required this.selected, required this.onTap});
  final NavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? FloatingNav._activeBlue : Colors.white.withValues(alpha: 0.5);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(selected ? item.activeIcon : item.icon, size: 23, color: color),
          const SizedBox(height: 4),
          Text(item.label, style: AppTheme.dm(size: 11, weight: FontWeight.w500, color: color)),
        ],
      ),
    );
  }
}
