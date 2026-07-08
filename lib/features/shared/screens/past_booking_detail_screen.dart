import 'package:flutter/material.dart';
import '../../../data/models.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../widgets/badges.dart';
import '../widgets/cards.dart';
import '../widgets/cream_background.dart';
import '../widgets/image.dart';
import '../widgets/rows.dart';
import '../widgets/tags.dart';
import '../widgets/wide_button.dart';


const _dunes = 'https://images.unsplash.com/photo-1776619316276-b1b461af9f15?w=800&q=72&auto=format&fit=crop';

class PastBookingDetailScreen extends StatelessWidget {
  const PastBookingDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final property = ModalRoute.of(context)?.settings.arguments as Property?;
    final img = property?.image ?? _dunes;
    final name = property?.name ?? 'Golden Dunes';

    return PhoneScaffold(
      child: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: EdgeInsets.zero,
              children: [
                // 1. Hero Image (Grayscale)
                SizedBox(
                  height: 280,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ColorFiltered(
                        colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.saturation),
                        child: SahelyImage(imageUrl: img, enableViewer: true, fadeHeight: 120),
                      ),
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Color(0x991B2744)],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 18,
                        bottom: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(name, style: AppTheme.dm(size: 26, weight: FontWeight.w700, color: Colors.white)),
                            const SizedBox(height: 4),
                            Row(children: [
                              const Icon(Icons.location_on_outlined, size: 14, color: Colors.white70),
                              const SizedBox(width: 4),
                              Text('Marassi · North Coast', style: AppTheme.dm(size: 13, color: Colors.white70)),
                            ]),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 2. Reservation
                      Text('Reservation', style: AppTheme.dm(size: 19, weight: FontWeight.w700, color: AppColors.navy)),
                      const SizedBox(height: 14),
                      const WhiteCard(
                        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                        child: Column(children: [
                          KeyValueRow('Order no.', 'SHLY-7120'),
                          Divider(height: 1, color: AppColors.border),
                          KeyValueRow('Check-in', 'May 18 · 3:00 PM'),
                          Divider(height: 1, color: AppColors.border),
                          KeyValueRow('Check-out', 'May 22 · 11:00 AM'),
                          Divider(height: 1, color: AppColors.border),
                          KeyValueRow('Guests', '2 adults'),
                          Divider(height: 1, color: AppColors.border),
                          KeyValueRow('Nights', '4'),
                        ]),
                      ),
                      const SizedBox(height: 32),

                      // 3. What was included
                      Text('What was included', style: AppTheme.dm(size: 19, weight: FontWeight.w700, color: AppColors.navy)),
                      const SizedBox(height: 14),
                      Wrap(spacing: 8, runSpacing: 8, children: [
                        _includedPill('Pool'),
                        _includedPill('WiFi'),
                        _includedPill('Beach'),
                        _includedPill('Smart Lock'),
                        const Pill('🐾 Pets OK', bg: Color(0xFFD7EEDD), fg: AppColors.success, radius: 10),
                      ]),
                      const SizedBox(height: 32),

                      // 4. Price
                      Text('Price', style: AppTheme.dm(size: 19, weight: FontWeight.w700, color: AppColors.navy)),
                      const SizedBox(height: 14),
                      const WhiteCard(
                        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                        child: Column(children: [
                          KeyValueRow('EGP 3,800 × 4', '15,200'),
                          Divider(height: 1, color: AppColors.border),
                          KeyValueRow('Cleaning + VAT', '2,500'),
                          Divider(height: 1, color: AppColors.border),
                          KeyValueRow('Total paid', 'EGP 17,700', bold: true),
                        ]),
                      ),
                      const SizedBox(height: 32),

                      // 5. Rate Stay Card
                      WhiteCard(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text('How was your stay?', style: AppTheme.dm(size: 15, weight: FontWeight.w700, color: AppColors.navy)),
                            const SizedBox(height: 14),
                            Row(mainAxisAlignment: MainAxisAlignment.center, children: [for (var i = 0; i < 5; i++) const Icon(Icons.star, size: 36, color: Color(0xFFE0E0E0))]),
                            const SizedBox(height: 18),
                            WideButton(
                              label: 'Write a review · earn +5 ★', 
                              icon: Icons.star, 
                              color: AppColors.navy, 
                              height: 52, 
                              radius: 14,
                              onTap: () => Navigator.pushNamed(context, '/write-review', arguments: property),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      WideButton(
                        label: 'Book again', 
                        color: AppColors.navy, 
                        textColor: AppColors.navy,
                        outline: true, 
                        height: 52, 
                        radius: 14,
                        onTap: () => Navigator.pop(context),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),

            // Top Bar
            Positioned(
              top: 0, left: 0, right: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.maybePop(context),
                        child: Container(
                          width: 42, height: 42,
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)]),
                          child: const Icon(Icons.chevron_left, color: AppColors.navy, size: 28),
                        ),
                      ),
                      const StatusBadge('Past', kind: BadgeKind.gray),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _includedPill(String label) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.transparent,
      border: Border.all(color: AppColors.border), 
      borderRadius: BorderRadius.circular(10)
    ),
    child: Text(label, style: AppTheme.dm(size: 13, weight: FontWeight.w600, color: AppColors.navy)),
  );
}
