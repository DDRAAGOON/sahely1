import 'package:flutter/material.dart';
import 'package:sahely/core/navigation/app_navigation.dart';

import 'package:sahely/core/di/service_locator.dart' show sl;
import 'package:sahely/core/network/api_envelope.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/utils/currency_formatter.dart';
import 'package:sahely/core/widgets/kit.dart';
import 'package:sahely/features/shared/violations/data/violations_api_data_source.dart';
import 'package:sahely/features/wallet/data/datasources/wallet_remote_data_source.dart';

const _months = [
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

String _shortDate(DateTime d) => '${_months[d.month - 1]} ${d.day}';

/// `18000` -> `18,000`.
String _grouped(int value) {
  final digits = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
    buffer.write(digits[i]);
  }
  return buffer.toString();
}

/// `property_damage` -> `Property damage`.
String _humanize(String value) {
  final text = value.replaceAll('_', ' ').trim();
  return text.isEmpty
      ? ''
      : text[0].toUpperCase() + text.substring(1).toLowerCase();
}

bool _isClosed(Map<String, dynamic> violation) {
  final s = '${violation['status'] ?? ''}'.toLowerCase();
  return s.contains('resolv') ||
      s.contains('clos') ||
      s.contains('clear') ||
      s.contains('dismiss') ||
      s.contains('reject');
}

/// A violation's deduction in EGP, whichever field the API filled.
double _deductionEgp(Map<String, dynamic> v) =>
    (asNum(pick(v, 'deduction_piastres')) ??
        asNum(pick(v, 'fine_piastres')) ??
        asNum(pick(v, 'amount_piastres')) ??
        0) /
    100;

String _violationTitle(Map<String, dynamic> v) {
  final title =
      _humanize('${v['type'] ?? v['violation_type'] ?? v['category'] ?? ''}');
  return title.isEmpty ? 'Violation' : title;
}

/// Wallet entries and violations of the owner for a period (`Month`,
/// `Quarter` or `Year`): the current one and the one before it.
class OwnerHistoryScreen extends StatefulWidget {
  final String? period;

  const OwnerHistoryScreen({super.key, this.period});

  @override
  State<OwnerHistoryScreen> createState() => _OwnerHistoryScreenState();
}

