import 'package:flutter/material.dart';
import '../../../data/sample_data.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/chips.dart';
import '../../../widgets/kit.dart';
import '../../../widgets/cream_background.dart';

class BrokerPortfolioScreen extends StatelessWidget {
  const BrokerPortfolioScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return PhoneScaffold(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
        children: [
          Row(children: [
            const Expanded(child: TopBar(title: 'My Portfolio', subtitle: '55 referred · 51 live')),
            Container(height: 34, padding: const EdgeInsets.symmetric(horizontal: 16), decoration: BoxDecoration(color: AppColors.gold, borderRadius: BorderRadius.circular(18)), child: Center(child: Text('Refer', style: AppTheme.dm(size: 13, weight: FontWeight.w700, color: AppColors.navy)))),
          ]),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF2A2418), AppColors.navy]), borderRadius: BorderRadius.circular(18)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Commission earned · this season', style: AppTheme.dm(size: 12, color: const Color(0xFF9FB0CF))),
              const SizedBox(height: 6),
              Text('EGP 312,400', style: AppTheme.dm(size: 28, weight: FontWeight.w700, color: AppColors.gold)),
              const SizedBox(height: 12),
              Row(children: [
                _stat('51', 'Live', Colors.white),
                _stat('2', 'Pending', AppColors.gold),
                _stat('1', 'Issue', const Color(0xFFFF9A9A)),
                _stat('1', 'Cancelled', Colors.white),
              ]),
            ]),
          ),
          const SizedBox(height: 14),
          SizedBox(height: 32, child: ListView(scrollDirection: Axis.horizontal, children: const [
            ChoiceChipPill('All 55', selected: true, height: 32), SizedBox(width: 8),
            ChoiceChipPill('Live 51', height: 32), SizedBox(width: 8),
            ChoiceChipPill('Pending 2', height: 32), SizedBox(width: 8),
            ChoiceChipPill('Issue 1', height: 32), SizedBox(width: 8),
            ChoiceChipPill('Cancelled 1', height: 32),
          ])),
          const SizedBox(height: 16),
          const SectionLabel('TOP EARNERS'),
          const SizedBox(height: 10),
          _earner(context, Sample.azure.image, 'Azure Beach Villa', 'Live', BadgeKind.green, 'Owner · Layla M.', '24', 'EGP 41,200'),
          const SizedBox(height: 10),
          _earner(context, Sample.lagoon.image, 'Lagoon Retreat', 'Live', BadgeKind.green, 'Owner · Sara A.', '18', 'EGP 33,600'),
          const SizedBox(height: 10),
          _earner(context, Sample.dunes.image, 'Golden Dunes', 'Pending', BadgeKind.orange, 'Owner · Tarek S.', '—', '—'),
          const SizedBox(height: 16),
          const SectionLabel('NOT LIVE'),
          const SizedBox(height: 10),
          WhiteCard(child: Column(children: [
            _notLive(context, 'Golden Dunes', 'Owner Tarek S. · under review', 'Pending', BadgeKind.orange),
            _notLive(context, 'Marina Loft', 'Issue · needs better photos', 'Issue', BadgeKind.red, issue: true),
            _notLive(context, 'Palm Chalet', 'Owner withdrew listing', 'Cancelled', BadgeKind.gray, last: true),
          ])),
        ],
      ),
    );
  }

  Widget _stat(String v, String l, Color c) => Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(v, style: AppTheme.dm(size: 17, weight: FontWeight.w700, color: c)),
        Text(l, style: AppTheme.dm(size: 10, color: const Color(0xFF9FB0CF))),
      ]));

  Widget _earner(BuildContext context, String img, String name, String badge, BadgeKind kind, String owner, String bookings, String commission) => WhiteCard(
        padding: const EdgeInsets.all(12),
        child: Row(children: [
          ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network(img, width: 64, height: 64, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(width: 64, height: 64, color: AppColors.cardWarm))),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [Expanded(child: Text(name, style: AppTheme.dm(size: 14, weight: FontWeight.w700, color: AppColors.navy))), StatusBadge(badge, kind: kind)]),
            Text(owner, style: AppTheme.dm(size: 12, color: AppColors.muted)),
            const SizedBox(height: 6),
            Row(children: [
              Text('Bookings $bookings', style: AppTheme.dm(size: 12, color: AppColors.ink)),
              const Spacer(),
              Text(commission, style: AppTheme.dm(size: 13, weight: FontWeight.w700, color: commission == '—' ? AppColors.muted : AppColors.success)),
            ]),
          ])),
        ]),
      );

  Widget _notLive(BuildContext context, String name, String meta, String badge, BadgeKind kind, {bool issue = false, bool last = false}) => GestureDetector(
        onTap: issue ? () => Navigator.pushNamed(context, '/broker/referral-issue') : null,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: last ? null : const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFF4EFE7)))),
          child: Row(children: [
            Container(width: 44, height: 44, decoration: BoxDecoration(color: AppColors.cardWarm, borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.home_outlined, color: AppColors.muted)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(name, style: AppTheme.dm(size: 14, weight: FontWeight.w700, color: AppColors.navy)),
              Text(meta, style: AppTheme.dm(size: 12, color: issue ? const Color(0xFFB22222) : AppColors.muted)),
            ])),
            StatusBadge(badge, kind: kind),
          ]),
        ),
      );
}
