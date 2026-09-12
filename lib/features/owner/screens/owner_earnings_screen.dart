import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:sahely/core/navigation/app_navigation.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/l10n/app_localizations.dart';
import 'package:sahely/core/widgets/kit.dart';

import '../../../core/utils/currency_formatter.dart';
import 'package:sahely/core/di/service_locator.dart' show sl;
import 'package:sahely/core/network/api_envelope.dart';
import 'package:sahely/features/shared/violations/data/violations_api_data_source.dart';
import 'package:sahely/features/wallet/data/datasources/wallet_remote_data_source.dart';

/// What one tab shows - used by the screen and by the PDF export.
typedef _Period = ({
  String label,
  String amount,
  List<(String, String)> stats,
  List<Map<String, String>> transactions,
});

class OwnerEarningsScreen extends StatefulWidget {
  const OwnerEarningsScreen({super.key});

  @override
  State<OwnerEarningsScreen> createState() => _OwnerEarningsScreenState();
}

class _OwnerEarningsScreenState extends State<OwnerEarningsScreen> {
  int _activeTab = 0; // 0: Month, 1: Last 6 months, 2: Year
  Map<String, dynamic> _dashboard = const {};
  List<Map<String, dynamic>> _transactions = const [];
  int _openViolations = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  /// Totals from `/wallets/me/dashboard`, entries from
  /// `/wallets/me/transactions` and open cases from `/violations/mine`.
  Future<void> _load() async {
    final wallet = sl<WalletRemoteDataSource>();
    final dashboard = await wallet.getOwnerDashboard();
    final transactions = await wallet.getOwnerTransactions(limit: 50);
    var violations = 0;
    try {
      final rows = await sl<ViolationsApiDataSource>().mine();
      violations = rows.where((v) => !_closed('${v['status'] ?? ''}')).length;
    } catch (_) {}
    if (!mounted) return;
    setState(() {
      dashboard.fold((_) {}, (d) => _dashboard = d);
      transactions.fold((_) {}, (t) => _transactions = t);
      _openViolations = violations;
    });
  }

