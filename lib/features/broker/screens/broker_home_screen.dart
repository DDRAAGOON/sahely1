import 'package:flutter/material.dart';
import 'package:sahely/data/models.dart';
import 'package:sahely/data/sample_data.dart';
import 'package:sahely/theme/app_colors.dart';
import 'package:sahely/theme/app_theme.dart';
import 'package:sahely/widgets/common.dart';
import 'package:sahely/widgets/floating_nav.dart';
import 'package:sahely/widgets/kit.dart';
import 'package:sahely/widgets/property_card.dart';
import 'package:sahely/widgets/cream_background.dart';
import 'package:sahely/widgets/chips.dart';
import 'package:sahely/features/broker/broker_nav.dart';

class BrokerHomeScreen extends StatelessWidget {
  const BrokerHomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return PhoneScaffold(
      child: Stack(children: [
        const _BrokerHomeContent(),
        FloatingNav(active: 0, items: FloatingNav.brokerTabs, onTap: (i, _) => brokerNav(context, i)),
      ]),
    );
  }
}

class _BrokerHomeContent extends StatelessWidget {
  const _BrokerHomeContent();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Good morning,', style: AppTheme.dm(size: 13, color: AppColors.muted)),
            Text('Karim Adel', style: AppTheme.dm(size: 22, weight: FontWeight.w700, color: AppColors.navy)),
          ]),
          const RoleBadge(role: Role.broker),
        ]),
        const SizedBox(height: 14),
        SearchHeaderRow(
          onSearchTap: () => Navigator.pushNamed(context, '/browse'),
          onFilter: () async {
            final result = await Navigator.pushNamed(context, '/filters');
            if (result is Map<String, dynamic> && context.mounted) {
              Navigator.pushNamed(context, '/browse', arguments: result);
            }
          },
        ),
        const SizedBox(height: 14),
        SectionHeader(
          title: 'Trending Now',
          onAction: () => Navigator.pushNamed(context, '/all-properties'),
        ),
        const SizedBox(height: 12),
        PropertyCard(property: Sample.azure, onTap: () => Navigator.pushNamed(context, '/property', arguments: Sample.azure)),
        const SizedBox(height: 18),
        Text('Your dashboard', style: AppTheme.dm(size: 18, weight: FontWeight.w600, color: AppColors.navy)),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/broker/refer'),
          child: WhiteCard(padding: const EdgeInsets.all(14), child: Row(children: [
            Container(width: 40, height: 40, decoration: BoxDecoration(color: const Color(0xFFFBF3DE), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.home_outlined, color: AppColors.gold)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Refer an owner, earn 50 ★', style: AppTheme.dm(size: 14, weight: FontWeight.w700, color: AppColors.navy)),
              Text('When their property gets listed & approved', style: AppTheme.dm(size: 11, color: AppColors.muted)),
            ])),
            const Icon(Icons.chevron_right, color: AppColors.faint),
          ])),
        ),
        const SizedBox(height: 12),
        const StatRow(cards: [StatCard(value: '18.2k', label: 'This month'), StatCard(value: '51', label: 'Live props'), StatCard(value: '2', label: 'Need help', valueColor: Color(0xFFD2760A))]),
        const SizedBox(height: 18),
        Text('Upcoming Check-ins', style: AppTheme.dm(size: 18, weight: FontWeight.w600, color: AppColors.navy)),
        const SizedBox(height: 12),
        _checkin('Palm Chalet', 'Nour A. · Jun 19 · +EGP 320 profit'),
        const SizedBox(height: 10),
        _checkin('Dune House', 'Sara M. · Jun 22 · +EGP 260 profit'),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/broker/refer'),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(gradient: const LinearGradient(colors: [AppColors.gold, Color(0xFFB3923C)]), borderRadius: BorderRadius.circular(16)),
            child: Row(children: [
              Container(width: 42, height: 42, decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.group_add_outlined, color: AppColors.gold)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Refer a property', style: AppTheme.dm(size: 15, weight: FontWeight.w700, color: AppColors.navy)),
                Text('Earn 4% on every booking · share your code', style: AppTheme.dm(size: 11, color: const Color(0xFF3A3320))),
              ])),
              Container(width: 28, height: 28, decoration: const BoxDecoration(color: AppColors.navy, shape: BoxShape.circle), child: const Icon(Icons.chevron_right, size: 18, color: AppColors.gold)),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _checkin(String name, String meta) => WhiteCard(
        padding: const EdgeInsets.all(14),
        child: Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(name, style: AppTheme.dm(size: 14, weight: FontWeight.w700, color: AppColors.navy)),
            Text(meta, style: AppTheme.dm(size: 12, color: AppColors.muted)),
          ])),
          const StatusBadge('Soon', kind: BadgeKind.navy),
        ]),
      );
}
