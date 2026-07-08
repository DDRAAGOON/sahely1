import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import 'package:sahely/features/shared/widgets/success_check.dart';
import 'package:sahely/features/shared/widgets/ui.dart';

class StarsEarnedScreen extends StatelessWidget {
  const StarsEarnedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(children: [
        Positioned.fill(child: DecoratedBox(decoration: BoxDecoration(color: AppColors.navy.withOpacity(0.85)))),
        Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 28),
            padding: const EdgeInsets.fromLTRB(24, 30, 24, 24),
            decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(24)),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const SuccessCheck(gold: true, size: 110),
              const SizedBox(height: 12),
              Text('+5 ★', style: AppTheme.dm(size: 40, weight: FontWeight.w700, color: AppColors.gold)),
              const SizedBox(height: 4),
              Text('Stars earned!', style: AppTheme.dm(size: 20, weight: FontWeight.w700, color: AppColors.navy)),
              const SizedBox(height: 8),
              RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(style: AppTheme.dm(size: 13, color: AppColors.muted), children: const [
                    TextSpan(text: 'For leaving a review with a photo at '),
                    TextSpan(text: 'Lagoon Retreat', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.ink))
                  ])),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppColors.cream, borderRadius: BorderRadius.circular(12)),
                child: Column(children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('Season total', style: AppTheme.dm(size: 13, color: AppColors.muted)),
                    Text('47 → 52 ★', style: AppTheme.dm(size: 13, weight: FontWeight.w700, color: AppColors.navy)),
                  ]),
                  const SizedBox(height: 8),
                  ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: const LinearProgressIndicator(
                          value: 0.65,
                          minHeight: 7,
                          backgroundColor: AppColors.border,
                          valueColor: AlwaysStoppedAnimation(AppColors.gold))),
                  const SizedBox(height: 8),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text('28 ★ to Coastal Regular',
                          style: AppTheme.dm(size: 12, weight: FontWeight.w600, color: const Color(0xFF9A7A22)))),
                ]),
              ),
              const SizedBox(height: 16),
              NavyButton(label: 'Keep earning', onTap: () => Navigator.maybePop(context)),
            ]),
          ),
        ),
      ]),
    );
  }
}
