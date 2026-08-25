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

class OwnerEarningsScreen extends StatefulWidget {
  const OwnerEarningsScreen({super.key});

  @override
  State<OwnerEarningsScreen> createState() => _OwnerEarningsScreenState();
}

class _OwnerEarningsScreenState extends State<OwnerEarningsScreen> {
  int _activeTab = 0; // 0: Month, 1: Quarter, 2: Year

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
      String periodLabel = '';
      String periodAmount = '';
      List<Map<String, String>> stats = [];
      List<Map<String, String>> transactions = [];

      if (_activeTab == 0) {
        periodLabel = 'This Month';
        periodAmount = CurrencyFormatter.format(68400);
        stats = [
          {'label': 'Upcoming', 'value': '24.5k'},
          {'label': 'Paid', 'value': '38.9k'},
          {'label': 'Pending', 'value': '5.0k'},
        ];
        transactions = [
          {'name': 'Azure Villa', 'date': 'Jun 14', 'amount': '+18,000', 'status': 'Paid'},
        ];
      } else if (_activeTab == 1) {
        periodLabel = 'This Quarter';
        periodAmount = CurrencyFormatter.format(215800);
        stats = [
          {'label': 'Upcoming', 'value': '42.0k'},
          {'label': 'Paid', 'value': '173.8k'},
          {'label': 'Pending', 'value': '15.0k'},
        ];
        transactions = [
          {'name': 'Azure Villa', 'date': 'Jun 14', 'amount': '+18,000', 'status': 'Paid'},
          {'name': 'Sunset Suite', 'date': 'May 28', 'amount': '+45,000', 'status': 'Paid'},
          {'name': 'Beach Cabin', 'date': 'Apr 12', 'amount': '+12,000', 'status': 'Paid'},
        ];
      } else {
        periodLabel = 'This Year';
        periodAmount = CurrencyFormatter.format(840000);
        stats = [
          {'label': 'Upcoming', 'value': '120.0k'},
          {'label': 'Paid', 'value': '720.0k'},
          {'label': 'Pending', 'value': '40.0k'},
        ];
        transactions = [
          {'name': 'Azure Villa', 'date': 'Jun 14', 'amount': '+18,000', 'status': 'Paid'},
          {'name': 'Sunset Suite', 'date': 'May 28', 'amount': '+45,000', 'status': 'Paid'},
          {'name': 'Beach Cabin', 'date': 'Apr 12', 'amount': '+12,000', 'status': 'Paid'},
          {'name': 'Royal Palace', 'date': 'Jan 15', 'amount': '+150,000', 'status': 'Paid'},
        ];
      }

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
      final file = File("${output.path}/sahely_report_${periodLabel.replaceAll(' ', '_')}.pdf");
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
    String periodLabel = 'This Month';
    String periodAmount = CurrencyFormatter.format(68400);
    String periodChange = '▲ 12%';
    List<StatCard> statCards = [
      StatCard(value: '24.5k', label: AppLocalizations.of(context).statUpcoming),
      StatCard(value: '38.9k', label: AppLocalizations.of(context).statPaid, valueColor: AppColors.success),
      StatCard(value: '5.0k', label: AppLocalizations.of(context).statPending, valueColor: const Color(0xFFD2760A))
    ];
    List<Widget> txns = [];

    if (_activeTab == 0) {
      periodLabel = 'This Month';
      periodAmount = CurrencyFormatter.format(68400);
      periodChange = '▲ 12%';
      statCards = [
        StatCard(value: '24.5k', label: AppLocalizations.of(context).statUpcoming),
        StatCard(value: '38.9k', label: AppLocalizations.of(context).statPaid, valueColor: AppColors.success),
        StatCard(value: '5.0k', label: AppLocalizations.of(context).statPending, valueColor: const Color(0xFFD2760A))
      ];
      txns = [
        _txn('Azure Villa', 'Jun 14', '+18,000', 'Paid', BadgeKind.greenSoft,
            last: true),
      ];
    } else if (_activeTab == 1) {
      periodLabel = 'This Quarter';
      periodAmount = CurrencyFormatter.format(215800);
      periodChange = '▲ 8%';
      statCards = [
        StatCard(value: '42.0k', label: AppLocalizations.of(context).statUpcoming),
        StatCard(value: '173.8k', label: AppLocalizations.of(context).statPaid, valueColor: AppColors.success),
        StatCard(
            value: '15.0k', label: AppLocalizations.of(context).statPending, valueColor: const Color(0xFFD2760A))
      ];
      txns = [
        _txn('Azure Villa', 'Jun 14', '+18,000', 'Paid', BadgeKind.greenSoft),
        _txn('Sunset Suite', 'May 28', '+45,000', 'Paid', BadgeKind.greenSoft),
        _txn('Beach Cabin', 'Apr 12', '+12,000', 'Paid', BadgeKind.greenSoft,
            last: true),
      ];
    } else {
      periodLabel = 'This Year';
      periodAmount = CurrencyFormatter.format(840000);
      periodChange = '▲ 15%';
      statCards = [
        StatCard(value: '120.0k', label: AppLocalizations.of(context).statUpcoming),
        StatCard(value: '720.0k', label: AppLocalizations.of(context).statPaid, valueColor: AppColors.success),
        StatCard(
            value: '40.0k', label: AppLocalizations.of(context).statPending, valueColor: const Color(0xFFD2760A))
      ];
      txns = [
        _txn('Azure Villa', 'Jun 14', '+18,000', 'Paid', BadgeKind.greenSoft),
        _txn('Sunset Suite', 'May 28', '+45,000', 'Paid', BadgeKind.greenSoft),
        _txn('Beach Cabin', 'Apr 12', '+12,000', 'Paid', BadgeKind.greenSoft),
        _txn('Royal Palace', 'Jan 15', '+150,000', 'Paid', BadgeKind.greenSoft,
            last: true),
      ];
    }

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
              tabs: const ['Month', 'Quarter', 'Year'],
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
                Text(periodAmount,
                    style: AppTheme.dm(
                        size: 30,
                        weight: FontWeight.w700,
                        color: Colors.white)),
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
                        Text('1 active · review details',
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