class _OwnerHistoryScreenState extends State<OwnerHistoryScreen> {
  String _selectedFilter = 'All';
  List<Map<String, dynamic>> _transactions = const [];
  List<Map<String, dynamic>> _violations = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final transactions =
        await sl<WalletRemoteDataSource>().getOwnerTransactions(limit: 100);
    var violations = const <Map<String, dynamic>>[];
    try {
      violations = await sl<ViolationsApiDataSource>().mine();
    } catch (_) {}
    if (!mounted) return;
    setState(() {
      transactions.fold((_) {}, (t) => _transactions = t);
      _violations = violations;
    });
  }

  /// Start of the current period and of the one before it.
  (DateTime, DateTime) _range(String period) {
    final now = DateTime.now();
    switch (period) {
      case 'Quarter':
        final first = ((now.month - 1) ~/ 3) * 3 + 1;
        return (DateTime(now.year, first), DateTime(now.year, first - 3));
      case 'Year':
        return (DateTime(now.year), DateTime(now.year - 1));
      default:
        return (
          DateTime(now.year, now.month),
          DateTime(now.year, now.month - 1)
        );
    }
  }

  /// One row per wallet entry or violation, newest first.
  List<
      ({
        String kind,
        DateTime at,
        String title,
        String sub,
        String amount,
        Color color,
        bool pending
      })> _entries() {
    final entries = <({
      String kind,
      DateTime at,
      String title,
      String sub,
      String amount,
      Color color,
      bool pending
    })>[];
    for (final t in _transactions) {
      final at = asDate(pick(t, 'created_at'));
      if (at == null) continue;
      final credit = '${t['type'] ?? ''}'.toLowerCase() != 'debit';
      final description = '${t['description'] ?? ''}'.trim();
      final pending = description.toLowerCase().contains('pending');
      final amount =
          _grouped(((asNum(t['amount'])?.toDouble() ?? 0) / 100).round());
      entries.add((
        kind: credit ? 'Payouts' : 'Payments',
        at: at,
        title: description.isNotEmpty
            ? description
            : (credit ? 'Payout' : _humanize('${t['category'] ?? 'Payment'}')),
        sub:
            '${_shortDate(at)} · ${credit ? (pending ? 'Pending' : 'Paid') : 'To bank'}',
        amount: '${credit ? '+' : '−'}$amount',
        color: credit
            ? (pending ? AppColors.navy : AppColors.success)
            : const Color(0xFFB22222),
        pending: pending,
      ));
    }
    for (final v in _violations) {
      final at = asDate(pick(v, 'created_at'));
      if (at == null) continue;
      final deduction = _deductionEgp(v);
      entries.add((
        kind: 'Violations',
        at: at,
        title: _violationTitle(v),
        sub: '${_shortDate(at)} · Violation',
        amount: deduction > 0 ? '−${_grouped(deduction.round())}' : '',
        color: const Color(0xFFB22222),
        pending: false,
      ));
    }
    entries.sort((a, b) => b.at.compareTo(a.at));
    return entries;
  }

  @override
  Widget build(BuildContext context) {
    final periodArg = widget.period ?? 'Month';
    final periodLabel = periodArg == 'Month'
        ? 'MONTH'
        : (periodArg == 'Quarter' ? 'QUARTER' : 'YEAR');
    final (start, previousStart) = _range(periodArg);
    final visible = _entries()
        .where((e) => _selectedFilter == 'All' || e.kind == _selectedFilter)
        .toList();
    final current = visible.where((e) => !e.at.isBefore(start)).toList();
    final previous = visible
        .where((e) => !e.at.isBefore(previousStart) && e.at.isBefore(start))
        .toList();

    Widget section(
        List<
                ({
                  String kind,
                  DateTime at,
                  String title,
                  String sub,
                  String amount,
                  Color color,
                  bool pending
                })>
            rows) {
      if (rows.isEmpty) {
        return WhiteCard(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text('Nothing in this period.',
                style: AppTheme.dm(size: 13, color: AppColors.muted)),
          ),
        );
      }
      return WhiteCard(
        child: Column(children: [
          for (var i = 0; i < rows.length; i++)
            _hist(rows[i].title, rows[i].sub, rows[i].amount, rows[i].color,
                pending: rows[i].pending, last: i == rows.length - 1),
        ]),
      );
    }

    return PhoneScaffold(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        children: [
          TopBar(
              title: 'History',
              subtitle: 'Payouts · Payments · $periodArg History'),
          const SizedBox(height: 14),
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              children: [
                for (final f in [
                  'All',
                  'Payouts',
                  'Payments',
                  'Violations'
                ]) ...[
                  ChoiceChipPill(
                    f,
                    selected: _selectedFilter == f,
                    height: 36,
                    horizontalPadding: 16,
                    onTap: () => setState(() => _selectedFilter = f),
                  ),
                  const SizedBox(width: 8),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          SectionLabel('THIS $periodLabel'),
          const SizedBox(height: 8),
          section(current),
          const SizedBox(height: 16),
          SectionLabel('LAST $periodLabel'),
          const SizedBox(height: 8),
          section(previous),
          const SizedBox(height: 14),
          Center(
            child: Text(
              'Owner view — payouts lead, plus any bookings you make and violations.',
              textAlign: TextAlign.center,
              style: AppTheme.dm(size: 11, color: AppColors.faint),
            ),
          ),
        ],
      ),
    );
  }

  Widget _hist(String title, String sub, String amount, Color color,
          {bool pending = false, bool last = false}) =>
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
                Text(title,
                    style: AppTheme.dm(size: 13, weight: FontWeight.w600)),
                Text(sub,
                    style: AppTheme.dm(
                        size: 11,
                        color: pending
                            ? const Color(0xFFD2760A)
                            : AppColors.muted)),
              ])),
          Text(amount,
              style:
                  AppTheme.dm(size: 14, weight: FontWeight.w700, color: color)),
        ]),
      );
}

class ChoiceChipPillStub extends StatelessWidget {
  const ChoiceChipPillStub(this.label, this.active, {super.key});

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: active ? AppColors.navy : AppColors.white,
            border: active ? null : null,
            borderRadius: BorderRadius.circular(18)),
        child: Text(label,
            style: AppTheme.dm(
                size: 12,
                weight: FontWeight.w600,
                color: active ? Colors.white : AppColors.navy)),
      );
}

/// The owner's violations from `/violations/mine`.
class ViolationsScreen extends StatefulWidget {
  const ViolationsScreen({super.key});

  @override
  State<ViolationsScreen> createState() => _ViolationsScreenState();
}