  static bool _closed(String status) {
    final s = status.toLowerCase();
    return s.contains('resolv') ||
        s.contains('clos') ||
        s.contains('dismiss') ||
        s.contains('reject');
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

  String _compact(String key) {
    final egp = asNum(_dashboard[key])?.toDouble() ?? 0;
    return egp >= 1000
        ? '${(egp / 1000).toStringAsFixed(1)}k'
        : egp.round().toString();
  }

  _Period _period() {
    final now = DateTime.now();
    final (label, key, since) = switch (_activeTab) {
      0 => ('This Month', 'thisMonthEgp', DateTime(now.year, now.month)),
      1 => (
          'Last 6 Months',
          'last6MonthsEgp',
          DateTime(now.year, now.month - 5)
        ),
      _ => ('This Year', 'thisYearEgp', DateTime(now.year)),
    };
    final rows = _transactions
        .where((t) {
          final at = asDate(pick(t, 'created_at'));
          return at != null && !at.isBefore(since);
        })
        .take(10)
        .map(_toRow)
        .toList();
    return (
      label: label,
      amount: CurrencyFormatter.format(
          (asNum(_dashboard[key])?.toDouble() ?? 0).round()),
      stats: [
        ('Upcoming', _compact('upcomingEgp')),
        ('Paid', _compact('paidEgp')),
        ('Pending', _compact('pendingEgp')),
      ],
      transactions: rows,
    );
  }

  /// A wallet entry: `amount` is in piastres, `type` credit / debit.
  Map<String, String> _toRow(Map<String, dynamic> t) {
    final at = asDate(pick(t, 'created_at'));
    final piastres = asNum(t['amount'])?.toDouble() ?? 0;
    final credit = '${t['type'] ?? ''}'.toLowerCase() != 'debit';
    final description = '${t['description'] ?? ''}'.trim();
    final category = '${t['category'] ?? ''}'.trim();
    final fallback =
        category.isEmpty ? (credit ? 'Credit' : 'Debit') : category;
    return {
      'name': description.isNotEmpty
          ? description
          : fallback[0].toUpperCase() + fallback.substring(1),
      'date': at == null ? '' : '${_months[at.month - 1]} ${at.day}',
      'amount': '${credit ? '+' : '−'}${_grouped((piastres / 100).round())}',
      'status': !credit
          ? 'Withdrawn'
          : description.toLowerCase().contains('pending')
              ? 'Pending'
              : 'Paid',
    };
  }

  Future<void> _exportPDF(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white)),
            const SizedBox(width: 12),
            Text(AppLocalizations.of(context).generatingPdf,
                style: AppTheme.dm(color: Colors.white)),
          ],
        ),
        duration: const Duration(seconds: 1),
        backgroundColor: AppColors.navy,
      ),
    );

    try {
      final pdf = pw.Document();

      // Gather current data
      final period = _period();
      final periodLabel = period.label;
      final periodAmount = period.amount;
      final stats = [
        for (final (label, value) in period.stats)
          {'label': label, 'value': value},
      ];
      final transactions = period.transactions;

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Padding(
              padding: const pw.EdgeInsets.all(32),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('SAHELY EARNINGS REPORT',
                      style: pw.TextStyle(
                          fontSize: 24, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 10),
                  pw.Text('Period: $periodLabel',
                      style: const pw.TextStyle(fontSize: 16)),
                  pw.Divider(),
                  pw.SizedBox(height: 20),
                  pw.Text('Total Earnings: $periodAmount',
                      style: pw.TextStyle(
                          fontSize: 20, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 20),
                  pw.Text('Summary:',
                      style: pw.TextStyle(
                          fontSize: 18, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 10),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: stats
                        .map((s) => pw.Column(children: [
                              pw.Text(s['label']!),
                              pw.Text(s['value']!,
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold)),
                            ]))
                        .toList(),
                  ),
                  pw.SizedBox(height: 30),
                  pw.Text('Recent Transactions:',
                      style: pw.TextStyle(
                          fontSize: 18, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 10),
                  pw.Table(
                    border: pw.TableBorder.all(),
                    children: [
                      pw.TableRow(children: [
                        pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text('Name',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold))),
                        pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text('Date',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold))),
                        pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text('Amount',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold))),
                        pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text('Status',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold))),
                      ]),
                      ...transactions.map((t) => pw.TableRow(children: [
                            pw.Padding(
                                padding: const pw.EdgeInsets.all(5),
                                child: pw.Text(t['name']!)),
                            pw.Padding(
                                padding: const pw.EdgeInsets.all(5),
                                child: pw.Text(t['date']!)),
                            pw.Padding(
                                padding: const pw.EdgeInsets.all(5),
                                child: pw.Text(t['amount']!)),
                            pw.Padding(
                                padding: const pw.EdgeInsets.all(5),
                                child: pw.Text(t['status']!)),
                          ])),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      );

      // Save the PDF file
      final output = await getTemporaryDirectory();
      final file = File(
          "${output.path}/sahely_report_${periodLabel.replaceAll(' ', '_')}.pdf");
      await file.writeAsBytes(await pdf.save());

      // Show print/share dialog
      await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async => pdf.save());

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).reportSaved,
                style: AppTheme.dm(color: Colors.white)),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppLocalizations.of(context).pdfFailed}: $e',
                style: AppTheme.dm(color: Colors.white)),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final period = _period();
    final periodLabel = period.label;
    final periodAmount = period.amount;
    const periodChange = '';
    final statCards = [
      StatCard(
          value: period.stats[0].$2,
          label: AppLocalizations.of(context).statUpcoming),
      StatCard(
          value: period.stats[1].$2,
          label: AppLocalizations.of(context).statPaid,
          valueColor: AppColors.success),
      StatCard(
          value: period.stats[2].$2,
          label: AppLocalizations.of(context).statPending,
          valueColor: const Color(0xFFD2760A)),
    ];
    final entries = period.transactions;
    final txns = entries.isEmpty
        ? <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text('No transactions in this period.',
                  style: AppTheme.dm(size: 13, color: AppColors.muted)),
            ),
          ]
        : [
            for (var i = 0; i < entries.length; i++)
              _txn(
                  entries[i]['name']!,
                  entries[i]['date']!,
                  entries[i]['amount']!,
                  entries[i]['status']!,
                  switch (entries[i]['status']) {
                    'Paid' => BadgeKind.greenSoft,
                    'Pending' => BadgeKind.orange,
                    _ => BadgeKind.gray,
                  },
                  last: i == entries.length - 1),
          ];

    return PhoneScaffold(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
        children: [
          TopBar(
            title: 'Wallet',
            trailing: GestureDetector(
              onTap: () => _exportPDF(context),
              behavior: HitTestBehavior.opaque,
              child: Text('Export PDF',
                  style: AppTheme.dm(
                      size: 13,
                      weight: FontWeight.w600,
                      color: AppColors.gold)),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 36,
            child: SegmentTabs(
              tabs: const ['Month', '6 Months', 'Year'],
              active: _activeTab,
              onTap: (index) {
                setState(() {
                  _activeTab = index;
                });
              },
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Color(0xFF22335A), AppColors.navy]),
                borderRadius: BorderRadius.circular(16)),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(periodLabel,
                  style: AppTheme.dm(size: 13, color: const Color(0xFFCDD4E0))),
              const SizedBox(height: 6),
              Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Flexible(
                  child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(periodAmount,
                          style: AppTheme.dm(
                              size: 30,
                              weight: FontWeight.w700,
                              color: Colors.white))),
                ),
                const SizedBox(width: 10),
                Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(periodChange,
                        style: AppTheme.dm(
                            size: 13,
                            weight: FontWeight.w700,
                            color: const Color(0xFF7BE0A0)))),
              ]),
            ]),
          ),
          const SizedBox(height: 14),
          StatRow(cards: statCards),
          const SizedBox(height: 16),
          WhiteCard(child: Column(children: txns)),
          const SizedBox(height: 10),
          Center(
            child: GestureDetector(
              onTap: () => AppNavigation.goToOwnerHistory(context,
                  extra: _activeTab == 0
                      ? 'Month'
                      : (_activeTab == 1 ? 'Quarter' : 'Year')),
              behavior: HitTestBehavior.opaque,
              child: Text(
                'View Full History →',
                style: AppTheme.dm(
                    size: 13, weight: FontWeight.w600, color: AppColors.gold),
              ),
            ),
          ),
          const SizedBox(height: 12),
          const InfoNote(
              text:
                  'Payouts are released 48h after guest check-in. Pending funds appear here until cleared.'),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: () => AppNavigation.goToOwnerViolations(context),
            behavior: HitTestBehavior.opaque,
            child: WhiteCard(
                padding: const EdgeInsets.all(14),
                child: Row(children: [
                  Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                          color: const Color(0xFFFDECEC),
                          borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.warning_amber_rounded,
                          color: Color(0xFFB22222))),
                  const SizedBox(width: 12),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text('Violations',
                            style: AppTheme.dm(
                                size: 14,
                                weight: FontWeight.w700,
                                color: AppColors.navy)),
                        Text('$_openViolations active · review details',
                            style:
                                AppTheme.dm(size: 12, color: AppColors.muted)),
                      ])),
                  const Icon(Icons.chevron_right, color: AppColors.faint),
                ])),
          ),
          const SizedBox(height: 20),
          GoldButton(
            label: 'Withdraw to Bank',
            onTap: () => AppNavigation.goToOwnerWithdraw(context),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _txn(
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
