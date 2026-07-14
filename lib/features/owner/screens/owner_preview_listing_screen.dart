import 'package:flutter/material.dart';
import '../../../data/sample_data.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/common.dart';
import '../../../core/widgets/kit.dart';
import '../../../core/widgets/ui.dart';

class OwnerPreviewListingScreen extends StatelessWidget {
  const OwnerPreviewListingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return PhoneScaffold(
      child: Column(children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            children: [
              const TopBar(title: 'Listing status', subtitle: 'How guests see Azure Beach Villa'),
              const SizedBox(height: 16),
              WhiteCard(
                padding: EdgeInsets.zero,
                radius: 16,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    SizedBox(height: 170, width: double.infinity, child: Stack(fit: StackFit.expand, children: [
                      Image.network(Sample.azure.image, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const ColoredBox(color: AppColors.cardWarm)),
                      const Positioned(top: 10, left: 10, child: StatusBadge('Live · Bookable', kind: BadgeKind.green, dot: true)),
                      const Positioned(top: 10, right: 10, child: SaveHeart(property: Sample.azure)),
                    ])),
                    Padding(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Azure Beach Villa', style: AppTheme.dm(size: 16, weight: FontWeight.w700, color: AppColors.navy)),
                      Text('Hacienda Bay · North Coast', style: AppTheme.dm(size: 12, color: AppColors.muted)),
                      const SizedBox(height: 8),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('★ 4.8 · 124 reviews · 88% occupancy', style: AppTheme.dm(size: 12, color: AppColors.muted)),
                        const PriceTag(price: 4500, size: 15),
                      ]),
                      const SizedBox(height: 10),
                      const Wrap(spacing: 7, runSpacing: 7, children: [Pill('Villa', border: AppColors.navy), Pill('6 Guests', border: AppColors.navy), Pill('Pool', border: AppColors.navy), Pill('🐾 Pets', bg: Color(0xFFD7EEDD), fg: AppColors.success)]),
                    ])),
                  ]),
                ),
              ),
              const SizedBox(height: 14),
              WhiteCard(
                padding: const EdgeInsets.all(14),
                child: Row(children: [
                  Container(width: 36, height: 36, decoration: BoxDecoration(color: const Color(0xFFD7EEDD), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.check, color: AppColors.success)),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Listed', style: AppTheme.dm(size: 14, weight: FontWeight.w700, color: AppColors.navy)),
                    Text('Visible & accepting bookings', style: AppTheme.dm(size: 11, color: AppColors.muted)),
                  ])),
                  Container(width: 42, height: 24, decoration: BoxDecoration(color: AppColors.success, borderRadius: BorderRadius.circular(12)), child: const Align(alignment: Alignment.centerRight, child: Padding(padding: EdgeInsets.all(2), child: CircleAvatar(radius: 10, backgroundColor: Colors.white)))),
                ]),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(gradient: const LinearGradient(colors: [AppColors.gold, Color(0xFFB3923C)]), borderRadius: BorderRadius.circular(14)),
                child: Row(children: [
                  Container(width: 38, height: 38, decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.lock_outline, color: AppColors.gold)),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Protected listing period', style: AppTheme.dm(size: 14, weight: FontWeight.w700, color: AppColors.navy)),
                    Text('New listings stay live for their first month — unlisting unlocks Jul 14. Part of our T&Cs.', style: AppTheme.dm(size: 11, color: const Color(0xFF3A3320), height: 1.4)),
                  ])),
                ]),
              ),
            ],
          ),
        ),
        const Padding(padding: EdgeInsets.all(16), child: WideButton(label: 'Unlisting locked until Jul 14', icon: Icons.lock, color: Color(0xFFE7DFD2), textColor: AppColors.muted, height: 52)),
      ]),
    );
  }
}
