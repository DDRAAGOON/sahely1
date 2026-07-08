import 'package:flutter/material.dart';
import '../../../data/models.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import 'package:sahely/features/shared/widgets/common.dart';
import 'package:sahely/features/shared/widgets/cream_background.dart';
import 'package:sahely/features/shared/widgets/kit.dart';
import 'package:sahely/features/shared/widgets/ui.dart';

const _azure = 'https://images.unsplash.com/photo-1776762893024-890728937eab?w=800&q=72&auto=format&fit=crop';
const _lagoon = 'https://images.unsplash.com/photo-1707075108813-edefd7b3308d?w=800&q=72&auto=format&fit=crop';
const _dunes = 'https://images.unsplash.com/photo-1776619316276-b1b461af9f15?w=800&q=72&auto=format&fit=crop';

class UpcomingBookingDetailScreen extends StatelessWidget {
  const UpcomingBookingDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final property = ModalRoute.of(context)?.settings.arguments as Property?;
    final img = property?.image ?? _azure;
    final name = property?.name ?? 'Azure Beach Villa';

    return PhoneScaffold(
      child: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: EdgeInsets.zero,
              children: [
                // 1. Hero Image with Title & Location inside
                SizedBox(
                  height: 280,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      SahelyImage(imageUrl: img, enableViewer: true, fadeHeight: 120),
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
                              Text(property != null ? '${property.area} · North Coast' : 'Hacienda Bay · North Coast', 
                                   style: AppTheme.dm(size: 13, color: Colors.white70)),
                            ]),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 2. Gallery Row
                      SizedBox(
                        height: 80,
                        child: Row(
                          children: [
                            _galleryThumb(_azure),
                            const SizedBox(width: 10),
                            _galleryThumb(_lagoon),
                            const SizedBox(width: 10),
                            _galleryThumb(_dunes, overlay: '+12'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),

                      // 3. About this place
                      Text('About this place', style: AppTheme.dm(size: 20, weight: FontWeight.w700, color: AppColors.navy)),
                      const SizedBox(height: 14),
                      Text(
                        'Beachfront villa with a private pool, panoramic sea views and direct beach access. Sleeps 6 across 4 bedrooms over 2 floors.',
                        style: AppTheme.dm(size: 15, color: AppColors.ink, height: 1.55),
                      ),
                      const SizedBox(height: 20),
                      Wrap(spacing: 8, runSpacing: 10, children: [
                        _featurePill('Villa'),
                        _featurePill('320 m²'),
                        _featurePill('4 Beds'),
                        _featurePill('3 Baths'),
                        _featurePill('6 Guests'),
                        _featurePill('2 Floors'),
                        _featurePill('Sea view'),
                      ]),
                      const SizedBox(height: 32),

                      // 4. Location
                      Text('Location', style: AppTheme.dm(size: 19, weight: FontWeight.w700, color: AppColors.navy)),
                      const SizedBox(height: 14),
                      Container(
                        height: 160,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFC5D5E2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const Icon(Icons.location_on, color: Color(0xFFB22222), size: 40),
                            Positioned(
                              bottom: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                                decoration: BoxDecoration(color: AppColors.navy.withOpacity(0.8), borderRadius: BorderRadius.circular(8)),
                                child: Text('Hacienda Bay, Marassi · North Coast', style: AppTheme.dm(size: 12, weight: FontWeight.w600, color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: const Color(0xFFFDF9F4), border: Border.all(color: const Color(0xFFEAD9A8)), borderRadius: BorderRadius.circular(14)),
                        child: Row(children: [
                          const Icon(Icons.schedule, size: 20, color: Color(0xFF8A6A1E)),
                          const SizedBox(width: 12),
                          Expanded(child: Text('Check-in in 4 days · passcode unlocks within 2 km', style: AppTheme.dm(size: 13, weight: FontWeight.w600, color: const Color(0xFF8A6A1E)))),
                        ]),
                      ),
                      const SizedBox(height: 32),

                      // 5. Reservation
                      Text('Reservation', style: AppTheme.dm(size: 19, weight: FontWeight.w700, color: AppColors.navy)),
                      const SizedBox(height: 14),
                      const WhiteCard(
                        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                        child: Column(children: [
                          KeyValueRow('Order no.', 'SHLY-8842'),
                          Divider(height: 1, color: AppColors.border),
                          KeyValueRow('Check-in', 'Jun 21 · 3:00 PM'),
                          Divider(height: 1, color: AppColors.border),
                          KeyValueRow('Check-out', 'Jun 25 · 11:00 AM'),
                          Divider(height: 1, color: AppColors.border),
                          KeyValueRow('Guests', '2 adults'),
                          Divider(height: 1, color: AppColors.border),
                          KeyValueRow('Nights', '4'),
                        ]),
                      ),
                      const SizedBox(height: 32),

                      // 6. What's included
                      Text("What's included", style: AppTheme.dm(size: 19, weight: FontWeight.w700, color: AppColors.navy)),
                      const SizedBox(height: 14),
                      Wrap(spacing: 8, runSpacing: 8, children: [
                        _includedPill('Pool'),
                        _includedPill('WiFi'),
                        _includedPill('Beach'),
                        _includedPill('Smart Lock'),
                        const Pill('🐾 Pets OK', bg: Color(0xFFD7EEDD), fg: AppColors.success, radius: 10),
                      ]),
                      const SizedBox(height: 32),

                      // 7. Price
                      Text('Price', style: AppTheme.dm(size: 19, weight: FontWeight.w700, color: AppColors.navy)),
                      const SizedBox(height: 14),
                      const WhiteCard(
                        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                        child: Column(children: [
                          KeyValueRow('EGP 4,500 × 4', '18,000'),
                          Divider(height: 1, color: AppColors.border),
                          KeyValueRow('Cleaning + VAT', '3,090'),
                          Divider(height: 1, color: AppColors.border),
                          KeyValueRow('Total paid', 'EGP 21,090', bold: true),
                        ]),
                      ),
                      const SizedBox(height: 32),

                      // 8. AI Banner
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/ai-chat'),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(color: const Color(0xFF1B2744), borderRadius: BorderRadius.circular(16)),
                          child: Row(children: [
                            Container(width: 46, height: 46, alignment: Alignment.center, decoration: BoxDecoration(color: const Color(0xFFD8B96A), borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.auto_awesome, size: 24, color: Color(0xFF1B2744))),
                            const SizedBox(width: 14),
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text('Ask Sahely AI', style: AppTheme.dm(size: 15, weight: FontWeight.w700, color: Colors.white)),
                              const SizedBox(height: 2),
                              Text('Questions about this stay — directions, parking, check-in', style: AppTheme.dm(size: 11, color: const Color(0xFFD8B96A))),
                            ])),
                            const Icon(Icons.chat_bubble_outline, color: Color(0xFFD8B96A), size: 22),
                          ]),
                        ),
                      ),
                      const SizedBox(height: 16),
                      WideButton(
                        label: 'Cancel booking', 
                        color: const Color(0xFFB22222), 
                        textColor: const Color(0xFFB22222),
                        outline: true, 
                        height: 56, 
                        radius: 16,
                        onTap: () => _showCancelDialog(context),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
            
            // Floating Top Bar (Back & Status)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.maybePop(context),
                        child: Container(
                          width: 42, 
                          height: 42, 
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)]), 
                          child: const Icon(Icons.chevron_left, color: AppColors.navy, size: 28),
                        ),
                      ),
                      const StatusBadge('Upcoming', kind: BadgeKind.navy),
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

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Cancel Booking', style: AppTheme.dm(size: 18, weight: FontWeight.w700, color: AppColors.navy)),
        content: Text('Are you sure you want to cancel this booking? This action cannot be undone.', style: AppTheme.dm(size: 14, color: AppColors.muted)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('No, keep it', style: AppTheme.dm(size: 14, weight: FontWeight.w600, color: AppColors.muted)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Booking cancellation request sent'), backgroundColor: Color(0xFFB22222)),
              );
            },
            child: Text('Yes, cancel', style: AppTheme.dm(size: 14, weight: FontWeight.w700, color: const Color(0xFFB22222))),
          ),
        ],
      ),
    );
  }

  Widget _featurePill(String label) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
    decoration: BoxDecoration(
      color: const Color(0xFFF9F9F9), 
      border: Border.all(color: const Color(0xFF22335A).withOpacity(0.8), width: 1.1), 
      borderRadius: BorderRadius.circular(12)
    ),
    child: Text(label, style: AppTheme.dm(size: 13, weight: FontWeight.w600, color: const Color(0xFF22335A))),
  );

  Widget _includedPill(String label) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    decoration: BoxDecoration(color: AppColors.white, border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(10)),
    child: Text(label, style: AppTheme.dm(size: 13, weight: FontWeight.w600, color: AppColors.navy)),
  );

  Widget _galleryThumb(String url, {String? overlay}) => Expanded(
    child: ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(url, fit: BoxFit.cover),
          if (overlay != null)
            Container(
              color: Colors.black.withOpacity(0.45),
              alignment: Alignment.center,
              child: Text(overlay, style: AppTheme.dm(size: 16, weight: FontWeight.w700, color: Colors.white)),
            ),
        ],
      ),
    ),
  );
}
