import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../widgets/buttons.dart';
import '../widgets/cards.dart';
import '../widgets/cream_background.dart';

class LevelUpScreen extends StatelessWidget {
  const LevelUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PhoneScaffold(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 128,
              height: 128,
              child: Stack(alignment: Alignment.center, children: [
                Container(
                    width: 104,
                    height: 104,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFF46B7A8), Color(0xFF226F66)]),
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(color: const Color(0xFF46B7A8).withOpacity(0.5), blurRadius: 30)
                        ]),
                    child: const Text('🌊', style: TextStyle(fontSize: 48))),
                Positioned(
                    right: 8,
                    bottom: 8,
                    child: Container(
                        width: 38,
                        height: 38,
                        decoration: const BoxDecoration(color: AppColors.navy, shape: BoxShape.circle),
                        child: const Icon(Icons.star, size: 20, color: AppColors.gold))),
              ]),
            ),
            const SizedBox(height: 18),
            Text('LEVEL 3 UNLOCKED',
                style: AppTheme.dm(size: 12, weight: FontWeight.w700, color: const Color(0xFF3A9B8E), letterSpacing: 3)),
            const SizedBox(height: 8),
            Text("You're a Wave Rider!", style: AppTheme.dm(size: 27, weight: FontWeight.w700, color: AppColors.navy)),
            const SizedBox(height: 10),
            Text('15% off all concierge services is now active for the rest of this season.',
                textAlign: TextAlign.center, style: AppTheme.dm(size: 14, color: AppColors.muted, height: 1.5)),
            const SizedBox(height: 18),
            WhiteCard(
              padding: const EdgeInsets.all(14),
              radius: 18,
              child: Row(children: [
                Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(color: const Color(0xFFFBF3DE), borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.chat_bubble_outline, color: AppColors.gold, size: 20)),
                const SizedBox(width: 12),
                Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('YOUR UNLOCK REWARD',
                      style: AppTheme.dm(size: 11, weight: FontWeight.w700, color: const Color(0xFF9A7A22))),
                  Text('Priority WhatsApp Support',
                      style: AppTheme.dm(size: 15, weight: FontWeight.w700, color: AppColors.navy)),
                ])),
              ]),
            ),
            const SizedBox(height: 12),
            const Row(children: [
              Expanded(child: StatCard(value: '47 ★', label: 'This season', valueColor: AppColors.gold)),
              SizedBox(width: 12),
              Expanded(child: StatCard(value: '33', label: '★ to Level 4')),
            ]),
            const SizedBox(height: 18),
            NavyButton(label: 'Share achievement', radius: 999, onTap: () => Navigator.maybePop(context)),
            const SizedBox(height: 14),
            GestureDetector(
                onTap: () => Navigator.maybePop(context),
                child: Text('Keep exploring',
                    style: AppTheme.dm(size: 14, weight: FontWeight.w600, color: AppColors.muted))),
          ],
        ),
      ),
    );
  }
}
