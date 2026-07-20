import 'package:flutter/material.dart';

import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/widgets/kit.dart';

class ReferralIssuePage extends StatelessWidget {
  const ReferralIssuePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PhoneScaffold(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        children: [
          const TopBar(title: 'Listing Issue'),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
                color: const Color(0xFFFDECEC),
                border: Border.all(color: const Color(0xFFF3C0C0)),
                borderRadius: BorderRadius.circular(16)),
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
                    Text('Needs better photos',
                        style: AppTheme.dm(
                            size: 15,
                            weight: FontWeight.w700,
                            color: const Color(0xFFB22222))),
                    Text('Flagged by review team · Jun 17',
                        style: AppTheme.dm(
                            size: 12, color: const Color(0xFF8A3A3A))),
                  ])),
            ]),
          ),
          const SizedBox(height: 14),
          WhiteCard(
              padding: const EdgeInsets.all(12),
              child: Row(children: [
                Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                        color: AppColors.cardWarm,
                        borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.home_outlined,
                        color: AppColors.muted)),
                const SizedBox(width: 12),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text('Marina Loft',
                          style: AppTheme.dm(
                              size: 14,
                              weight: FontWeight.w700,
                              color: AppColors.navy)),
                      Text('Apartment · Marina · via KARIM-4821',
                          style: AppTheme.dm(size: 12, color: AppColors.muted)),
                    ])),
              ])),
          const SizedBox(height: 16),
          Text('What the team needs',
              style: AppTheme.dm(
                  size: 14, weight: FontWeight.w700, color: AppColors.navy)),
          const SizedBox(height: 8),
          WhiteCard(
              child: Column(children: [
            _needBullet('Daylight photos of the living room'),
            _needBullet('Balcony & sea-view shot'),
            _needBullet('Compound layout with unit marked', last: true),
          ])),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: const Color(0xFFFBF3DE),
                border: Border.all(color: const Color(0xFFEAD9A8)),
                borderRadius: BorderRadius.circular(12)),
            child: Row(children: [
              const Icon(Icons.auto_awesome, size: 18, color: AppColors.gold),
              const SizedBox(width: 10),
              Expanded(
                  child: RichText(
                      text: TextSpan(
                          style: AppTheme.dm(
                              size: 12,
                              color: const Color(0xFF8A6A1E),
                              height: 1.4),
                          children: const [
                    TextSpan(text: 'Sahely AI: '),
                    TextSpan(
                        text:
                            'Reach out to Tarek — a quick morning re-shoot usually clears this within a day.',
                        style: TextStyle(fontWeight: FontWeight.w700))
                  ]))),
            ]),
          ),
          const SizedBox(height: 16),
          Text("Why it isn't listed yet",
              style: AppTheme.dm(
                  size: 14, weight: FontWeight.w700, color: AppColors.navy)),
          const SizedBox(height: 8),
          WhiteCard(
              padding: const EdgeInsets.all(14),
              child: RichText(
                  text: TextSpan(
                      style: AppTheme.dm(
                          size: 13, color: AppColors.ink, height: 1.5),
                      children: const [
                    TextSpan(
                        text:
                            "The review team paused this listing because the current photos don't meet Sahely's quality bar — they're low-light and don't show the full space, so guests can't see what they're booking. The listing stays "),
                    TextSpan(
                        text: 'offline',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                    TextSpan(
                        text:
                            ' until the items above are added and it passes a re-review (about 24h). No commission is earned while a referred property is offline.'),
                  ]))),
          const SizedBox(height: 14),
          const StatRow(cards: [
            StatCard(
                value: 'Offline',
                label: 'Status',
                valueColor: Color(0xFFB22222)),
            StatCard(value: 'Jun 17', label: 'Flagged'),
            StatCard(value: '~24h', label: 'Re-review')
          ]),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: const Color(0xFFFBF3DE),
                border: Border.all(color: const Color(0xFFEAD9A8)),
                borderRadius: BorderRadius.circular(12)),
            child: Row(children: [
              Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                      color: AppColors.gold.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10)),
                  child:
                      const Icon(Icons.phone_outlined, color: AppColors.gold)),
              const SizedBox(width: 12),
              Expanded(
                  child: RichText(
                      text: TextSpan(
                          style: AppTheme.dm(
                              size: 12,
                              color: const Color(0xFF8A6A1E),
                              height: 1.4),
                          children: const [
                    TextSpan(text: 'Reach out to the owner, '),
                    TextSpan(
                        text: 'Tarek S.',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                    TextSpan(
                        text:
                            ', and help them add what\'s needed — a quick morning re-shoot usually clears this so you both start earning.')
                  ]))),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _needBullet(String text, {bool last = false}) => Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: last
            ? null
            : const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFFF4EFE7)))),
        child: Row(children: [
          Container(
              width: 22,
              height: 22,
              decoration: const BoxDecoration(
                  color: Color(0xFFD2760A), shape: BoxShape.circle),
              child: const Icon(Icons.priority_high,
                  size: 14, color: Colors.white)),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: AppTheme.dm(size: 13))),
        ]),
      );
}
