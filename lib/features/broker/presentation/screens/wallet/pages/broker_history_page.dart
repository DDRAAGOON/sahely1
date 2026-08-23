import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/kit.dart';

class BrokerHistoryPage extends StatefulWidget {
  const BrokerHistoryPage({super.key});

  @override
  State<BrokerHistoryPage> createState() => _BrokerHistoryPageState();
}

class _BrokerHistoryPageState extends State<BrokerHistoryPage> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Commissions', 'Payments'];

  final List<Map<String, dynamic>> _thisMonthItems = [
    {
      'type': 'Commissions',
      'title': 'Retroactive bonus',
      'subtitle': 'Gold tier upgrade · Jun 13',
      'amount': '+2,400',
      'color': AppColors.success,
      'isBonus': true,
    },
    {
      'type': 'Commissions',
      'title': 'Commission · Palm Chalet',
      'subtitle': 'Jun 12',
      'amount': '+1,820',
      'color': AppColors.success,
    },
    {
      'type': 'Commissions',
      'title': 'Commission · Dune House',
      'subtitle': 'Jun 9 · Pending',
      'amount': '+960',
      'color': AppColors.navy,
      'pending': true,
    },
  ];

  final List<Map<String, dynamic>> _lastMonthItems = [
    {
      'type': 'Commissions',
      'title': 'Commission · Marina Loft',
      'subtitle': 'May 24',
      'amount': '+1,450',
      'color': AppColors.success,
    },
    {
      'type': 'Payments',
      'title': 'Booking payment',
      'subtitle': 'Own stay · May 18',
      'amount': '−9,800',
      'color': const Color(0xFFB22222),
    },
  ];

  List<Map<String, dynamic>> _filterItems(List<Map<String, dynamic>> items) {
    if (_selectedFilter == 'All') return items;
    return items.where((item) => item['type'] == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredThisMonth = _filterItems(_thisMonthItems);
    final filteredLastMonth = _filterItems(_lastMonthItems);

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
                      border: isActive ? null : null,
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
          if (filteredThisMonth.isNotEmpty) ...[
            const SectionLabel('THIS MONTH'),
            const SizedBox(height: 8),
            WhiteCard(
              child: Column(
                children: List.generate(filteredThisMonth.length, (index) {
                  final item = filteredThisMonth[index];
                  final isLast = index == filteredThisMonth.length - 1;
                  
                  if (item['isBonus'] == true) {
                    return Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFDF9F4),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: AppColors.gold.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.star, size: 16, color: AppColors.gold),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item['title'], style: AppTheme.dm(size: 13, weight: FontWeight.w600)),
                                    Text(item['subtitle'], style: AppTheme.dm(size: 11, color: AppColors.muted)),
                                  ],
                                ),
                              ),
                              Text(item['amount'],
                                  style: AppTheme.dm(size: 14, weight: FontWeight.w700, color: item['color'])),
                            ],
                          ),
                        ),
                        if (!isLast) const Divider(height: 1, color: Color(0xFFF4EFE7)),
                      ],
                    );
                  }

                  return _brk(
                    item['title'],
                    item['subtitle'],
                    item['amount'],
                    item['color'],
                    pending: item['pending'] ?? false,
                    last: isLast,
                  );
                }),
              ),
            ),
            const SizedBox(height: 16),
          ],
          if (filteredLastMonth.isNotEmpty) ...[
            const SectionLabel('LAST MONTH'),
            const SizedBox(height: 8),
            WhiteCard(
              child: Column(
                children: List.generate(filteredLastMonth.length, (index) {
                  final item = filteredLastMonth[index];
                  return _brk(
                    item['title'],
                    item['subtitle'],
                    item['amount'],
                    item['color'],
                    pending: item['pending'] ?? false,
                    last: index == filteredLastMonth.length - 1,
                  );
                }),
              ),
            ),
          ],
          if (filteredThisMonth.isEmpty && filteredLastMonth.isEmpty)
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
                  Text(title, style: AppTheme.dm(size: 13, weight: FontWeight.w600)),
                  Text(
                    sub,
                    style: AppTheme.dm(
                      size: 11,
                      color: pending ? const Color(0xFFD2760A) : AppColors.muted,
                    ),
                  ),
                ],
              ),
            ),
            Text(amount, style: AppTheme.dm(size: 14, weight: FontWeight.w700, color: color)),
          ],
        ),
      );
}
