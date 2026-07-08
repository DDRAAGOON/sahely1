import 'package:flutter/material.dart';
import 'package:sahely/data/sample_data.dart';
import 'package:sahely/theme/app_colors.dart';
import 'package:sahely/theme/app_theme.dart';
import 'package:sahely/widgets/chips.dart';
import 'package:sahely/widgets/common.dart';
import 'package:sahely/widgets/cream_background.dart';
import 'package:sahely/widgets/kit.dart';
import 'package:sahely/widgets/ui.dart';

class ReferredPropertiesScreen extends StatelessWidget {
  const ReferredPropertiesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return PhoneScaffold(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
        children: [
          const TopBar(title: 'Referred Properties', subtitle: '51 accepted & live · guest-ready'),
          const SizedBox(height: 12),
          Text('Only properties accepted by Sahely and live for guests appear here — with the details renters see.', style: AppTheme.dm(size: 12, color: AppColors.muted)),
          const SizedBox(height: 12),
          SizedBox(height: 32, child: ListView(scrollDirection: Axis.horizontal, children: const [
            ChoiceChipPill('All 55', selected: true, height: 32), SizedBox(width: 8),
            ChoiceChipPill('Active 51', height: 32), SizedBox(width: 8),
            ChoiceChipPill('Not listed 4', height: 32),
          ])),
          const SizedBox(height: 14),
          _refCard(context, Sample.azure.image, 'Azure Beach Villa', 'Hacienda Bay', 4.8, 124, 4500, const ['Villa', '6 Guests', 'Pool', '🐾 Pets']),
          const SizedBox(height: 12),
          _refCard(context, Sample.lagoon.image, 'Lagoon Retreat', 'Marassi', 4.9, 86, 6200, const ['Chalet', '8 Guests', 'Sea view']),
          const SizedBox(height: 12),
          _refCard(context, Sample.dunes.image, 'Golden Dunes', 'Marassi', 4.7, 53, 3800, const ['Villa', '4 Guests', 'Beach']),
        ],
      ),
    );
  }

  Widget _refCard(BuildContext context, String img, String name, String area, double rating, int reviews, int price, List<String> tags) => GestureDetector(
        onTap: () => Navigator.pushNamed(context, '/broker/referred-detail'),
        child: WhiteCard(
          padding: EdgeInsets.zero,
          radius: 18,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(height: 140, width: double.infinity, child: Stack(fit: StackFit.expand, children: [
                Image.network(img, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const ColoredBox(color: AppColors.cardWarm)),
                const DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Color(0x991B2744)]))),
                const Positioned(top: 10, right: 10, child: StatusBadge('Accepted · Live', kind: BadgeKind.green, dot: true)),
                Positioned(left: 14, bottom: 12, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(name, style: AppTheme.dm(size: 16, weight: FontWeight.w700, color: Colors.white)),
                  Text(area, style: AppTheme.dm(size: 11, color: Colors.white70)),
                ])),
              ])),
              Padding(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [RatingRow(rating: rating, reviews: reviews), PriceTag(price: price)]),
                const SizedBox(height: 10),
                Wrap(spacing: 7, runSpacing: 7, children: [for (final t in tags) Pill(t, border: AppColors.border, fg: AppColors.subtle)]),
              ])),
            ]),
          ),
        ),
      );
}

class ReferredPropertyDetailScreen extends StatelessWidget {
  const ReferredPropertyDetailScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: CreamBackground(
        child: ListView(padding: EdgeInsets.zero, children: [
          Stack(children: [
            SizedBox(height: 200, width: double.infinity, child: Image.network(Sample.azure.image, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const ColoredBox(color: AppColors.cardWarm))),
            Positioned(top: 44, left: 16, child: GestureDetector(onTap: () => Navigator.maybePop(context), child: Container(width: 34, height: 34, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.92), shape: BoxShape.circle), child: const Icon(Icons.chevron_left, color: AppColors.navy)))),
            const Positioned(top: 50, right: 16, child: StatusBadge('Live', kind: BadgeKind.green, dot: true)),
            Positioned(left: 18, bottom: 14, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Azure Beach Villa', style: AppTheme.dm(size: 20, weight: FontWeight.w700, color: Colors.white)),
              Text('Hacienda Bay · North Coast', style: AppTheme.dm(size: 12, color: Colors.white70)),
            ])),
          ]),
          Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Wrap(spacing: 7, runSpacing: 7, children: [Pill('Villa', border: AppColors.navy), Pill('320 m²', border: AppColors.navy), Pill('6 Guests', border: AppColors.navy), Pill('Pool', border: AppColors.navy)]),
            const SizedBox(height: 16),
            Text('Owner', style: AppTheme.dm(size: 15, weight: FontWeight.w700, color: AppColors.navy)),
            const SizedBox(height: 8),
            WhiteCard(padding: const EdgeInsets.all(14), child: Row(children: [
              const AvatarCircle(size: 44, colors: [Color(0xFFC9A84C), Color(0xFF8A7330)]),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Layla Mansour', style: AppTheme.dm(size: 14, weight: FontWeight.w700, color: AppColors.navy)),
                Text('Established Host · joined 2023', style: AppTheme.dm(size: 12, color: AppColors.muted)),
              ])),
            ])),
            const SizedBox(height: 16),
            Text('Availability', style: AppTheme.dm(size: 15, weight: FontWeight.w700, color: AppColors.navy)),
            const SizedBox(height: 8),
            const AvailabilityCalendar(blocked: [4, 5, 6], ongoing: [14, 15, 16, 17, 18], upcoming: [21, 22, 23, 24, 25]),
            const SizedBox(height: 16),
            Text('Your earnings from this property', style: AppTheme.dm(size: 15, weight: FontWeight.w700, color: AppColors.navy)),
            const SizedBox(height: 8),
            const WhiteCard(padding: EdgeInsets.all(14), child: Column(children: [
              KeyValueRow('Your commission rate', '4%'),
              KeyValueRow('Bookings (season)', '24'),
              KeyValueRow('Nights rented', '96'),
              KeyValueRow('Commission earned', 'EGP 41,200', valueColor: AppColors.success),
              KeyValueRow('Pending commission', 'EGP 2,400', valueColor: Color(0xFFD2760A)),
            ])),
            const SizedBox(height: 16),
            Text('Listing performance', style: AppTheme.dm(size: 15, weight: FontWeight.w700, color: AppColors.navy)),
            const SizedBox(height: 8),
            const StatRow(cards: [StatCard(value: '★ 4.8', label: '124 reviews'), StatCard(value: '88%', label: 'Occupancy'), StatCard(value: '1.2k', label: 'Views/wk')]),
            const SizedBox(height: 16),
            NavyButton(label: 'View public listing', radius: 14, onTap: () => Navigator.pushNamed(context, '/property')),
          ])),
        ]),
      ),
    );
  }
}

