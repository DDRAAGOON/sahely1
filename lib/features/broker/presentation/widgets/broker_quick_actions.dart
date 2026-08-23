import 'package:flutter/material.dart';
import 'package:sahely/core/navigation/app_navigation.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';

class BrokerQuickActions extends StatelessWidget {
  const BrokerQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _QuickActionButton(
              icon: Icons.account_balance_wallet,
              label: 'Wallet',
              onTap: () => AppNavigation.goToBrokerWallet(context),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _QuickActionButton(
              icon: Icons.grid_view,
              label: 'Portfolio',
              onTap: () => AppNavigation.goToBrokerPortfolio(context),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _QuickActionButton(
              icon: Icons.person_add,
              label: 'Refer',
              onTap: () => AppNavigation.goToBrokerRefer(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: AppColors.navy,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: AppColors.gold,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTheme.dm(
                size: 13,
                weight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}