import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/floating_nav.dart';
import '../../../widgets/kit.dart';
import '../../../widgets/ui.dart';
import '../../../widgets/cream_background.dart';
import '../broker_nav.dart';

class CommissionWalletScreen extends StatefulWidget {
  const CommissionWalletScreen({super.key});

  @override
  State<CommissionWalletScreen> createState() => _CommissionWalletScreenState();
}

class _CommissionWalletScreenState extends State<CommissionWalletScreen> {
  int _activeTab = 0; // 0: This Month, 1: Last Month

  @override
  Widget build(BuildContext context) {
    List<StatCard> statCards = const [
      StatCard(value: '18.2k', label: 'Earned (mo)'),
      StatCard(value: '5.4k', label: 'Pending', valueColor: Color(0xFFD2760A)),
      StatCard(value: '14', label: 'Bookings')
    ];
    List<Widget> commissions = [];

    if (_activeTab == 0) {
      statCards = const [
        StatCard(value: '18.2k', label: 'Earned (mo)'),
        StatCard(value: '5.4k', label: 'Pending', valueColor: Color(0xFFD2760A)),
        StatCard(value: '14', label: 'Bookings')
      ];
      commissions = [
        _commission('Palm Chalet', 'Jun 12', '+1,820', 'Paid', BadgeKind.greenSoft),
        _commission('Dune House', 'Jun 9', '+960', 'Pending', BadgeKind.orange, last: true),
      ];
    } else {
      statCards = const [
        StatCard(value: '15.6k', label: 'Earned (mo)'),
        StatCard(value: '0.0k', label: 'Pending', valueColor: Color(0xFFD2760A)),
        StatCard(value: '12', label: 'Bookings')
      ];
      commissions = [
        _commission('Marina Loft', 'May 24', '+1,450', 'Paid', BadgeKind.greenSoft),
        _commission('Sunny Villa', 'May 15', '+2,100', 'Paid', BadgeKind.greenSoft, last: true),
      ];
    }

    return PhoneScaffold(
      child: Stack(children: [
        ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8, bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                  color: Color(0xFFFEF4E8), border: Border(left: BorderSide(color: Color(0xFFD2760A), width: 3))),
              child: Row(children: [
                const Icon(Icons.warning_amber_rounded, size: 18, color: Color(0xFFD2760A)),
                const SizedBox(width: 8),
                Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Account not verified',
                      style: AppTheme.dm(size: 12, weight: FontWeight.w600, color: AppColors.navy)),
                  Text('Add your card to withdraw earnings', style: AppTheme.dm(size: 11, color: const Color(0xFF8A6A1E))),
                ])),
                GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/add-card'),
                    child: Text('Add Card →',
                        style: AppTheme.dm(size: 12, weight: FontWeight.w700, color: const Color(0xFFD2760A)))),
              ]),
            ),
            Text('Commission Wallet', style: AppTheme.dm(size: 22, weight: FontWeight.w700, color: AppColors.navy)),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF22335A), AppColors.navy]),
                  borderRadius: BorderRadius.circular(16)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Available Balance', style: AppTheme.dm(size: 13, color: const Color(0xFFCDD4E0))),
                const SizedBox(height: 6),
                Text('EGP 12,840', style: AppTheme.dm(size: 30, weight: FontWeight.w700, color: AppColors.gold)),
              ]),
            ),
            const SizedBox(height: 12),
            const InfoNote(
                text: 'Commissions clear 48h after guest check-in. Pending balance: EGP 5,400.', icon: Icons.schedule),
            const SizedBox(height: 12),
            const Opacity(opacity: 0.4, child: GoldButton(label: 'Withdraw to Bank')),
            const SizedBox(height: 6),
            Center(child: Text('Locked until your account is verified', style: AppTheme.dm(size: 11, color: AppColors.muted))),
            const SizedBox(height: 14),
            SizedBox(
              height: 36,
              child: SegmentTabs(
                tabs: const ['This Month', 'Last Month'],
                active: _activeTab,
                onTap: (index) {
                  setState(() {
                    _activeTab = index;
                  });
                },
              ),
            ),
            const SizedBox(height: 12),
            StatRow(cards: statCards),
            const SizedBox(height: 12),
            WhiteCard(
                padding: const EdgeInsets.all(14),
                child: Row(children: [
                  Container(
                      width: 38,
                      height: 38,
                      decoration:
                          BoxDecoration(color: AppColors.gold.withValues(alpha: 0.18), borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.star, color: AppColors.gold)),
                  const SizedBox(width: 12),
                  Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Gold tier · 4% rate',
                        style: AppTheme.dm(size: 13, weight: FontWeight.w700, color: AppColors.navy)),
                    Text('avg EGP 1,300 per booking', style: AppTheme.dm(size: 11, color: AppColors.muted)),
                  ])),
                  const Text('45 to Elite',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF9A7A22))),
                ])),
            const SizedBox(height: 14),
            Text('Recent commissions', style: AppTheme.dm(size: 13, weight: FontWeight.w700, color: AppColors.navy)),
            const SizedBox(height: 8),
            WhiteCard(child: Column(children: commissions)),
            const SizedBox(height: 10),
            Center(
                child: GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/broker/history'),
                    child: Text('View Full History →', style: AppTheme.dm(size: 13, weight: FontWeight.w600, color: AppColors.gold)))),
          ],
        ),
        FloatingNav(active: 3, items: FloatingNav.brokerTabs, onTap: (i, _) => brokerNav(context, i)),
      ]),
    );
  }

  Widget _commission(String name, String date, String amount, String badge, BadgeKind kind, {bool last = false}) => Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: last ? null : const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFF4EFE7)))),
        child: Row(children: [
          Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(name, style: AppTheme.dm(size: 13, weight: FontWeight.w600)),
            Text(date, style: AppTheme.dm(size: 11, color: AppColors.muted)),
          ])),
          Text(amount, style: AppTheme.dm(size: 14, weight: FontWeight.w700, color: AppColors.success)),
          const SizedBox(width: 8),
          StatusBadge(badge, kind: kind),
        ]),
      );
}