class ReferralIssueScreen extends StatelessWidget {
  const ReferralIssueScreen({super.key});
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
            decoration: BoxDecoration(color: const Color(0xFFFDECEC), border: Border.all(color: const Color(0xFFF3C0C0)), borderRadius: BorderRadius.circular(16)),
            child: Row(children: [
              Container(width: 40, height: 40, decoration: BoxDecoration(color: const Color(0xFFB22222), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.warning_amber_rounded, color: Colors.white)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Needs better photos', style: AppTheme.dm(size: 15, weight: FontWeight.w700, color: const Color(0xFFB22222))),
                Text('Flagged by review team · Jun 17', style: AppTheme.dm(size: 12, color: const Color(0xFF8A3A3A))),
              ])),
            ]),
          ),
          const SizedBox(height: 14),
          WhiteCard(padding: const EdgeInsets.all(12), child: Row(children: [
            Container(width: 44, height: 44, decoration: BoxDecoration(color: AppColors.cardWarm, borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.home_outlined, color: AppColors.muted)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Marina Loft', style: AppTheme.dm(size: 14, weight: FontWeight.w700, color: AppColors.navy)),
              Text('Apartment · Marina · via KARIM-4821', style: AppTheme.dm(size: 12, color: AppColors.muted)),
            ])),
          ])),
          const SizedBox(height: 16),
          Text('What the team needs', style: AppTheme.dm(size: 14, weight: FontWeight.w700, color: AppColors.navy)),
          const SizedBox(height: 8),
          WhiteCard(child: Column(children: [
            _needBullet('Daylight photos of the living room'),
            _needBullet('Balcony & sea-view shot'),
            _needBullet('Compound layout with unit marked', last: true),
          ])),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFFFBF3DE), border: Border.all(color: const Color(0xFFEAD9A8)), borderRadius: BorderRadius.circular(12)),
            child: Row(children: [
              const Icon(Icons.auto_awesome, size: 18, color: AppColors.gold),
              const SizedBox(width: 10),
              Expanded(child: RichText(text: TextSpan(style: AppTheme.dm(size: 12, color: const Color(0xFF8A6A1E), height: 1.4), children: const [TextSpan(text: 'Sahely AI: '), TextSpan(text: 'Reach out to Tarek — a quick morning re-shoot usually clears this within a day.', style: TextStyle(fontWeight: FontWeight.w700))]))),
            ]),
          ),
          const SizedBox(height: 16),
          Text("Why it isn't listed yet", style: AppTheme.dm(size: 14, weight: FontWeight.w700, color: AppColors.navy)),
          const SizedBox(height: 8),
          WhiteCard(padding: const EdgeInsets.all(14), child: RichText(text: TextSpan(style: AppTheme.dm(size: 13, color: AppColors.ink, height: 1.5), children: const [
            TextSpan(text: "The review team paused this listing because the current photos don't meet Sahely's quality bar — they're low-light and don't show the full space, so guests can't see what they're booking. The listing stays "),
            TextSpan(text: 'offline', style: TextStyle(fontWeight: FontWeight.w700)),
            TextSpan(text: ' until the items above are added and it passes a re-review (about 24h). No commission is earned while a referred property is offline.'),
          ]))),
          const SizedBox(height: 14),
          const StatRow(cards: [StatCard(value: 'Offline', label: 'Status', valueColor: Color(0xFFB22222)), StatCard(value: 'Jun 17', label: 'Flagged'), StatCard(value: '~24h', label: 'Re-review')]),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFFFBF3DE), border: Border.all(color: const Color(0xFFEAD9A8)), borderRadius: BorderRadius.circular(12)),
            child: Row(children: [
              Container(width: 38, height: 38, decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.phone_outlined, color: AppColors.gold)),
              const SizedBox(width: 12),
              Expanded(child: RichText(text: TextSpan(style: AppTheme.dm(size: 12, color: const Color(0xFF8A6A1E), height: 1.4), children: const [TextSpan(text: 'Reach out to the owner, '), TextSpan(text: 'Tarek S.', style: TextStyle(fontWeight: FontWeight.w700)), TextSpan(text: ', and help them add what\'s needed — a quick morning re-shoot usually clears this so you both start earning.')]))),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _needBullet(String text, {bool last = false}) => Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: last ? null : const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFF4EFE7)))),
        child: Row(children: [
          Container(width: 22, height: 22, decoration: const BoxDecoration(color: Color(0xFFD2760A), shape: BoxShape.circle), child: const Icon(Icons.priority_high, size: 14, color: Colors.white)),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: AppTheme.dm(size: 13))),
        ]),
      );
}