class _ViolationsScreenState extends State<ViolationsScreen> {
  List<Map<String, dynamic>> _violations = const [];
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    var rows = const <Map<String, dynamic>>[];
    try {
      rows = await sl<ViolationsApiDataSource>().mine();
    } catch (_) {}
    if (mounted) {
      setState(() {
        _violations = rows;
        _loaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final open = _violations.where((v) => !_isClosed(v)).toList();
    final resolved = _violations.where(_isClosed).toList();

    return PhoneScaffold(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        children: [
          const TopBar(title: 'Violations'),
          const SizedBox(height: 16),
          if (!_loaded)
            const Center(
                child: CircularProgressIndicator(color: AppColors.gold))
          else if (open.isEmpty)
            WhiteCard(
              padding: const EdgeInsets.all(14),
              child: Row(children: [
                Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: const Color(0xFFD7EEDD),
                        borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.check, color: AppColors.success)),
                const SizedBox(width: 12),
                Expanded(
                    child: Text('No active violations',
                        style: AppTheme.dm(
                            size: 15,
                            weight: FontWeight.w700,
                            color: AppColors.navy))),
              ]),
            )
          else ...[
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                  color: const Color(0xFFFDECEC),
                  borderRadius: BorderRadius.circular(14)),
              child: Row(children: [
                Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: const Color(0xFFB22222),
                        borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.warning_amber_rounded,
                        color: Colors.white)),
                const SizedBox(width: 12),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(
                          open.length == 1
                              ? '1 active violation'
                              : '${open.length} active violations',
                          style: AppTheme.dm(
                              size: 15,
                              weight: FontWeight.w700,
                              color: const Color(0xFFB22222))),
                      Text('A deduction may apply to your payout',
                          style: AppTheme.dm(
                              size: 12, color: const Color(0xFF8A3A3A))),
                    ])),
              ]),
            ),
            for (final v in open) ...[
              const SizedBox(height: 16),
              _openCard(v),
            ],
          ],
          if (resolved.isNotEmpty) ...[
            const SizedBox(height: 16),
            const SectionLabel('RESOLVED'),
            const SizedBox(height: 8),
            for (final v in resolved) ...[
              WhiteCard(
                  padding: const EdgeInsets.all(14),
                  child: Row(children: [
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Text(_violationTitle(v),
                              style: AppTheme.dm(
                                  size: 14,
                                  weight: FontWeight.w700,
                                  color: AppColors.navy)),
                          Text(_where(v),
                              style: AppTheme.dm(
                                  size: 12, color: AppColors.muted)),
                        ])),
                    const StatusBadge('Cleared', kind: BadgeKind.greenSoft),
                  ])),
              const SizedBox(height: 8),
            ],
          ],
        ],
      ),
    );
  }

  /// `Property · booking reference · date`, from whatever the row carries.
  String _where(Map<String, dynamic> v) {
    final property =
        '${asMap(v['property'])['title'] ?? v['property_title'] ?? ''}';
    final reference =
        '${v['booking_reference'] ?? asMap(v['booking'])['reference'] ?? ''}';
    final at = asDate(pick(v, 'created_at'));
    return [property, reference, if (at != null) _shortDate(at)]
        .where((s) => s.isNotEmpty)
        .join(' · ');
  }

  Widget _openCard(Map<String, dynamic> v) {
    final description =
        '${v['description'] ?? v['details'] ?? v['notes'] ?? ''}'.trim();
    final deduction = _deductionEgp(v);
    final at = asDate(pick(v, 'created_at'));
    return WhiteCard(
      padding: const EdgeInsets.all(14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
              child: Text(_violationTitle(v),
                  style: AppTheme.dm(
                      size: 14,
                      weight: FontWeight.w700,
                      color: AppColors.navy))),
          const StatusBadge('Open', kind: BadgeKind.red),
        ]),
        if (_where(v).isNotEmpty)
          Text(_where(v), style: AppTheme.dm(size: 12, color: AppColors.muted)),
        if (description.isNotEmpty) ...[
          const SizedBox(height: 10),
          Text(description,
              style: AppTheme.dm(size: 13, color: AppColors.ink, height: 1.5)),
        ],
        const SizedBox(height: 12),
        if (deduction > 0)
          KeyValueRow(
              'Deduction', '− ${CurrencyFormatter.format(deduction.round())}',
              valueColor: const Color(0xFFB22222)),
        if (at != null)
          KeyValueRow('Reported on', '${_shortDate(at)}, ${at.year}'),
        const SizedBox(height: 12),
        WideButton(
            label: 'View full report',
            onTap: () => AppNavigation.goToOwnerViolationReport(context),
            color: AppColors.navy,
            height: 44),
      ]),
    );
  }
}
