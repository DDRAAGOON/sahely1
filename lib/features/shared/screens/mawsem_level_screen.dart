import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/sheet_handle.dart';
import 'package:sahely/core/widgets/fill_viewport.dart';

class MawsemLevelScreen extends StatelessWidget {
  const MawsemLevelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(children: [
        const Positioned.fill(child: ColoredBox(color: Color(0x731B2744))),
        Align(
          alignment: Alignment.bottomCenter,
          child: FractionallySizedBox(
            heightFactor: 0.72,
            child: Container(
              decoration: const BoxDecoration(
                  color: AppColors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20))),
              padding: const EdgeInsets.fromLTRB(22, 0, 22, 22),
              child: FillViewport(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    const SheetHandle(),
                    const SizedBox(height: 8),
                    Row(children: [
                      Container(
                          width: 56,
                          height: 56,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [
                                Color(0xFF8A6DB0),
                                Color(0xFF5A3F7A)
                              ]),
                              borderRadius: BorderRadius.circular(14)),
                          child: const Icon(Icons.emoji_events_outlined,
                              color: Colors.white, size: 26)),
                      const SizedBox(width: 12),
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Text('Sand VIP',
                                style: AppTheme.dm(
                                    size: 18,
                                    weight: FontWeight.w700,
                                    color: AppColors.navy)),
                            Text('140 ★ to unlock',
                                style: AppTheme.dm(
                                    size: 13, color: AppColors.muted)),
                          ])),
                      GestureDetector(
                          onTap: () => Navigator.maybePop(context),
                          child: Container(
                              width: 28,
                              height: 28,
                              decoration: const BoxDecoration(
                                  color: Color(0xFFF0EBE2),
                                  shape: BoxShape.circle),
                              child: const Icon(Icons.close,
                                  size: 16, color: AppColors.navy))),
                    ]),
                    const SizedBox(height: 14),
                    Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color: const Color(0xFFF0EBE2),
                            borderRadius: BorderRadius.circular(10)),
                        width: double.infinity,
                        child: Text('93 ★ more to unlock',
                            style: AppTheme.dm(
                                size: 13,
                                weight: FontWeight.w600,
                                color: AppColors.muted))),
                    const SizedBox(height: 16),
                    Text('Season Perks',
                        style: AppTheme.dm(
                            size: 14,
                            weight: FontWeight.w700,
                            color: AppColors.navy)),
                    const SizedBox(height: 10),
                    _perk('Free Professional Cleaning', 'This season only'),
                    _perk('Early access to new listings (48h)',
                        'This season only'),
                    _perk('Everything from Coastal Regular',
                        'Welcome basket + beach setup'),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                          color: AppColors.navy,
                          borderRadius: BorderRadius.circular(14)),
                      width: double.infinity,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Your Unlock Reward',
                                style: AppTheme.dm(
                                    size: 12, color: AppColors.gold)),
                            const SizedBox(height: 4),
                            Text('Free Airport Pickup — Cairo to compound',
                                style: AppTheme.dm(
                                    size: 15,
                                    weight: FontWeight.w700,
                                    color: Colors.white)),
                          ]),
                    ),
                  ])),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _perk(String title, String sub) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(children: [
          Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                  color: const Color(0xFFEDE3F2),
                  borderRadius: BorderRadius.circular(9)),
              child:
                  const Icon(Icons.check, size: 16, color: Color(0xFF6B4D8A))),
          const SizedBox(width: 10),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(title,
                    style: AppTheme.dm(size: 13, weight: FontWeight.w600)),
                Text(sub, style: AppTheme.dm(size: 11, color: AppColors.muted)),
              ])),
        ]),
      );
}
