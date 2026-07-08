import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../widgets/cards.dart';
import '../widgets/cream_background.dart';
import '../widgets/forms.dart';


class MawsemDashboardScreen extends StatelessWidget {
  const MawsemDashboardScreen({super.key});

  static const _earn = [
    ('Verify your identity', 'One-time · ID + live selfie', '+5 ★', false),
    ('Complete first booking', 'One-time · must check in', '+10 ★', false),
    ('Refer a friend who stays', 'Per friend · must complete a stay', '+15 ★', false),
    ('Complete arrival checklist', 'Per stay', '+5 ★', false),
    ('Review with text + photo', 'Per stay · both required', '+5 ★', false),
    ('Share on IG Stories @sahelyeg', 'Per stay · keep up 24h+', '+5 ★', false),
    ('Book a concierge service', 'Per service', '+3 ★', false),
    ('Stay 3+ nights · or book off-peak', 'Bonus per stay (each)', '+5 ★', false),
    ('Come back · 2nd / 3rd+ booking', 'Loyalty bonus', '+10–15 ★', false),
    ('Refer an owner who lists', 'Huge · one-time', '+50 ★', true),
  ];

  @override
  Widget build(BuildContext context) {
    return PhoneScaffold(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        children: [
          // Hero
          Container(
            padding: const EdgeInsets.all(18), // Slightly reduced padding
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Color(0xFF22335A), Color(0xFF111A30)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Flexible(
                  child: Text('AL MAWSEM',
                      style: AppTheme.dm(size: 15, weight: FontWeight.w700, color: AppColors.gold, letterSpacing: 2)),
                ),
                const SizedBox(width: 8),
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration:
                        BoxDecoration(color: AppColors.gold.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                    child: Text('Season 2026 · Battle Pass', style: AppTheme.dm(size: 10, color: AppColors.gold))),
              ]),
              const SizedBox(height: 12),
              Row(children: [
                Container(
                    width: 52, // Smaller icon
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFF46B7A8), Color(0xFF226F66)]),
                        borderRadius: BorderRadius.circular(12)),
                    child: const Text('🌊', style: TextStyle(fontSize: 22))),
                const SizedBox(width: 12),
                Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Level 3 of 7', style: AppTheme.dm(size: 11, color: const Color(0xFF9FB0CF))),
                  Text('Wave Rider', style: AppTheme.dm(size: 19, weight: FontWeight.w700, color: Colors.white)),
                ])),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text('47', style: AppTheme.dm(size: 22, weight: FontWeight.w700, color: AppColors.gold)),
                  Text('★ Sahel Stars', style: AppTheme.dm(size: 10, color: AppColors.gold)),
                ]),
              ]),
              const SizedBox(height: 12),
              ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                      value: 0.58,
                      minHeight: 6, // Thinner bar
                      backgroundColor: Colors.white.withOpacity(0.15),
                      valueColor: const AlwaysStoppedAnimation(AppColors.gold))),
              const SizedBox(height: 8),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                RichText(
                    text: TextSpan(style: AppTheme.dm(size: 11, color: const Color(0xFF9FB0CF)), children: const [
                  TextSpan(text: '33 ★', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.gold)),
                  TextSpan(text: ' to Coastal Regular')
                ])),
                Text('80 ★', style: AppTheme.dm(size: 11, color: const Color(0xFF9FB0CF))),
              ]),
              const SizedBox(height: 10),
              Row(children: [
                _heroPill(Icons.schedule, 'Ends in 87 days'),
                const SizedBox(width: 8),
                _heroPill(Icons.refresh, 'Resets each season'),
              ]),
            ]),
          ),
          const SizedBox(height: 18),
          Text('The 7 Levels', style: AppTheme.dm(size: 16, weight: FontWeight.w700, color: AppColors.navy)),
          Text('tap a level for perks', style: AppTheme.dm(size: 12, color: AppColors.muted)),
          const SizedBox(height: 12),
          for (var i = 0; i < _levels.length; i++) ...[
            _LevelRow(
                index: i + 1, data: _levels[i], current: i == 2, onTap: () => Navigator.pushNamed(context, '/mawsem-level')),
            const SizedBox(height: 8),
          ],
          const SizedBox(height: 10),
          Text('How to Earn Stars', style: AppTheme.dm(size: 16, weight: FontWeight.w700, color: AppColors.navy)),
          Text('Do more, climb faster. Stars reset every season.', style: AppTheme.dm(size: 12, color: AppColors.muted)),
          const SizedBox(height: 12),
          WhiteCard(
            child: Column(children: [
              for (var i = 0; i < _earn.length; i++) _earnRow(_earn[i], last: i == _earn.length - 1),
            ]),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(16)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const Icon(Icons.content_copy, size: 16, color: AppColors.gold),
                const SizedBox(width: 8),
                Text('Your referral code', style: AppTheme.dm(size: 13, weight: FontWeight.w600, color: Colors.white))
              ]),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(
                    child: DottedBorder(
                        color: AppColors.gold,
                        radius: 10,
                        child: Container(
                            height: 44,
                            alignment: Alignment.center,
                            child: Text('MARIAM-50',
                                style: AppTheme.dm(
                                    size: 17, weight: FontWeight.w700, color: AppColors.gold, letterSpacing: 1))))),
                const SizedBox(width: 10),
                Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(color: AppColors.gold, borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.copy, color: AppColors.navy, size: 18)),
              ]),
              const SizedBox(height: 10),
              RichText(
                  text: TextSpan(style: AppTheme.dm(size: 11, color: const Color(0xFFCDD4E0), height: 1.5), children: const [
                TextSpan(text: 'Share it — when a friend you refer '),
                TextSpan(text: 'books & completes a stay', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white)),
                TextSpan(text: ' you earn '),
                TextSpan(text: '+15★', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.gold)),
                TextSpan(text: '. Refer an owner who lists and earn '),
                TextSpan(text: '+50★', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.gold)),
                TextSpan(text: '. No stars for signups alone.'),
              ])),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _heroPill(IconData icon, String label) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.08), borderRadius: BorderRadius.circular(999)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 13, color: const Color(0xFF9FB0CF)),
          const SizedBox(width: 6),
          Text(label, style: AppTheme.dm(size: 11, color: const Color(0xFF9FB0CF)))
        ]),
      );

  static const _levels = [
    ('Beach Walker', 'Standard booking & dashboard', '0 ★'),
    ('Shore Explorer', 'Late checkout + early check-in', '15 ★'),
    ('Wave Rider', '15% off concierge + priority support', '40 ★'),
    ('Coastal Regular', 'Welcome basket + 200 EGP credit', '80 ★'),
    ('Sand VIP', 'Free cleaning + airport pickup', '140 ★'),
    ('Elite Coaster', 'Free concierge + 3 cancel tokens', '220 ★'),
    ('Sahely Ambassador', 'Free weekend + season party invite', '500 ★'),
  ];

  Widget _earnRow((String, String, String, bool) e, {bool last = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 4),
      decoration: BoxDecoration(
        color: e.$4 ? const Color(0xFFFBF3DE) : null,
        border: last ? null : const Border(bottom: BorderSide(color: Color(0xFFF4EFE7))),
        borderRadius: e.$4 ? BorderRadius.circular(10) : null,
      ),
      child: Row(children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(e.$1, style: AppTheme.dm(size: 13, weight: FontWeight.w600, color: AppColors.ink)),
            Text(e.$2, style: AppTheme.dm(size: 11, color: AppColors.muted)),
          ]),
        ),
        Text(e.$3,
            style: AppTheme.dm(size: 13, weight: FontWeight.w700, color: e.$4 ? const Color(0xFF9A7A22) : AppColors.gold)),
      ]),
    );
  }
}

