import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/image.dart';

class StarNudgesScreen extends StatelessWidget {
  const StarNudgesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(fit: StackFit.expand, children: [
        AppNetworkImage(
            url:
                'https://images.unsplash.com/photo-1707075108813-edefd7b3308d?w=1200&q=72&auto=format&fit=crop',
            errorWidget: (_, __, ___) =>
                const ColoredBox(color: AppColors.navy)),
        const DecoratedBox(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
              Color(0xCC1B2744),
              Color(0x661B2744),
              Color(0xEE1B2744)
            ]))),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              _nudge(
                  const Color(0xFFFBF3DE),
                  const Icon(Icons.star, color: AppColors.gold, size: 20),
                  'Leave a review · earn +5 ★',
                  'Add a photo to your Lagoon stay',
                  'Review'),
              const SizedBox(height: 10),
              _nudge(
                  AppColors.navy,
                  const Icon(Icons.person_add_alt,
                      color: AppColors.gold, size: 20),
                  'Invite a friend · earn +15 ★',
                  'When they book & stay',
                  'Invite',
                  dark: true),
              const SizedBox(height: 10),
              _nudge(
                  const Color(0xFF3A9B8E),
                  const Icon(Icons.notifications_none,
                      color: Colors.white, size: 20),
                  'Add a concierge · earn +3 ★',
                  'Chef, BBQ or grocery setup',
                  'Browse',
                  tileColor: const Color(0xFF3A9B8E)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                    color: AppColors.navy,
                    borderRadius: BorderRadius.circular(16)),
                child: Row(children: [
                  Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          color: AppColors.gold.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.star, color: AppColors.gold)),
                  const SizedBox(width: 12),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text("You're 28 ★ from Coastal Regular",
                            style: AppTheme.dm(
                                size: 13,
                                weight: FontWeight.w700,
                                color: Colors.white)),
                        Text('2 referrals would get you there',
                            style:
                                AppTheme.dm(size: 11, color: AppColors.gold)),
                      ])),
                ]),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                  onTap: () => Navigator.maybePop(context),
                  child: Container(
                      padding: const EdgeInsets.all(8),
                      child: const Text('Dismiss',
                          style: TextStyle(color: Colors.white70)))),
            ]),
          ),
        ),
      ]),
    );
  }

  Widget _nudge(Color bg, Widget icon, String title, String sub, String action,
      {bool dark = false, Color? tileColor}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: dark ? AppColors.navy : Colors.white.withValues(alpha: 0.96),
          borderRadius: BorderRadius.circular(16)),
      child: Row(children: [
        Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
                color: dark
                    ? AppColors.navy
                    : (tileColor ?? const Color(0xFFFBF3DE)),
                borderRadius: BorderRadius.circular(10),
                border: dark ? Border.all(color: Colors.white24) : null),
            child: icon),
        const SizedBox(width: 12),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style: AppTheme.dm(
                  size: 13,
                  weight: FontWeight.w700,
                  color: dark ? Colors.white : AppColors.navy)),
          Text(sub,
              style: AppTheme.dm(
                  size: 11, color: dark ? Colors.white60 : AppColors.muted)),
        ])),
        Text(action,
            style: AppTheme.dm(
                size: 12, weight: FontWeight.w700, color: AppColors.gold)),
      ]),
    );
  }
}
