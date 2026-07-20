import 'package:flutter/material.dart';
import 'package:sahely/core/navigation/app_navigation.dart';
import 'package:sahely/core/navigation/app_routes.dart';

import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/widgets/kit.dart';

class BrokerDashboardPage extends StatelessWidget {
  const BrokerDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 120),
          children: [
            // 1. Header
            Row(children: [
              const AvatarCircle(
                  size: 44, colors: [Color(0xFFC9A84C), Color(0xFF8A7330)]),
              const SizedBox(width: 12),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text('Good morning, Karim',
                        style: AppTheme.dm(
                            size: 18,
                            weight: FontWeight.w700,
                            color: AppColors.navy)),
                    Text('Gold Broker · 4% rate',
                        style: AppTheme.dm(size: 12, color: AppColors.muted)),
                  ])),
            ]),
            const SizedBox(height: 14),

            // 2. Tier Card
            GestureDetector(
              onTap: () => AppNavigation.goToBrokerTier(context),
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [Color(0xFF2A3A64), Color(0xFF141D33)]),
                    borderRadius: BorderRadius.circular(16)),
                child: Column(children: [
                  Row(children: [
                    Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                            color: AppColors.gold.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.home_outlined, color: AppColors.gold, size: 20)),
                    const SizedBox(width: 10),
                    Text('Gold Tier',
                        style: AppTheme.dm(
                            size: 16,
                            weight: FontWeight.w700,
                            color: AppColors.gold)),
                    const Spacer(),
                    Text('45 to Elite',
                        style:
                            AppTheme.dm(size: 11, color: const Color(0xFF9FB0CF))),
                  ]),
                  const SizedBox(height: 12),
                  ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: const LinearProgressIndicator(
                          value: 0.55,
                          minHeight: 6,
                          backgroundColor: Colors.white24,
                          valueColor: AlwaysStoppedAnimation(AppColors.gold))),
                  const SizedBox(height: 14),
                  Row(children: [
                    _miniStat('55', 'Properties', Colors.white),
                    _miniStat('312k', 'Total earned', Colors.white),
                    _miniStat('18.2k', 'This month', AppColors.gold),
                    _miniStat('5.4k', 'Pending', AppColors.goldBright),
                  ]),
                ]),
              ),
            ),
            const SizedBox(height: 12),

            // 3. Main Action Tiles
            Row(children: [
              Expanded(
                  child: _actionTile(
                      context,
                      'Wallet',
                      Icons.account_balance_wallet_outlined,
                      () => AppNavigation.goToBrokerHistory(context))),
              const SizedBox(width: 10),
              Expanded(
                  child: _actionTile(
                      context,
                      'Portfolio',
                      Icons.grid_view_outlined,
                      () => AppNavigation.goToBrokerPortfolio(context))),
              const SizedBox(width: 10),
              Expanded(
                  child: _actionTile(context, 'Refer', Icons.person_add_outlined,
                      () => AppNavigation.goToBrokerRefer(context))),
            ]),
            const SizedBox(height: 12),

            // 4. White Stats Row
            Row(children: [
              Expanded(child: _whiteStat(context, 'This Month', '18.2k', () => AppNavigation.goToBrokerHistory(context))),
              const SizedBox(width: 10),
              Expanded(child: _whiteStat(context, 'Total Earned', '312k', () => AppNavigation.goToBrokerHistory(context))),
              const SizedBox(width: 10),
              Expanded(child: _whiteStat(context, 'Live Props', '51', () => AppNavigation.goToBrokerPortfolio(context))),
            ]),
            const SizedBox(height: 12),

            // 5. Referred Properties Link
            GestureDetector(
              onTap: () => AppNavigation.goToBrokerPortfolio(context),
              behavior: HitTestBehavior.opaque,
              child: WhiteCard(
                  padding: const EdgeInsets.all(14),
                  child: Row(children: [
                    Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            color: AppColors.cream,
                            borderRadius: BorderRadius.circular(12)),
                        child: const Icon(Icons.grid_view_outlined,
                            color: AppColors.navy, size: 20)),
                    const SizedBox(width: 12),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Text('Referred Properties',
                              style: AppTheme.dm(
                                  size: 14,
                                  weight: FontWeight.w700,
                                  color: AppColors.navy)),
                          Text('51 live · tap to view',
                              style:
                                  AppTheme.dm(size: 12, color: AppColors.muted)),
                        ])),
                    const Icon(Icons.chevron_right, color: AppColors.faint, size: 18),
                  ])),
            ),
            const SizedBox(height: 24),

            // 6. Upcoming Check-ins
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Upcoming Check-ins',
                  style: AppTheme.dm(
                      size: 18, weight: FontWeight.w700, color: AppColors.navy)),
              GestureDetector(
                onTap: () => AppNavigation.goToBrokerBookings(context),
                child: Text('See all',
                    style: AppTheme.dm(
                        size: 13,
                        weight: FontWeight.w600,
                        color: AppColors.gold)),
              ),
            ]),
            const SizedBox(height: 12),
            _checkInItem(context, 'Palm Chalet', 'Nour A. · Jun 19 · 4 nights', 'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=200', '+960'),
            const SizedBox(height: 10),
            _checkInItem(context, 'Dune House', 'Sara M. · Jun 22 · 3 nights', 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=200', '+720'),

            const SizedBox(height: 24),

            // 7. Top Referred Properties
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Top Referred Properties',
                  style: AppTheme.dm(
                      size: 18, weight: FontWeight.w700, color: AppColors.navy)),
              GestureDetector(
                onTap: () => AppNavigation.goToBrokerPortfolio(context),
                child: Text('All 55',
                    style: AppTheme.dm(
                        size: 13,
                        weight: FontWeight.w600,
                        color: AppColors.gold)),
              ),
            ]),
            const SizedBox(height: 12),
            _topPropertyItem(context, 'Palm Chalet', 'Owner: Layla M.', '86', '4,500', '+15.4k'),
            const SizedBox(height: 10),
            _topPropertyItem(context, 'Dune House', 'Owner: Tarek S.', '54', '3,800', '+8.2k'),
          ],
        ),
      ),
    );
  }

  Widget _miniStat(String v, String l, Color c) => Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Text(v,
            style: AppTheme.dm(size: 16, weight: FontWeight.w700, color: c)),
        const SizedBox(height: 2),
        Text(l, style: AppTheme.dm(size: 9, color: const Color(0xFF9FB0CF))),
      ]));

  Widget _actionTile(BuildContext context, String label, IconData icon,
          VoidCallback onTap) =>
      GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
            height: 76,
            decoration: BoxDecoration(
                color: AppColors.navy, borderRadius: BorderRadius.circular(14)),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(icon, color: AppColors.gold, size: 22),
              const SizedBox(height: 6),
              Text(label,
                  style: AppTheme.dm(
                      size: 12, weight: FontWeight.w700, color: Colors.white)),
            ])),
      );

  Widget _whiteStat(BuildContext context, String l, String v, VoidCallback onTap) => Expanded(
    child: GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l, style: AppTheme.dm(size: 10, color: AppColors.muted)),
            const SizedBox(height: 4),
            Text(v, style: AppTheme.dm(size: 16, weight: FontWeight.w700, color: AppColors.navy)),
          ],
        ),
      ),
    ),
  );

  Widget _checkInItem(BuildContext context, String name, String meta, String img, String margin) => GestureDetector(
    onTap: () => AppNavigation.goToBrokerBookings(context),
    behavior: HitTestBehavior.opaque,
    child: WhiteCard(
      padding: const EdgeInsets.all(12),
      child: Row(children: [
        ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.network(img, width: 44, height: 44, fit: BoxFit.cover)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(name, style: AppTheme.dm(size: 14, weight: FontWeight.w700, color: AppColors.navy)),
          Text(meta, style: AppTheme.dm(size: 12, color: AppColors.muted)),
        ])),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(margin, style: AppTheme.dm(size: 14, weight: FontWeight.w700, color: AppColors.success)),
          Text('your margin', style: AppTheme.dm(size: 10, color: AppColors.muted)),
        ]),
      ]),
    ),
  );

  Widget _topPropertyItem(BuildContext context, String name, String owner, String days, String avg, String profit) => GestureDetector(
        onTap: () => AppNavigation.goToBrokerReferredDetail(context),
        behavior: HitTestBehavior.opaque,
        child: WhiteCard(
            padding: const EdgeInsets.all(14),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(
                    child: Text(name,
                        style: AppTheme.dm(
                            size: 14,
                            weight: FontWeight.w700,
                            color: AppColors.navy))),
                Text(owner,
                    style: AppTheme.dm(size: 12, color: AppColors.muted)),
                const Icon(Icons.chevron_right, color: AppColors.faint, size: 16),
              ]),
              const SizedBox(height: 10),
              Row(children: [
                _stat(days, 'days rented', AppColors.navy),
                _stat(avg, 'avg/night', AppColors.navy),
                _stat(profit, 'your profit', const Color(0xFF9A7A22)),
              ]),
            ])),
      );

  Widget _stat(String v, String l, Color c) => Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(v,
            style: AppTheme.dm(size: 15, weight: FontWeight.w700, color: c)),
        Text(l, style: AppTheme.dm(size: 10, color: AppColors.muted)),
      ]));
}
