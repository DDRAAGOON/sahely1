import 'package:flutter/material.dart';

import 'package:sahely/core/di/service_locator.dart' show sl;
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/kit.dart';
import 'package:sahely/features/broker/domain/entities/broker_wallet.dart';
import 'package:sahely/features/broker/domain/repositories/broker_repository.dart';

/// Commission history from `/broker/commissions`, this month and last month.
/// Payments the broker made as a guest are not part of the broker API, so
/// the Payments filter lists nothing.
class BrokerHistoryPage extends StatefulWidget {
  const BrokerHistoryPage({super.key});

  @override
  State<BrokerHistoryPage> createState() => _BrokerHistoryPageState();
}

class _BrokerHistoryPageState extends State<BrokerHistoryPage> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Commissions', 'Payments'];
  List<BrokerCommission> _commissions = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final wallet = await sl<BrokerRepository>().getBrokerWallet(0);
      if (mounted) setState(() => _commissions = wallet.commissions);
    } catch (_) {
      // The empty state says nothing was found.
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

  /// Commission rows for a month (0 = this month, -1 = last month).
  List<Map<String, dynamic>> _items(int monthOffset) {
    if (_selectedFilter == 'Payments') return const [];
    final now = DateTime.now();
    final month = DateTime(now.year, now.month + monthOffset);
    return [
      for (final c in _commissions.where(
          (c) => c.date.year == month.year && c.date.month == month.month))
        _row(c),
    ];
  }

  Map<String, dynamic> _row(BrokerCommission c) {
    final status = c.status.toLowerCase();
    final pending = status.contains('pend') || status.contains('hold');
    final reversed = status.contains('revers') || status.contains('cancel');
    final date = '${_months[c.date.month - 1]} ${c.date.day}';
    return {
      'title': 'Commission · ${c.propertyName}',
      'subtitle':
          pending ? '$date · Pending' : (reversed ? '$date · Reversed' : date),
      'amount': '${reversed ? '−' : '+'}${_grouped(_amount(c.amount))}',
      'color': reversed
          ? const Color(0xFFB22222)
          : (pending ? AppColors.navy : AppColors.success),
      'pending': pending,
    };
  }

  @override
  Widget build(BuildContext context) {
    final thisMonth = _items(0);
    final lastMonth = _items(-1);

    Widget section(List<Map<String, dynamic>> items) => WhiteCard(
          child: Column(
            children: List.generate(items.length, (index) {
              final item = items[index];
              return _brk(
                item['title'],
                item['subtitle'],
                item['amount'],
                item['color'],
                pending: item['pending'] ?? false,
                last: index == items.length - 1,
              );
            }),
          ),
        );

    return PhoneScaffold(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        children: [
          const TopBar(title: 'History', subtitle: 'Commissions · Payments'),
          const SizedBox(height: 14),
          SizedBox(
            height: 32,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final filter = _filters[index];
                final isActive = _selectedFilter == filter;
                return GestureDetector(
                  onTap: () => setState(() => _selectedFilter = filter),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isActive ? AppColors.navy : AppColors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Text(
                      filter,
                      style: AppTheme.dm(
                        size: 12,
                        weight: FontWeight.w600,
                        color: isActive ? Colors.white : AppColors.navy,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          if (thisMonth.isNotEmpty) ...[
            const SectionLabel('THIS MONTH'),
            const SizedBox(height: 8),
            section(thisMonth),
            const SizedBox(height: 16),
          ],
          if (lastMonth.isNotEmpty) ...[
            const SectionLabel('LAST MONTH'),
            const SizedBox(height: 8),
            section(lastMonth),
          ],
          if (thisMonth.isEmpty && lastMonth.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Center(
                child: Text('No transactions found for $_selectedFilter',
                    style: AppTheme.dm(size: 14, color: AppColors.muted)),
              ),
            ),
          const SizedBox(height: 14),
          Center(
            child: Text(
              'Broker view — commissions & your own bookings appear here.',
              style: AppTheme.dm(size: 11, color: AppColors.muted),
            ),
          ),
        ],
      ),
    );
  }

  Widget _brk(String title, String sub, String amount, Color color,
          {bool pending = false, bool last = false}) =>
      Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: last
            ? null
            : const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFFF4EFE7)))),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: AppTheme.dm(size: 13, weight: FontWeight.w600)),
                  Text(
                    sub,
                    style: AppTheme.dm(
                      size: 11,
                      color:
                          pending ? const Color(0xFFD2760A) : AppColors.muted,
                    ),
                  ),
                ],
              ),
            ),
            Text(amount,
                style: AppTheme.dm(
                    size: 14, weight: FontWeight.w700, color: color)),
          ],
        ),
      );
}
