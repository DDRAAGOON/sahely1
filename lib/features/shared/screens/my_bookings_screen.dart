import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../data/sample_data.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/floating_nav.dart';
import '../../../core/widgets/kit.dart';
import '../../../core/widgets/ui.dart';

const _azure = 'https://images.unsplash.com/photo-1776762893024-890728937eab?w=800&q=72&auto=format&fit=crop';
const _lagoon = 'https://images.unsplash.com/photo-1707075108813-edefd7b3308d?w=800&q=72&auto=format&fit=crop';
const _dunes = 'https://images.unsplash.com/photo-1776619316276-b1b461af9f15?w=800&q=72&auto=format&fit=crop';

class MyBookingsScreen extends StatefulWidget {
  final bool showNav;
  const MyBookingsScreen({super.key, this.showNav = true});
  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  int tab = 1;

  Widget _miniKv(String k, String v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(k, style: AppTheme.dm(size: 13, color: AppColors.muted)),
            Text(v, style: AppTheme.dm(size: 13, weight: FontWeight.w700, color: AppColors.navy)),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return PhoneScaffold(
      child: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
            children: [
              const SizedBox(height: 10),
              Text('Bookings', style: AppTheme.dm(size: 22, weight: FontWeight.w700, color: AppColors.navy)),
              const SizedBox(height: 14),
              SegmentTabs(tabs: const ['Upcoming', 'Active', 'Past'], active: tab, onTap: (i) => setState(() => tab = i)),
              const SizedBox(height: 16),
              // Active booking card
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [BoxShadow(color: Color(0x1F000000), blurRadius: 12, offset: Offset(0, 4))],
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 160,
                      child: Stack(fit: StackFit.expand, children: [
                        const SahelyImage(
                          imageUrl: _lagoon,
                          enableViewer: false,
                          showFade: true,
                          fadeHeight: 60,
                          fadeColor: AppColors.white,
                        ),
                        const DecoratedBox(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [Colors.transparent, Color(0x66000000)]))),
                        const Positioned(
                            top: 12, left: 12, child: StatusBadge('Active · Checked in', kind: BadgeKind.green, dot: true)),
                        Positioned(
                            left: 16,
                            bottom: 34,
                            child: Text('Lagoon Retreat',
                                style: AppTheme.dm(size: 20, weight: FontWeight.w700, color: AppColors.white))),
                        Positioned(
                            left: 16,
                            bottom: 14,
                            child: Row(children: [
                              const Icon(Icons.location_on_outlined, size: 12, color: Colors.white70),
                              const SizedBox(width: 4),
                              Text('Marassi · North Coast', style: AppTheme.dm(size: 12, color: Colors.white70)),
                            ])),
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _miniKv('Order no.', 'SHLY-7741'),
                          _miniKv('Dates', 'Jun 14 – 18 · 4 nights'),
                          _miniKv('Guests', '2 adults, 1 child'),
                          const SizedBox(height: 16),
                          Row(children: [
                            Expanded(
                                child: WideButton(
                                    label: 'Digital Lock',
                                    icon: Icons.lock_outline,
                                    color: AppColors.navy,
                                    height: 48,
                                    radius: 12,
                                    onTap: () => context.push('/smart-lock'))),
                            const SizedBox(width: 10),
                            Expanded(
                                child: WideButton(
                                    label: 'SOS',
                                    icon: Icons.warning_amber_rounded,
                                    color: const Color(0xFFB22222),
                                    height: 48,
                                    radius: 12,
                                    onTap: () => context.push('/sos'))),
                          ]),
                          const SizedBox(height: 14),
                          Center(
                            child: GestureDetector(
                              onTap: () => context.push('/booked-property', extra: Sample.lagoon),
                              behavior: HitTestBehavior.opaque,
                              child: Text('View booking details →',
                                  style: AppTheme.dm(size: 14, weight: FontWeight.w600, color: AppColors.gold)),
                            ),
                          ),
                          const SizedBox(height: 14),
                          ReviewButton(onTap: () => context.push('/write-review', extra: Sample.lagoon)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _SmallBookingRow(
                  image: _azure,
                  name: 'Azure Beach Villa',
                  badge: 'Upcoming',
                  kind: BadgeKind.navy,
                  area: 'Hacienda Bay · North Coast',
                  dates: 'Jun 21 – 25 · 2 guests',
                  order: 'SHLY-8842',
                  onTap: () => context.push('/booking-upcoming', extra: Sample.azure)),
              const SizedBox(height: 16),
              const SectionLabel('PAST STAYS'),
              const SizedBox(height: 12),
              _SmallBookingRow(
                  image: _dunes,
                  name: 'Golden Dunes',
                  badge: 'Past',
                  kind: BadgeKind.gray,
                  area: 'Marassi · North Coast',
                  dates: 'May 18 – 22 · 2 guests',
                  order: 'SHLY-7120',
                  review: true,
                  onTap: () => context.push('/booking-past', extra: Sample.dunes)),
            ],
          ),
          if (widget.showNav) const FloatingNav(active: 2),
        ],
      ),
    );
  }
}

class _SmallBookingRow extends StatelessWidget {
  const _SmallBookingRow(
      {required this.image,
      required this.name,
      required this.badge,
      required this.kind,
      required this.area,
      required this.dates,
      required this.order,
      this.review = false,
      this.onTap});
  final String image, name, badge, area, dates, order;
  final BadgeKind kind;
  final bool review;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(color: Color(0x1F000000), blurRadius: 10, offset: Offset(0, 4))],
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SahelyImage(imageUrl: image, width: 84, height: 84, enableViewer: false)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Flexible(child: Text(name, style: AppTheme.dm(size: 15, weight: FontWeight.w700, color: AppColors.navy))),
                        StatusBadge(badge, kind: kind),
                      ]),
                      const SizedBox(height: 4),
                      Row(children: [
                        const Icon(Icons.location_on_outlined, size: 11, color: Color(0xFF5B5B5B)),
                        const SizedBox(width: 3),
                        Text(area, style: AppTheme.dm(size: 12, color: const Color(0xFF5B5B5B))),
                      ]),
                      const SizedBox(height: 4),
                      Text(dates, style: AppTheme.dm(size: 12, color: AppColors.navy, weight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      Text('Order no. $order', style: AppTheme.dm(size: 12, color: const Color(0xFF5B5B5B))),
                    ],
                  ),
                ),
              ],
            ),
            if (review) ...[
              const SizedBox(height: 10),
              const ReviewButton(),
            ],
          ],
        ),
      ),
    );
  }
}
