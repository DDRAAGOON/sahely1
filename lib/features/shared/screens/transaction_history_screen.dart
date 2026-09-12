import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:sahely/core/di/service_locator.dart' show sl;
import 'package:sahely/core/network/api_envelope.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/widgets/pull_to_refresh.dart';
import 'package:sahely/features/renter/presentation/screens/wallet/widgets/history_filter_chips.dart';
import 'package:sahely/features/renter/presentation/screens/wallet/widgets/history_section_header.dart';
import 'package:sahely/features/renter/presentation/screens/wallet/widgets/history_transaction_row.dart';
import 'package:sahely/features/wallet/data/datasources/wallet_remote_data_source.dart';
import 'package:sahely/l10n/app_localizations.dart';

/// The account's own wallet history (`GET /wallet/transactions`), newest
/// first and grouped by month.
class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Payments', 'Credit', 'Violations'];

  List<_Entry> _entries = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final result = await sl<WalletRemoteDataSource>().getTransactionRows();
    if (!mounted) return;
    setState(() {
      _loading = false;
      result.fold(
        (_) => _entries = const [],
        (rows) => _entries = rows.map(_Entry.fromJson).toList()
          ..sort((a, b) => b.at.compareTo(a.at)),
      );
    });
  }

  /// The rows the selected chip keeps.
  List<_Entry> get _visible => _entries.where((e) {
        switch (_selectedFilter) {
          case 'Payments':
            return e.type == 'payment' || e.type == 'refund';
          case 'Credit':
            return e.type == 'credit';
          case 'Violations':
            return e.type == 'violation';
          default:
            return true;
        }
      }).toList();

  /// The visible rows as month sections, newest month first.
  List<(String, List<_Entry>)> _sections(BuildContext context) {
    final now = DateTime.now();
    final thisMonth = DateTime(now.year, now.month);
    final lastMonth = DateTime(now.year, now.month - 1);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final l = AppLocalizations.of(context);

    final grouped = <DateTime, List<_Entry>>{};
    for (final entry in _visible) {
      final month = DateTime(entry.at.year, entry.at.month);
      grouped.putIfAbsent(month, () => []).add(entry);
    }

    final months = grouped.keys.toList()..sort((a, b) => b.compareTo(a));
    return [
      for (final month in months)
        (
          month == thisMonth
              ? l.thisMonth
              : month == lastMonth
                  ? l.lastMonth
                  : DateFormat.yMMMM(locale).format(month),
          grouped[month]!,
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final sections = _sections(context);

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        elevation: 0,
        leadingWidth: 70,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Center(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Icon(
                  Icons.chevron_left,
                  color: AppColors.navy,
                  size: 22,
                ),
              ),
            ),
          ),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'History',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.navy,
                fontFamily: 'DM Sans',
              ),
            ),
            Text(
              'Payments · Credit · Violations',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.secondary,
                fontFamily: 'DM Sans',
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // Filter Chips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: HistoryFilterChips(
                filters: _filters,
                selectedFilter: _selectedFilter,
                onFilterSelected: (filter) {
                  setState(() => _selectedFilter = filter);
                },
              ),
            ),

            const SizedBox(height: 24),

            // Transaction List
            Expanded(
              child: PullToRefresh(
                onRefresh: _load,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    for (final (title, entries) in sections) ...[
                      HistorySectionHeader(title: title),
                      const SizedBox(height: 12),
                      _card(entries),
                      const SizedBox(height: 24),
                    ],

                    // Empty State
                    if (sections.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 48),
                        child: Center(
                          child: _loading
                              ? const CircularProgressIndicator(
                                  color: AppColors.gold)
                              : const Column(
                                  children: [
                                    Icon(
                                      Icons.receipt_long,
                                      size: 64,
                                      color: AppColors.border,
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      'No transactions found',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.secondary,
                                        fontFamily: 'DM Sans',
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),

                    // Footer Note
                    const Padding(
                      padding: EdgeInsets.only(top: 8, bottom: 40),
                      child: Text(
                        'Renter view — every booking payment, credit top-up & violation in one place.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.secondary,
                          fontFamily: 'DM Sans',
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _card(List<_Entry> entries) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          for (var i = 0; i < entries.length; i++) ...[
            HistoryTransactionRow(
              type: entries[i].type,
              title: entries[i].title,
              subtitle: entries[i].subtitle,
              amount: entries[i].amountPiastres,
              isViolation: entries[i].type == 'violation',
            ),
            if (i != entries.length - 1)
              const Divider(height: 1, color: AppColors.border),
          ],
        ],
      ),
    );
  }
}

/// One wallet movement, in the shape the history row renders.
class _Entry {
  const _Entry({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.amountPiastres,
    required this.at,
  });

  /// payment · credit · refund · violation — the four kinds the chips offer.
  final String type;
  final String title;
  final String subtitle;

  /// Piastres, negative when the money left the wallet.
  final int amountPiastres;
  final DateTime at;

  factory _Entry.fromJson(Map<String, dynamic> json) {
    final kind = '${json['type'] ?? ''}'.toLowerCase();
    final reference = '${pick(json, 'reference_type') ?? ''}'.toLowerCase();
    final category = '${json['category'] ?? ''}'.toLowerCase();
    final amount = (asNum(json['amount']) ?? 0).abs().toInt();
    final at = asDate(pick(json, 'created_at')) ?? DateTime.now();

    final outgoing = kind == 'debit' || kind == 'hold' || kind == 'withdrawal';
    final isViolation =
        reference.contains('violation') || category.contains('violation');
    final isRefund = kind == 'refund' || reference.contains('refund');

    return _Entry(
      type: isViolation
          ? 'violation'
          : isRefund
              ? 'refund'
              : outgoing
                  ? 'payment'
                  : 'credit',
      title: '${json['description'] ?? _label(kind, reference)}',
      subtitle: DateFormat('d MMM').format(at),
      amountPiastres: outgoing ? -amount : amount,
      at: at,
    );
  }

  static String _label(String kind, String reference) {
    if (reference.isNotEmpty) return reference.replaceAll('_', ' ');
    return kind.isEmpty ? 'Transaction' : kind;
  }
}
