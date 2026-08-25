import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sahely/core/navigation/app_navigation.dart';
import 'package:sahely/core/providers/bookings_provider.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/l10n/app_localizations.dart';
import 'package:sahely/core/widgets/kit.dart';
import 'package:sahely/core/widgets/ui.dart';
import 'package:sahely/data/sample_data.dart';

import '../../../core/utils/currency_formatter.dart';

class OwnerBookingsScreen extends StatefulWidget {
  final int initialMainTab;

  const OwnerBookingsScreen({super.key, this.initialMainTab = 0});

  @override
  State<OwnerBookingsScreen> createState() => _OwnerBookingsScreenState();
}

class _OwnerBookingsScreenState extends State<OwnerBookingsScreen> {
  late int _mainTab;
  int _subTab = 1; // 0: Upcoming, 1: Active, 2: Past

  @override
  void initState() {
    super.initState();
    _mainTab = widget.initialMainTab;
  }

  @override
  Widget build(BuildContext context) {
    final bookingsProvider = context.watch<BookingsProvider>();

    return PhoneScaffold(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          TopBar(
              title: AppLocalizations.of(context).bookings,
              subtitle: AppLocalizations.of(context).manageGuests,
              showBack: false),
          const SizedBox(height: 16),
          // Main Role Toggle
          SegmentTabs(
            tabs: const ['My Guests', 'My Stays'],
            active: _mainTab,
            onTap: (i) => setState(() {
              _mainTab = i;
              // Sync subtab with main tab defaults if needed
              if (_mainTab == 1) _subTab = 1; // Default to Active for stays
            }),
          ),
          const SizedBox(height: 14),
          // Status Tabs
          SegmentTabs(
            tabs: const ['Upcoming', 'Active', 'Past'],
            active: _subTab,
            onTap: (i) => setState(() => _subTab = i),
          ),
          const SizedBox(height: 18),
          if (_mainTab == 0)
            _buildMyGuests()
          else
            _buildMyStays(bookingsProvider),
        ],
      ),
    );
  }

  Widget _buildMyGuests() {
    if (_subTab == 0) {
      return Column(children: [
        _ownerBookingCard(
            context,
            Sample.azure,
            'Omar Khalil',
            '★ 4.9 · ID ✓ · 12 stays',
            ['Jun 21–25', '4 guests · 2A 2C', CurrencyFormatter.format(18000)],
            'Upcoming',
            BadgeKind.navy),
        const SizedBox(height: 14),
        _ownerBookingCard(
            context,
            Sample.dunes,
            'Sara Mansour',
            '★ 4.6 · ID ✓ · 3 stays',
            ['Jul 2–6', '2 guests', CurrencyFormatter.format(15200)],
            'Upcoming',
            BadgeKind.navy,
            grayscale: true),
      ]);
    } else if (_subTab == 1) {
      return _ownerBookingCard(
          context,
          Sample.lagoon,
          'Nour Adel',
          '★ 5.0 · checked in today',
          ['Jun 14–18', '4 guests', CurrencyFormatter.format(22400)],
          'Checked in',
          BadgeKind.green,
          active: true);
    } else {
      return _ownerBookingCard(
          context,
          Sample.dunes,
          'Hana Tarek',
          '★ checked out Jun 11',
          ['Jun 8–11', '2 guests', CurrencyFormatter.format(11400)],
          'Done',
          BadgeKind.gray,
          rated: true);
    }
  }

  Widget _buildMyStays(BookingsProvider provider) {
    final List<Booking> list = switch (_subTab) {
      0 => provider.upcomingBookings,
      1 => provider.activeBookings,
      _ => provider.pastBookings,
    };

    if (list.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Text('No bookings found in this category',
              style: AppTheme.dm(size: 14, color: AppColors.muted)),
        ),
      );
    }

    return Column(
      children: [
        for (final b in list) ...[
          _stayCard(b),
          const SizedBox(height: 14),
        ],
      ],
    );
  }

  Widget _stayCard(Booking booking) {
    final bool isActive = booking.status == BookingStatus.active;
    final bool isPast = booking.status == BookingStatus.past;

    return GestureDetector(
      onTap: () {
        final route = switch (booking.status) {
          BookingStatus.upcoming => '/owner/booking-upcoming',
          BookingStatus.active => '/booked-property',
          _ => '/owner/booking-past',
        };
        AppNavigation.safePush(context, route, extra: booking);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
                color: Color(0x1F000000), blurRadius: 10, offset: Offset(0, 4))
          ],
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SahelyImage(
                      imageUrl: booking.imageUrl,
                      width: 84,
                      height: 84,
                      enableViewer: false),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(booking.propertyName,
                                style: AppTheme.dm(
                                    size: 15,
                                    weight: FontWeight.w700,
                                    color: AppColors.navy)),
                          ),
                          StatusBadge(booking.statusText,
                              kind: isActive
                                  ? BadgeKind.green
                                  : (isPast ? BadgeKind.gray : BadgeKind.navy)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(children: [
                        const Icon(Icons.location_on_outlined,
                            size: 11, color: Color(0xFF5B5B5B)),
                        const SizedBox(width: 3),
                        Text(booking.location,
                            style: AppTheme.dm(
                                size: 12, color: const Color(0xFF5B5B5B))),
                      ]),
                      const SizedBox(height: 4),
                      Text(booking.dates,
                          style: AppTheme.dm(
                              size: 12,
                              color: AppColors.navy,
                              weight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      Text('${AppLocalizations.of(context).orderNo} ${booking.orderNumber}',
                          style: AppTheme.dm(
                              size: 12, color: const Color(0xFF5B5B5B))),
                    ],
                  ),
                ),
              ],
            ),
            if (isPast) ...[
              const SizedBox(height: 10),
              ReviewButton(
                onTap: () => AppNavigation.goToOwnerRateGuest(
                  context,
                  extra: Sample.allTrending.firstWhere(
                    (p) => p.name == booking.propertyName,
                    orElse: () => Sample.azure,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _ownerBookingCard(
      BuildContext context,
      Property property,
      String guest,
      String guestMeta,
      List<String> chips,
      String badge,
      BadgeKind kind,
      {bool active = false,
      bool rated = false,
      bool grayscale = false}) {
    String route = '/owner/booking-upcoming';
    if (active) route = '/owner/booking-active';
    if (rated) route = '/owner/booking-past';

    return GestureDetector(
      onTap: () => AppNavigation.safePush(context, route,
          extra: {'prop': property, 'badge': badge, 'kind': kind}),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
                color: Color(0x1F000000), blurRadius: 10, offset: Offset(0, 4))
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 180,
              child: Stack(fit: StackFit.expand, children: [
                SahelyImage(
                    imageUrl: property.image,
                    enableViewer: false,
                    showFade: true,
                    fadeHeight: 60,
                    fadeColor: AppColors.white),
                const DecoratedBox(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Color(0x66000000)]))),
                Positioned(
                    top: 12,
                    left: 12,
                    child: StatusBadge(badge,
                        kind: kind, dot: kind == BadgeKind.green)),
                Positioned(
                    left: 16,
                    bottom: 32,
                    child: Text(property.name,
                        style: AppTheme.dm(
                            size: 19,
                            weight: FontWeight.w700,
                            color: Colors.white))),
                Positioned(
                    left: 16,
                    bottom: 14,
                    child: Row(children: [
                      const Icon(Icons.location_on_outlined,
                          size: 12, color: Colors.white70),
                      const SizedBox(width: 4),
                      Text('${property.area} · North Coast',
                          style: AppTheme.dm(size: 12, color: Colors.white70)),
                    ])),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    const AvatarCircle(
                        size: 40,
                        colors: [Color(0xFFD8B98A), Color(0xFF7D5A2C)]),
                    const SizedBox(width: 12),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Text(guest,
                              style: AppTheme.dm(
                                  size: 15,
                                  weight: FontWeight.w700,
                                  color: AppColors.navy)),
                          const SizedBox(height: 2),
                          Row(children: [
                            if (!guestMeta.startsWith('★')) ...[
                              const Icon(Icons.star,
                                  size: 12, color: AppColors.gold),
                              const SizedBox(width: 4),
                            ],
                            Text(guestMeta,
                                style: AppTheme.dm(
                                    size: 12, color: AppColors.muted)),
                          ]),
                        ])),
                  ]),
                  const SizedBox(height: 16),
                  if (active) ...[
                    _kv(AppLocalizations.of(context).orderNo, 'SHLY-7741'),
                    _kv('Dates', chips.first),
                    _kv('Guests', chips[1]),
                    const SizedBox(height: 16),
                    Row(children: [
                      Expanded(
                          child: WideButton(
                              label: 'Key Lock',
                              icon: Icons.lock_outline,
                              color: AppColors.navy,
                              height: 48,
                              radius: 12,
                              onTap: () =>
                                  AppNavigation.goToOwnerSmartLock(context))),
                      const SizedBox(width: 10),
                      Expanded(
                          child: WideButton(
                              label: 'SOS',
                              icon: Icons.warning_amber_rounded,
                              color: const Color(0xFFB22222),
                              height: 48,
                              radius: 12,
                              onTap: () =>
                                  AppNavigation.goToSosOwner(context))),
                    ]),
                    const SizedBox(height: 14),
                    Center(
                      child: GestureDetector(
                        onTap: () => AppNavigation.safePush(context, route,
                            extra: {
                              'prop': property,
                              'badge': badge,
                              'kind': kind
                            }),
                        child: Text('View booking details →',
                            style: AppTheme.dm(
                                size: 14,
                                weight: FontWeight.w600,
                                color: AppColors.gold)),
                      ),
                    ),
                  ] else ...[
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (var chip in chips)
                          Pill(chip,
                              bg: const Color(0xFFF5F0E8),
                              fg: AppColors.navy,
                              radius: 10),
                      ],
                    ),
                  ],
                  if (rated) ...[
                    const SizedBox(height: 12),
                    ReviewButton(
                      onTap: () => AppNavigation.goToOwnerRateGuest(
                        context,
                        extra: property,
                      ),
                    ),
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
            Text(v,
                style: AppTheme.dm(
                    size: 13, weight: FontWeight.w700, color: AppColors.navy)),
          ],
        ),
      );
}

// Deleted OwnerBookingDetailScreen class as it's now split into separate files
