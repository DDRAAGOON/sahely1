import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';
import '../../../data/models.dart';
import '../../../data/sample_data.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/floating_nav.dart';
import '../../../core/widgets/kit.dart';
import '../../../core/widgets/ui.dart';

class OwnerBookingsScreen extends StatefulWidget {
  const OwnerBookingsScreen({super.key});
  @override
  State<OwnerBookingsScreen> createState() => _OwnerBookingsScreenState();
}

class _OwnerBookingsScreenState extends State<OwnerBookingsScreen> {
  int tab = 0;

  void _ownerNav(BuildContext context, int i) {
    final routes = [
      '/owner/home',
      '/owner/wishlist',
      '/owner/bookings',
      '/owner/services',
      '/owner/profile',
    ];

    context.go(routes[i]);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
            const TopBar(title: 'Bookings', subtitle: 'Accepted bookings only'),
            const SizedBox(height: 16),
            SegmentTabs(tabs: const ['Upcoming', 'Active', 'Past'], active: tab, onTap: (i) => setState(() => tab = i)),
            const SizedBox(height: 18),
            if (tab == 0) ...[
              _ownerBookingCard(context, Sample.azure, 'Omar Khalil', '★ 4.9 · ID ✓ · 12 stays', ['Jun 21–25', '4 guests · 2A 2C', 'EGP 18,000'], 'Upcoming', BadgeKind.navy),
              const SizedBox(height: 14),
              _ownerBookingCard(context, Sample.dunes, 'Sara Mansour', '★ 4.6 · ID ✓ · 3 stays', ['Jul 2–6', '2 guests', 'EGP 15,200'], 'Upcoming', BadgeKind.navy, grayscale: true),
            ] else if (tab == 1) ...[
              _ownerBookingCard(context, Sample.lagoon, 'Nour Adel', '★ 5.0 · checked in today', ['Jun 14–18', '4 guests', 'EGP 22,400'], 'Checked in', BadgeKind.green, active: true),
            ] else ...[
              _ownerBookingCard(context, Sample.dunes, 'Hana Tarek', '★ checked out Jun 11', ['Jun 8–11', '2 guests', 'EGP 11,400'], 'Done', BadgeKind.gray, rated: true),
            ],
          ],
        ),
    );
  }

  Widget _ownerBookingCard(BuildContext context, Property property, String guest, String guestMeta, List<String> chips, String badge, BadgeKind kind, {bool active = false, bool rated = false, bool grayscale = false}) {
    String route = '/owner/booking-upcoming';
    if (active) route = '/owner/booking-active';
    if (rated) route = '/owner/booking-past';

    return GestureDetector(
      onTap: () => context.push(route, extra: {'prop': property, 'badge': badge, 'kind': kind}),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [BoxShadow(color: Color(0x1F000000), blurRadius: 10, offset: Offset(0, 4))],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 180,
              child: Stack(fit: StackFit.expand, children: [
                grayscale 
                  ? ColorFiltered(
                      colorFilter: const ColorFilter.matrix(<double>[
                        0.2126, 0.7152, 0.0722, 0, 0,
                        0.2126, 0.7152, 0.0722, 0, 0,
                        0.2126, 0.7152, 0.0722, 0, 0,
                        0,      0,      0,      1, 0,
                      ]),
                      child: SahelyImage(imageUrl: property.image, enableViewer: false, showFade: true, fadeHeight: 60, fadeColor: AppColors.white),
                    )
                  : SahelyImage(imageUrl: property.image, enableViewer: false, showFade: true, fadeHeight: 60, fadeColor: AppColors.white),
                const DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Color(0x66000000)]))),
                Positioned(top: 12, left: 12, child: StatusBadge(badge, kind: kind, dot: kind == BadgeKind.green)),
                Positioned(left: 16, bottom: 32, child: Text(property.name, style: AppTheme.dm(size: 19, weight: FontWeight.w700, color: Colors.white))),
                Positioned(left: 16, bottom: 14, child: Row(children: [
                  const Icon(Icons.location_on_outlined, size: 12, color: Colors.white70),
                  const SizedBox(width: 4),
                  Text('${property.area} · North Coast', style: AppTheme.dm(size: 12, color: Colors.white70)),
                ])),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    const AvatarCircle(size: 40, colors: [Color(0xFFD8B98A), Color(0xFF7D5A2C)]),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(guest, style: AppTheme.dm(size: 15, weight: FontWeight.w700, color: AppColors.navy)),
                      const SizedBox(height: 2),
                      Row(children: [
                        if (!guestMeta.startsWith('★')) ...[
                          const Icon(Icons.star, size: 12, color: AppColors.gold),
                          const SizedBox(width: 4),
                        ],
                        Text(guestMeta, style: AppTheme.dm(size: 12, color: AppColors.muted)),
                      ]),
                    ])),
                  ]),
                  const SizedBox(height: 16),
                  if (active) ...[
                    _kv('Order no.', 'SHLY-7741'),
                    _kv('Dates', chips.first),
                    _kv('Guests', chips[1]),
                    const SizedBox(height: 16),
                    Row(children: [
                      Expanded(child: WideButton(label: 'Key Lock', icon: Icons.lock_outline, color: AppColors.navy, height: 48, radius: 12, onTap: () => context.push('/owner/smart-lock'))),
                      const SizedBox(width: 10),
                      Expanded(child: WideButton(label: 'SOS', icon: Icons.warning_amber_rounded, color: const Color(0xFFB22222), height: 48, radius: 12, onTap: () => context.push('/sos-owner'))),
                    ]),
                    const SizedBox(height: 14),
                    Center(
                      child: GestureDetector(
                        onTap: () => context.push('/owner/booking-detail', extra: {'prop': property, 'badge': badge, 'kind': kind}),
                        child: Text('View booking details →', style: AppTheme.dm(size: 14, weight: FontWeight.w600, color: AppColors.gold)),
                      ),
                    ),
                  ] else ...[
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (var chip in chips)
                          Pill(chip, bg: const Color(0xFFF5F0E8), fg: AppColors.navy, radius: 10),
                      ],
                    ),
                  ],
                  if (rated) ...[
                    const SizedBox(height: 12),
                    const ReviewButton(),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _kv(String k, String v) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(k, style: AppTheme.dm(size: 13, color: AppColors.muted)),
        Text(v, style: AppTheme.dm(size: 13, weight: FontWeight.w700, color: AppColors.navy)),
      ],
    ),
  );
}

// Deleted OwnerBookingDetailScreen class as it's now split into separate files