class _LevelRow extends StatelessWidget {
  const _LevelRow({required this.index, required this.data, required this.current, this.onTap});
  final int index;
  final (String, String, String) data;
  final bool current;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    final reached = index <= 2;
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: (reached && !current) ? 0.7 : 1,
        child: Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: current ? AppColors.navy : AppColors.white,
            border: current ? Border.all(color: AppColors.gold) : null,
            borderRadius: BorderRadius.circular(13),
            boxShadow: current ? null : const [BoxShadow(color: Color(0x0F1B2744), blurRadius: 10)],
          ),
          child: Row(children: [
            Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: current ? const Color(0xFF46B7A8) : AppColors.cardWarm, borderRadius: BorderRadius.circular(10)),
                child: Text('$index',
                    style: AppTheme.dm(
                        size: 14, weight: FontWeight.w700, color: current ? Colors.white : AppColors.navy))),
            const SizedBox(width: 12),
            Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text(data.$1, style: AppTheme.dm(size: 14, weight: FontWeight.w700, color: current ? Colors.white : AppColors.navy)),
                if (current) ...[
                  const SizedBox(width: 8),
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(color: AppColors.gold, borderRadius: BorderRadius.circular(8)),
                      child: Text('YOU', style: AppTheme.dm(size: 9, weight: FontWeight.w700, color: AppColors.navy)))
                ],
              ]),
              const SizedBox(height: 2),
              Text(data.$2, style: AppTheme.dm(size: 11, color: current ? const Color(0xFFCDD4E0) : AppColors.muted)),
            ])),
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                    color: current
                        ? AppColors.gold
                        : (reached ? const Color(0xFFD7EEDD) : const Color(0xFFFBF3DE)),
                    borderRadius: BorderRadius.circular(8)),
                child: Text(data.$3,
                    style: AppTheme.dm(
                        size: 11,
                        weight: FontWeight.w700,
                        color: current ? AppColors.navy : (reached ? AppColors.success : const Color(0xFF9A7A22))))),
          ]),
        ),
      ),
    );
  }
}
