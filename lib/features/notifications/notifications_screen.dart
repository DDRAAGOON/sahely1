import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/brand.dart';

// ====================================================== 40 · Lock Screen
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(fit: StackFit.expand, children: [
        Image.network('https://images.unsplash.com/photo-1765288116127-3c5a76fa2ba6?w=1200&q=75&auto=format&fit=crop', fit: BoxFit.cover, errorBuilder: (_, __, ___) => const ColoredBox(color: AppColors.navy)),
        const DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0x991B2744), Color(0x441B2744), Color(0xCC1B2744)]))),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(children: [
              const SizedBox(height: 8),
              _banner(headline: 'Door access ready 🔒', body: "You're within range of Lagoon Retreat — tap to reveal your passcode.", time: 'now', frosted: true),
              const SizedBox(height: 30),
              Text('Tuesday, 17 June', style: AppTheme.dm(size: 15, weight: FontWeight.w500, color: Colors.white)),
              Text('9:41', style: AppTheme.dm(size: 74, weight: FontWeight.w700, color: Colors.white, letterSpacing: -2)),
              const Spacer(),
              _banner(headline: 'Booking confirmed 🎉', body: 'Azure Beach Villa is booked for Jun 21–25. You earned 10 Sahel Stars.', time: 'now'),
              const SizedBox(height: 10),
              _banner(headline: 'You reached Wave Rider ⭐', body: '15% off all Concierge Services is now active this season.', time: '1h ago'),
              const SizedBox(height: 16),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                _circle(Icons.flashlight_on),
                Container(width: 120, height: 5, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(3))),
                _circle(Icons.camera_alt),
              ]),
              const SizedBox(height: 10),
            ]),
          ),
        ),
      ]),
    );
  }

  Widget _circle(IconData icon) => Container(width: 44, height: 44, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.18), shape: BoxShape.circle), child: Icon(icon, color: Colors.white, size: 20));

  static Widget _banner({required String headline, required String body, required String time, bool frosted = false}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: frosted ? 0.92 : 0.9), borderRadius: BorderRadius.circular(18)),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(width: 38, height: 38, decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(9)), child: const Padding(padding: EdgeInsets.all(5), child: SahelyLogo(size: 28))),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(headline, style: AppTheme.dm(size: 13, weight: FontWeight.w700, color: AppColors.navy)),
          const SizedBox(height: 2),
          Text(body, style: AppTheme.dm(size: 12, color: AppColors.ink, height: 1.35)),
        ])),
        const SizedBox(width: 8),
        Text(time, style: AppTheme.dm(size: 11, color: AppColors.muted)),
      ]),
    );
  }
}

// ====================================================== 40 · Banner anatomy
class BannerAnatomyScreen extends StatelessWidget {
  const BannerAnatomyScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.board,
      body: SafeArea(
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.fromLTRB(28, 40, 28, 28),
            decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(24)),
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('HOW NOTIFICATIONS READ', style: AppTheme.dm(size: 13, weight: FontWeight.w600, color: AppColors.gold, letterSpacing: 1)),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Container(width: 30, height: 30, decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(8)), child: const Padding(padding: EdgeInsets.all(4), child: SahelyLogo(size: 22))),
                    const SizedBox(width: 8),
                    Text('SAHELY', style: AppTheme.dm(size: 11, weight: FontWeight.w700, color: AppColors.navy, letterSpacing: 1)),
                    const Spacer(),
                    Text('now', style: AppTheme.dm(size: 11, color: AppColors.muted)),
                  ]),
                  const SizedBox(height: 10),
                  Text('New booking request', style: AppTheme.dm(size: 16, weight: FontWeight.w700, color: AppColors.navy)),
                  const SizedBox(height: 4),
                  Text('Omar K. wants to book Azure Beach Villa for Jun 21–25.', style: AppTheme.dm(size: 13, color: AppColors.ink, height: 1.4)),
                  const SizedBox(height: 12),
                  Row(children: [
                    Expanded(child: Container(height: 36, alignment: Alignment.center, decoration: BoxDecoration(color: AppColors.success, borderRadius: BorderRadius.circular(10)), child: Text('Approve', style: AppTheme.dm(size: 13, weight: FontWeight.w600, color: Colors.white)))),
                    const SizedBox(width: 10),
                    Expanded(child: Container(height: 36, alignment: Alignment.center, decoration: BoxDecoration(color: AppColors.cream, border: Border.all(color: const Color(0xFFD8D2C6)), borderRadius: BorderRadius.circular(10)), child: Text('Decline', style: AppTheme.dm(size: 13, weight: FontWeight.w600, color: AppColors.navy)))),
                  ]),
                ]),
              ),
              const SizedBox(height: 20),
              _rule(1, 'App icon + "SAHELY" on top.', 'Instantly recognisable in a crowded notification stack.'),
              _rule(2, 'Bold headline', '= what happened, then one line of context. Inline actions where useful.'),
              _rule(3, 'One emoji max,', 'only for celebratory moments (stars, level-ups).'),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _rule(int n, String bold, String rest) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(width: 22, height: 22, alignment: Alignment.center, decoration: const BoxDecoration(color: AppColors.gold, shape: BoxShape.circle), child: Text('$n', style: AppTheme.dm(size: 12, weight: FontWeight.w700, color: AppColors.navy))),
          const SizedBox(width: 12),
          Expanded(child: RichText(text: TextSpan(style: AppTheme.dm(size: 13, color: const Color(0xFFCDD4E0), height: 1.4), children: [
            TextSpan(text: '$bold ', style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white)),
            TextSpan(text: rest),
          ]))),
        ]),
      );
}

// ====================================================== 40 · Top banner
class TopBannerScreen extends StatelessWidget {
  const TopBannerScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(fit: StackFit.expand, children: [
        Image.network('https://images.unsplash.com/photo-1776762893024-890728937eab?w=1200&q=72&auto=format&fit=crop', fit: BoxFit.cover, errorBuilder: (_, __, ___) => const ColoredBox(color: AppColors.navy)),
        const DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xCC1B2744), Color(0x551B2744), Color(0xCC1B2744)]))),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(children: [
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.95), borderRadius: BorderRadius.circular(20)),
                child: Column(children: [
                  Container(width: 36, height: 4, decoration: BoxDecoration(color: const Color(0xFFD8D2C6), borderRadius: BorderRadius.circular(2))),
                  const SizedBox(height: 8),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Container(width: 38, height: 38, decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(9)), child: const Padding(padding: EdgeInsets.all(5), child: SahelyLogo(size: 28))),
                    const SizedBox(width: 10),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Omar approved your stay ✅', style: AppTheme.dm(size: 14, weight: FontWeight.w700, color: AppColors.navy)),
                      const SizedBox(height: 2),
                      Text('Azure Beach Villa · Jun 21–25 is confirmed. Tap to see details.', style: AppTheme.dm(size: 12, color: AppColors.ink, height: 1.35)),
                    ])),
                    Text('now', style: AppTheme.dm(size: 11, color: AppColors.muted)),
                  ]),
                ]),
              ),
              const Spacer(),
              Text('Heads-up banners slide in from the top while the renter is browsing — same anatomy: icon, name, headline, one line.', textAlign: TextAlign.center, style: AppTheme.dm(size: 13, color: Colors.white.withValues(alpha: 0.85), height: 1.5)),
              const SizedBox(height: 20),
            ]),
          ),
        ),
      ]),
    );
  }
}
