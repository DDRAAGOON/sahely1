import 'package:flutter/material.dart';
import 'package:sahely/core/navigation/app_navigation.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/kit.dart';
import 'package:sahely/core/widgets/ui.dart';

class TierDashboardPage extends StatelessWidget {
  const TierDashboardPage({super.key});

  static const _tiers = [
    (
      'Partner · 2%',
      '1–14 properties · base rate',
      'Done',
      BadgeKind.greenSoft,
      false
    ),
    (
      'Silver · 3%',
      '15–39 · free stay, WhatsApp, card',
      'Done',
      BadgeKind.greenSoft,
      false
    ),
    (
      'Gold · 4%',
      '40–99 · 2 free stays, beach pass, kit',
      'YOU',
      BadgeKind.gold,
      true
    ),
    (
      'Elite · 5%',
      '100+ · 3 free stays, founder dinner, advisory',
      '45 to go',
      BadgeKind.gold,
      false
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return PhoneScaffold(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 120),
        children: [
          const Align(alignment: Alignment.centerLeft, child: BackChip()),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Color(0xFF2A2418), Color(0xFF141D33)]),
                borderRadius: BorderRadius.circular(18)),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('BROKER PASS',
                    style: AppTheme.dm(
                        size: 16,
                        weight: FontWeight.w700,
                        color: AppColors.gold,
                        letterSpacing: 3)),
                Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                        color: AppColors.gold.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12)),
                    child: Text('Season 2026',
                        style: AppTheme.dm(size: 11, color: AppColors.gold))),
              ]),
              const SizedBox(height: 14),
              Row(children: [
                Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                        color: AppColors.gold.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.workspace_premium,
                        color: AppColors.gold)),
                const SizedBox(width: 12),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text('Tier 3 of 4 · 4% commission',
                          style: AppTheme.dm(
                              size: 12, color: const Color(0xFF9FB0CF))),
                      Text('Gold Broker',
                          style: AppTheme.dm(
                              size: 21,
                              weight: FontWeight.w700,
                              color: Colors.white)),
                    ])),
                Text('55',
                    style: AppTheme.dm(
                        size: 20,
                        weight: FontWeight.w700,
                        color: AppColors.gold)),
              ]),
              const SizedBox(height: 12),
              ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: const LinearProgressIndicator(
                      value: 0.55,
                      minHeight: 8,
                      backgroundColor: Colors.white24,
                      valueColor: AlwaysStoppedAnimation(AppColors.gold))),
              const SizedBox(height: 6),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                RichText(
                    text: TextSpan(
                        style: AppTheme.dm(
                            size: 11, color: const Color(0xFF9FB0CF)),
                        children: const [
                      TextSpan(
                          text: '45 more',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppColors.gold)),
                      TextSpan(text: ' to Elite (5%)')
                    ])),
                Text('100',
                    style:
                        AppTheme.dm(size: 11, color: const Color(0xFF9FB0CF))),
              ]),
            ]),
          ),
          const SizedBox(height: 12),
          const InfoNote(
              text:
                  'When you reach the next tier, the higher rate applies to bookings going forward — not past ones. Climb early to earn more, longer.'),
          const SizedBox(height: 16),
          Text('The 4 Broker Tiers',
              style: AppTheme.dm(
                  size: 16, weight: FontWeight.w700, color: AppColors.navy)),
          Text('By verified properties you refer. Resets each season.',
              style: AppTheme.dm(size: 12, color: AppColors.muted)),
          const SizedBox(height: 12),
          for (final t in _tiers) ...[_tierRow(t), const SizedBox(height: 8)],
          const SizedBox(height: 8),
          Text('What each tier unlocks',
              style: AppTheme.dm(
                  size: 16, weight: FontWeight.w700, color: AppColors.navy)),
          const SizedBox(height: 10),
          WhiteCard(
              child: Column(children: [
            _unlock(
                'Partner · 2%',
                '2% commission · dashboard & referral code · standard support',
                false),
            _unlock(
                'Silver · 3%',
                'Everything in Partner + 1 free stay / season · priority WhatsApp support · branded business card',
                false),
            _unlock(
                'Gold · 4% (YOU)',
                'Everything in Silver + 2 free stays / season · season beach pass · welcome kit · dedicated account manager',
                true),
            _unlock(
                'Elite · 5%',
                'Everything in Gold + 3 free stays / season · founder dinner invite · early access to new compounds · advisory board seat',
                false,
                last: true),
          ])),
          const SizedBox(height: 14),
          const InfoNote(
              text:
                  'Tiers & perks reset every season — re-earn your tier to keep the benefits. New rate applies to bookings after you upgrade.'),
          const SizedBox(height: 14),
          GoldButton(
              label: 'Refer more · 45 to Elite (5%)',
              onTap: () => AppNavigation.goToBrokerRefer(context)),
        ],
      ),
    );
  }

  Widget _tierRow((String, String, String, BadgeKind, bool) t) {
    final current = t.$5;
    return Opacity(
      opacity: (t.$3 == 'Done' && !current) ? 0.75 : 1,
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: current ? AppColors.navy : AppColors.white,
          border: current ? Border.all(color: AppColors.gold) : null,
          borderRadius: BorderRadius.circular(13),
          boxShadow: current
              ? null
              : const [BoxShadow(color: Color(0x0F1B2744), blurRadius: 10)],
        ),
        child: Row(children: [
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(t.$1,
                    style: AppTheme.dm(
                        size: 14,
                        weight: FontWeight.w700,
                        color: current ? Colors.white : AppColors.navy)),
                Text(t.$2,
                    style: AppTheme.dm(
                        size: 11,
                        color: current
                            ? const Color(0xFFCDD4E0)
                            : AppColors.muted)),
              ])),
          StatusBadge(t.$3, kind: t.$4),
        ]),
      ),
    );
  }

  Widget _unlock(String tier, String body, bool current, {bool last = false}) =>
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: current ? const Color(0xFFFDF9F4) : null,
          border: last
              ? null
              : const Border(bottom: BorderSide(color: Color(0xFFF4EFE7))),
          borderRadius: current ? BorderRadius.circular(10) : null,
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(tier,
              style: AppTheme.dm(
                  size: 13,
                  weight: FontWeight.w700,
                  color: current ? const Color(0xFF9A7A22) : AppColors.navy)),
          const SizedBox(height: 4),
          Text(body,
              style:
                  AppTheme.dm(size: 12, color: AppColors.muted, height: 1.4)),
        ]),
      );
}
