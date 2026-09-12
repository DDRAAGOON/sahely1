import 'package:flutter/material.dart';

import 'package:sahely/core/di/service_locator.dart' show sl;
import 'package:sahely/core/navigation/app_navigation.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/kit.dart';
import 'package:sahely/features/broker/domain/entities/broker_wallet.dart';
import 'package:sahely/features/broker/domain/repositories/broker_repository.dart';
import 'package:sahely/l10n/app_localizations.dart';

import '../../../../../../core/utils/currency_formatter.dart';

/// The broker's commission wallet: balances and tier from `/broker/dashboard`
/// and `/broker/tier`, entries from `/broker/commissions`.
class BrokerWalletPage extends StatefulWidget {
  const BrokerWalletPage({super.key});

  @override
  State<BrokerWalletPage> createState() => _BrokerWalletPageState();
}

class _BrokerWalletPageState extends State<BrokerWalletPage> {
  int _activeTab = 0; // 0: This Month, 1: Last Month
  BrokerWallet? _wallet;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final wallet = await sl<BrokerRepository>().getBrokerWallet(0);
      if (mounted) setState(() => _wallet = wallet);
    } catch (_) {
      // Figures stay as "—".
    }
  }

  static const _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  /// `EGP 1,820` -> `1820`.
  static int _amount(String formatted) =>
      int.tryParse(formatted.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

  /// `18000` -> `18,000`.
  static String _grouped(int value) {
    final digits = value.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }

  static String _compact(double egp) => egp >= 1000
      ? '${(egp / 1000).toStringAsFixed(1)}k'
      : egp.round().toString();

  static String _rate(double rate) {
    final percent = rate <= 1 ? rate * 100 : rate;
    return percent == percent.roundToDouble()
        ? '${percent.round()}%'
        : '${percent.toStringAsFixed(1)}%';
  }

  List<BrokerCommission> _inMonth(int offset) {
    final now = DateTime.now();
    final month = DateTime(now.year, now.month + offset);
    return (_wallet?.commissions ?? const <BrokerCommission>[])
        .where((c) => c.date.year == month.year && c.date.month == month.month)
        .toList();
  }

  static BadgeKind _badge(String status) {
    final s = status.toLowerCase();
    if (s.contains('pend') || s.contains('hold')) return BadgeKind.orange;
    if (s.contains('revers') || s.contains('cancel')) return BadgeKind.gray;
    return BadgeKind.greenSoft;
  }

  @override
  Widget build(BuildContext context) {
    final wallet = _wallet;
    final rows = _inMonth(_activeTab == 0 ? 0 : -1);
    final earned = rows
        .where((c) => !c.status.toLowerCase().contains('revers'))
        .fold<int>(0, (sum, c) => sum + _amount(c.amount));
    final statCards = [
      StatCard(
          value: wallet == null ? '—' : _compact(earned.toDouble()),
          label: AppLocalizations.of(context).statEarnedMo),
      StatCard(
          value: wallet == null ? '—' : _compact(wallet.pendingBalance),
          label: AppLocalizations.of(context).statPending,
          valueColor: const Color(0xFFD2760A)),
      StatCard(
          value: wallet == null ? '—' : '${rows.length}',
          label: AppLocalizations.of(context).bookings),
    ];
    final commissions = rows.isEmpty
        ? <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                  _activeTab == 0
                      ? 'No commissions this month yet.'
                      : 'No commissions last month.',
                  style: AppTheme.dm(size: 13, color: AppColors.muted)),
            ),
          ]
        : [
            for (var i = 0; i < rows.length; i++)
              _commission(
                  rows[i].propertyName,
                  '${_months[rows[i].date.month - 1]} ${rows[i].date.day}',
                  '+${_grouped(_amount(rows[i].amount))}',
                  rows[i].status,
                  _badge(rows[i].status),
                  last: i == rows.length - 1),
          ];

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
          children: [
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Icon(Icons.chevron_left, color: AppColors.navy),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 16, bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                  color: Color(0xFFFEF4E8),
                  border: Border(
                      left: BorderSide(color: Color(0xFFd2760a), width: 3))),
              child: Row(children: [
                const Icon(Icons.warning_amber_rounded,
                    size: 18, color: Color(0xFFd2760a)),
                const SizedBox(width: 8),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(AppLocalizations.of(context).accountNotVerified,
                          style: AppTheme.dm(
                              size: 12,
                              weight: FontWeight.w600,
                              color: AppColors.navy)),
                      Text(AppLocalizations.of(context).addCardToWithdraw,
                          style: AppTheme.dm(
                              size: 11, color: const Color(0xFF8A6A1E))),
                    ])),
                GestureDetector(
                    onTap: () => AppNavigation.goToAddCard(context),
                    behavior: HitTestBehavior.opaque,
                    child: Text('Add Card →',
                        style: AppTheme.dm(
                            size: 12,
                            weight: FontWeight.w700,
                            color: const Color(0xFFD2760A)))),
              ]),
            ),
            Text('Commission Wallet',
                style: AppTheme.dm(
                    size: 22, weight: FontWeight.w700, color: AppColors.navy)),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [Color(0xFF22335A), AppColors.navy]),
                  borderRadius: BorderRadius.circular(16)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Available Balance',
                        style: AppTheme.dm(
                            size: 13, color: const Color(0xFFCDD4E0))),
                    const SizedBox(height: 6),
                    Text(
                        wallet == null
                            ? '—'
                            : CurrencyFormatter.format(
                                wallet.availableBalance.round()),
                        style: AppTheme.dm(
                            size: 30,
                            weight: FontWeight.w700,
                            color: AppColors.gold)),
                  ]),
            ),
            const SizedBox(height: 12),
            InfoNote(
                text:
                    'Commissions clear 48h after guest check-in. Pending balance: ${wallet == null ? '—' : CurrencyFormatter.format(wallet.pendingBalance.round())}.',
                icon: Icons.schedule),
            const SizedBox(height: 12),
            const Opacity(
                opacity: 0.4,
                child: GoldButton(
                    label: 'Withdraw to Bank',
                    color: Color(0xFFE2D1A6),
                    onTap: null)),
            const SizedBox(height: 6),
            Center(
                child: Text('Locked until your account is verified',
                    style: AppTheme.dm(size: 11, color: AppColors.muted))),
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
                      decoration: BoxDecoration(
                          color: AppColors.gold.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.star, color: AppColors.gold)),
                  const SizedBox(width: 12),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text(
                            wallet == null
                                ? '—'
                                : '${wallet.tierName} tier · ${_rate(wallet.commissionRate)} rate',
                            style: AppTheme.dm(
                                size: 13,
                                weight: FontWeight.w700,
                                color: AppColors.navy)),
                        Text('avg ${wallet?.avgPerBooking ?? '—'} per booking',
                            style:
                                AppTheme.dm(size: 11, color: AppColors.muted)),
                      ])),
                  Text(
                      wallet == null ? '' : '${wallet.toNextTier} to next tier',
                      style: AppTheme.dm(
                          size: 12,
                          weight: FontWeight.w600,
                          color: const Color(0xFF9A7A22))),
                ])),
            const SizedBox(height: 14),
            Text('Recent commissions',
                style: AppTheme.dm(
                    size: 13, weight: FontWeight.w700, color: AppColors.navy)),
            const SizedBox(height: 8),
            WhiteCard(child: Column(children: commissions)),
            const SizedBox(height: 10),
            Center(
                child: GestureDetector(
                    onTap: () => AppNavigation.goToBrokerHistory(context),
                    behavior: HitTestBehavior.opaque,
                    child: Text('View Full History →',
                        style: AppTheme.dm(
                            size: 13,
                            weight: FontWeight.w600,
                            color: AppColors.gold)))),
          ],
        ),
      ),
    );
  }

  Widget _commission(
          String name, String date, String amount, String badge, BadgeKind kind,
          {bool last = false}) =>
      Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: last
            ? null
            : const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFFF4EFE7)))),
        child: Row(children: [
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(name,
                    style: AppTheme.dm(size: 13, weight: FontWeight.w600)),
                Text(date,
                    style: AppTheme.dm(size: 11, color: AppColors.muted)),
              ])),
          Text(amount,
              style: AppTheme.dm(
                  size: 14, weight: FontWeight.w700, color: AppColors.success)),
          const SizedBox(width: 8),
          StatusBadge(badge, kind: kind),
        ]),
      );
}
