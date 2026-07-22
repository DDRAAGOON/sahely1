import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/kit.dart';

class PortfolioInsightsScreen extends StatelessWidget {
  const PortfolioInsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PhoneScaffold(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        children: [
          const TopBar(
              title: 'Portfolio', subtitle: 'All 3 properties combined'),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Color(0xFF2A3A64), AppColors.navy]),
                borderRadius: BorderRadius.circular(16)),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Total revenue · this month',
                  style: AppTheme.dm(size: 13, color: const Color(0xFFCDD4E0))),
              const SizedBox(height: 6),
              Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text('EGP 102,600',
                    style: AppTheme.dm(
                        size: 28,
                        weight: FontWeight.w700,
                        color: Colors.white)),
                const SizedBox(width: 10),
                Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Text('▲ 14%',
                        style: AppTheme.dm(
                            size: 13,
                            weight: FontWeight.w700,
                            color: const Color(0xFF7BE0A0)))),
              ]),
            ]),
          ),
          const SizedBox(height: 14),
          const StatRow(cards: [
            StatCard(value: '3,211', label: 'Total views ▲12%'),
            StatCard(value: '218', label: 'Wishlist saves'),
            StatCard(value: '27', label: 'Bookings')
          ]),
          const SizedBox(height: 10),
          const StatRow(cards: [
            StatCard(value: '79%', label: 'Avg occupancy'),
            StatCard(value: '★ 4.7', label: 'Avg rating'),
            StatCard(
                value: '1',
                label: 'Open violation',
                valueColor: Color(0xFFD2760A))
          ]),
          const SizedBox(height: 18),
          Text('Performance · head to head',
              style: AppTheme.dm(
                  size: 15, weight: FontWeight.w700, color: AppColors.navy)),
          Text('Ranked by occupancy & revenue',
              style: AppTheme.dm(size: 12, color: AppColors.muted)),
          const SizedBox(height: 12),
          _barCard('Azure Beach Villa', 'EGP 68,400 this month', 0.88,
              AppColors.gold,
              top: true),
          const SizedBox(height: 10),
          _barCard(
              'Golden Dunes', 'EGP 27,200 this month', 0.62, AppColors.navy),
          const SizedBox(height: 10),
          _barCard('Marina Loft', 'EGP 0 this month', 0.0, AppColors.navy),
          const SizedBox(height: 16),
          const InfoNote(
              text:
                  'Azure leads on every metric. Marina Loft isn\'t published — finishing its setup could add ~EGP 30k/mo.'),
        ],
      ),
    );
  }

  Widget _barCard(String name, String revenue, double pct, Color color,
          {bool top = false}) =>
      WhiteCard(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(
                child: Text(name,
                    style: AppTheme.dm(
                        size: 14,
                        weight: FontWeight.w700,
                        color: AppColors.navy))),
            if (top) const StatusBadge('Top performer', kind: BadgeKind.gold),
            const SizedBox(width: 8),
            Text('${(pct * 100).round()}%',
                style: AppTheme.dm(
                    size: 14, weight: FontWeight.w700, color: AppColors.navy)),
          ]),
          const SizedBox(height: 4),
          Text(revenue, style: AppTheme.dm(size: 12, color: AppColors.muted)),
          const SizedBox(height: 8),
          ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                  value: pct,
                  minHeight: 8,
                  backgroundColor: const Color(0xFFE6EAF2),
                  valueColor: AlwaysStoppedAnimation(color))),
        ]),
      );
}
