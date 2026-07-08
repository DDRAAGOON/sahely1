import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/providers/navigation_provider.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/widgets/kit.dart';

class BrokerDashboardPage extends StatelessWidget {
  const BrokerDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 120),
        children: [
          Row(children: [
            const AvatarCircle(size: 44, colors: [Color(0xFFC9A84C), Color(0xFF8A7330)]),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Good morning, Karim', style: AppTheme.dm(size: 18, weight: FontWeight.w700, color: AppColors.navy)),
              Text('Gold Broker · 4% rate', style: AppTheme.dm(size: 12, color: AppColors.muted)),
            ])),
          ]),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF2A3A64), Color(0xFF141D33)]), borderRadius: BorderRadius.circular(16)),
            child: Column(children: [
              Row(children: [
                Container(width: 38, height: 38, decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.star, color: AppColors.gold)),
                const SizedBox(width: 10),
                Text('Gold Tier', style: AppTheme.dm(size: 16, weight: FontWeight.w700, color: AppColors.gold)),
                const Spacer(),
                Text('45 to Elite', style: AppTheme.dm(size: 12, color: const Color(0xFF9FB0CF))),
              ]),
              const SizedBox(height: 12),
              ClipRRect(borderRadius: BorderRadius.circular(4), child: const LinearProgressIndicator(value: 0.55, minHeight: 8, backgroundColor: Colors.white24, valueColor: AlwaysStoppedAnimation(AppColors.gold))),
              const SizedBox(height: 14),
              Row(children: [
                _mini('55', 'Properties', Colors.white),
                _mini('312k', 'Total earned', Colors.white),
                _mini('18.2k', 'This month', AppColors.gold),
                _mini('5.4k', 'Pending', AppColors.goldBright),
              ]),
            ]),
          ),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: _actionTile(context, 'Wallet', Icons.account_balance_wallet_outlined, () => context.read<NavigationProvider>().setTab(3))),
            const SizedBox(width: 10),
            Expanded(child: _actionTile(context, 'Portfolio', Icons.pie_chart_outline, () => context.read<NavigationProvider>().setTab(2))),
            const SizedBox(width: 10),
            Expanded(child: _actionTile(context, 'Refer', Icons.group_add_outlined, () => Navigator.pushNamed(context, '/broker/refer'))),
          ]),
          const SizedBox(height: 12),
          const StatRow(cards: [StatCard(value: '18.2k', label: 'This Month'), StatCard(value: '312k', label: 'Total Earned'), StatCard(value: '51', label: 'Live Props')]),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/broker/referred'),
            child: WhiteCard(padding: const EdgeInsets.all(14), child: Row(children: [
              Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.cream, borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.grid_view_outlined, color: AppColors.navy)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Referred Properties', style: AppTheme.dm(size: 14, weight: FontWeight.w700, color: AppColors.navy)),
                Text('51 live · tap to view', style: AppTheme.dm(size: 12, color: AppColors.muted)),
              ])),
              const Icon(Icons.chevron_right, color: AppColors.faint),
            ])),
          ),
          const SizedBox(height: 18),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Top Referred Properties', style: AppTheme.dm(size: 18, weight: FontWeight.w600, color: AppColors.navy)),
            GestureDetector(onTap: () => Navigator.pushNamed(context, '/broker/portfolio'), child: Text('All 55', style: AppTheme.dm(size: 13, weight: FontWeight.w600, color: AppColors.gold))),
          ]),
          const SizedBox(height: 12),
          _topReferred(context, 'Palm Chalet', 'Owner: Layla M.', '86', '4,500', '+15.4k'),
          const SizedBox(height: 10),
          _topReferred(context, 'Dune House', 'Owner: Tarek S.', '54', '3,800', '+8.2k'),
        ],
      ),
    );
  }

  Widget _mini(String v, String l, Color c) => Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(v, style: AppTheme.dm(size: 15, weight: FontWeight.w700, color: c)),
        Text(l, style: AppTheme.dm(size: 9, color: const Color(0xFF9FB0CF))),
      ]));

  Widget _actionTile(BuildContext context, String label, IconData icon, VoidCallback onTap) => GestureDetector(
        onTap: onTap,
        child: Container(height: 72, decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(14)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, color: AppColors.gold, size: 22),
          const SizedBox(height: 6),
          Text(label, style: AppTheme.dm(size: 12, weight: FontWeight.w600, color: Colors.white)),
        ])),
      );

  Widget _topReferred(BuildContext context, String name, String owner, String days, String avg, String profit) => GestureDetector(
        onTap: () => Navigator.pushNamed(context, '/broker/referred-detail'),
        child: WhiteCard(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Text(name, style: AppTheme.dm(size: 14, weight: FontWeight.w700, color: AppColors.navy))),
            Text(owner, style: AppTheme.dm(size: 12, color: AppColors.muted)),
            const Icon(Icons.chevron_right, color: AppColors.faint),
          ]),
          const SizedBox(height: 10),
          Row(children: [
            _stat(days, 'days rented', AppColors.navy),
            _stat(avg, 'avg/night', AppColors.navy),
            _stat(profit, 'your profit', const Color(0xFF9A7A22)),
          ]),
        ])),
      );

  Widget _stat(String v, String l, Color c) => Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(v, style: AppTheme.dm(size: 15, weight: FontWeight.w700, color: c)),
        Text(l, style: AppTheme.dm(size: 10, color: AppColors.muted)),
      ]));
}
