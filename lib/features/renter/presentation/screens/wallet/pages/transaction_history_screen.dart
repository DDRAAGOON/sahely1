import 'package:flutter/material.dart';

import '../../../../../../core/theme/app_colors.dart';
import '../widgets/history_filter_chips.dart';
import '../widgets/history_section_header.dart';
import '../widgets/history_transaction_row.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Payments', 'Credit', 'Violations'];

  // Mock data - Grouped by month
  final Map<String, List<Map<String, dynamic>>> _transactions = {
    'THIS MONTH': [
      {
        'type': 'payment',
        'title': 'Booking payment',
        'subtitle': 'Azure Villa · Jun 14',
        'amount': -2109000, // In piastres
      },
      {
        'type': 'credit',
        'title': 'Credit added',
        'subtitle': 'Visa ••42 · Jun 10',
        'amount': 50000,
      },
      {
        'type': 'violation',
        'title': 'Late checkout fine',
        'subtitle': 'Jun 9',
        'amount': -30000,
        'isViolation': true,
      },
    ],
    'LAST MONTH': [
      {
        'type': 'refund',
        'title': 'Refund · cancelled stay',
        'subtitle': 'May 28',
        'amount': 120000,
      },
      {
        'type': 'payment',
        'title': 'Booking payment',
        'subtitle': 'Lagoon Retreat · May 20',
        'amount': -1840000,
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
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
                  setState(() {
                    _selectedFilter = filter;
                  });
                },
              ),
            ),

            const SizedBox(height: 24),

            // Transaction List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  // THIS MONTH Section
                  if (_hasTransactionsForMonth('THIS MONTH')) ...[
                    const HistorySectionHeader(title: 'THIS MONTH'),
                    const SizedBox(height: 12),
                    ..._buildTransactionList('THIS MONTH'),
                    const SizedBox(height: 24),
                  ],

                  // LAST MONTH Section
                  if (_hasTransactionsForMonth('LAST MONTH')) ...[
                    const HistorySectionHeader(title: 'LAST MONTH'),
                    const SizedBox(height: 12),
                    ..._buildTransactionList('LAST MONTH'),
                    const SizedBox(height: 24),
                  ],

                  // Empty State
                  if (!_hasTransactionsForMonth('THIS MONTH') &&
                      !_hasTransactionsForMonth('LAST MONTH'))
                    const Padding(
                      padding: EdgeInsets.only(top: 48),
                      child: Center(
                        child: Column(
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
          ],
        ),
      ),
    );
  }

  bool _hasTransactionsForMonth(String month) {
    if (_transactions[month] == null) return false;
    if (_selectedFilter == 'All') return _transactions[month]!.isNotEmpty;

    return _transactions[month]!.any((transaction) {
      if (_selectedFilter == 'Payments') {
        return transaction['type'] == 'payment' ||
            transaction['type'] == 'refund';
      } else if (_selectedFilter == 'Credit') {
        return transaction['type'] == 'credit';
      } else if (_selectedFilter == 'Violations') {
        return transaction['type'] == 'violation';
      }
      return false;
    });
  }

  List<Widget> _buildTransactionList(String month) {
    final transactions = _transactions[month]!;
    List<Map<String, dynamic>> filteredTransactions = [];

    for (var transaction in transactions) {
      if (_selectedFilter != 'All') {
        if (_selectedFilter == 'Payments' &&
            transaction['type'] != 'payment' &&
            transaction['type'] != 'refund') {
          continue;
        } else if (_selectedFilter == 'Credit' &&
            transaction['type'] != 'credit') {
          continue;
        } else if (_selectedFilter == 'Violations' &&
            transaction['type'] != 'violation') {
          continue;
        }
      }
      filteredTransactions.add(transaction);
    }

    if (filteredTransactions.isEmpty) return [];

    return [
      Container(
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
          children: filteredTransactions.asMap().entries.map((entry) {
            final index = entry.key;
            final transaction = entry.value;
            final isLast = index == filteredTransactions.length - 1;

            return Column(
              children: [
                HistoryTransactionRow(
                  type: transaction['type'],
                  title: transaction['title'],
                  subtitle: transaction['subtitle'],
                  amount: transaction['amount'],
                  isViolation: transaction['isViolation'] ?? false,
                ),
                if (!isLast)
                  const Divider(
                    height: 1,
                    color: AppColors.border,
                    indent: 0,
                  ),
              ],
            );
          }).toList(),
        ),
      ),
    ];
  }
}
