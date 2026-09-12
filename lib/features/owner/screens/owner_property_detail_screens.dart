import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sahely/core/navigation/app_navigation.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/common.dart';
import 'package:sahely/core/widgets/kit.dart';
import 'package:sahely/core/widgets/ui.dart';

import '../../../core/utils/currency_formatter.dart';
import 'package:sahely/core/di/service_locator.dart' show sl;
import 'package:sahely/core/network/api_client.dart';
import 'package:sahely/core/network/api_endpoints.dart';
import 'package:sahely/core/network/api_envelope.dart';
import 'package:sahely/core/network/upload/file_upload_api.dart';
import 'package:sahely/features/owner/domain/entities/owner_booking_request.dart';
import 'package:sahely/features/owner/domain/entities/owner_guest_booking.dart';
import 'package:sahely/features/owner/domain/repositories/owner_repository.dart';
import 'package:sahely/features/properties/data/datasources/property_remote_data_source.dart';
import 'package:sahely/features/shared/reviews/domain/models/review.dart';
import 'package:sahely/features/shared/reviews/domain/repositories/review_repository.dart';
import 'package:sahely/features/smart_lock/data/smart_lock_api_data_source.dart';

class OwnerPropertyInsightsScreen extends StatefulWidget {
  final Property? property;

  const OwnerPropertyInsightsScreen({super.key, this.property});

  @override
  State<OwnerPropertyInsightsScreen> createState() =>
      _OwnerPropertyInsightsScreenState();
}

/// One listing's dashboard. Everything comes from the API: the listing, the
/// owner's bookings and requests for it, its reviews, the smart lock and the
/// blocked days. Views, saves and occupancy are not in the mobile API and
/// show "—".
class _OwnerPropertyInsightsScreenState
    extends State<OwnerPropertyInsightsScreen> {
  List<OwnerGuestBooking> _bookings = const [];
  int _pendingRequests = 0;
  List<Review> _reviews = const [];
  Map<String, dynamic>? _lock;
  List<Map<String, dynamic>> _accessLog = const [];
  List<int> _blockedDays = const [];

  @override
  void initState() {
    super.initState();
    final id = widget.property?.id ?? '';
    if (id.isNotEmpty) _load(id);
  }

  Future<void> _load(String id) async {
    final owner = sl<OwnerRepository>();
    await Future.wait([
      _quietly(() async {
        final all = await owner.getGuestBookings();
        _bookings = all.where((b) => b.property?.id == id).toList();
      }),
      _quietly(() async {
        final requests = await owner.getBookingRequests();
        _pendingRequests = requests
            .where(
                (r) => r.property?.id == id && r.state == RequestState.pending)
            .length;
      }),
      _quietly(() async {
        _reviews = await sl<ReviewRepository>().getPropertyReviews(id);
      }),
      _quietly(() async {
        final lock = sl<SmartLockApiDataSource>();
        _lock = await lock.onlineStatus(id);
        _accessLog = await lock.accessLog(id);
      }),
      _quietly(() async {
        _blockedDays = await _blockedDaysThisMonth(id);
      }),
    ]);
    if (mounted) setState(() {});
  }

  /// Each section loads on its own; one failing leaves the others intact.
  static Future<void> _quietly(Future<void> Function() load) async {
    try {
      await load();
    } catch (_) {}
  }

  bool get _lockOnline {
    final lock = _lock;
    if (lock == null) return false;
    final flag = lock['online'] ?? lock['is_online'] ?? lock['isOnline'];
    if (flag is bool) return flag;
    return '${lock['status'] ?? ''}'.toLowerCase() == 'online';
  }

  static String _statusLabel(PropertyStatus status) => switch (status) {
        PropertyStatus.active => 'Active',
        PropertyStatus.underReview => 'In review',
        PropertyStatus.draft => 'Draft',
        _ => 'Not listed',
      };

  @override
  Widget build(BuildContext context) {
    final prop = widget.property;
    if (prop == null) {
      return Scaffold(
        backgroundColor: AppColors.cream,
        body: Center(
          child: Text('Open a listing from My Properties.',
              style: AppTheme.dm(color: AppColors.muted)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // 1. Hero Header
          Stack(
            children: [
              SizedBox(
                height: 220,
                width: double.infinity,
                child: SahelyImage(
                  imageUrl: prop.image,
                  enableViewer: true,
                  fadeColor: AppColors.navy.withValues(alpha: 0.6),
                  fadeHeight: 80,
                ),
              ),
              // Back Button
              Positioned(
                top: 44,
                left: 16,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child:
                        const Icon(Icons.chevron_left, color: AppColors.navy),
                  ),
                ),
              ),
              // SOS Button
              Positioned(
                top: 44,
                right: 16,
                child: GestureDetector(
                  onTap: () => AppNavigation.goToSosOwner(context),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFB22222),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.warning_amber_rounded,
                            color: Colors.white, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          'SOS',
                          style: AppTheme.dm(
                            size: 13,
                            weight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Name & Status overlay
              Positioned(
                left: 18,
                bottom: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      prop.name,
                      style: AppTheme.dm(
                        size: 24,
                        weight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${prop.area} · ${_statusLabel(prop.status)}',
                      style: AppTheme.dm(
                        size: 13,
                        weight: FontWeight.w500,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 2. Top Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: WideButton(
                        label: 'Edit property',
                        icon: Icons.edit_outlined,
                        color: AppColors.navy,
                        height: 48,
                        radius: 12,
                        onTap: () =>
                            AppNavigation.goToOwnerEdit(context, extra: prop),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: WideButton(
                        label: 'Preview listing',
                        color: AppColors.navy,
                        outline: true,
                        height: 48,
                        radius: 12,
                        onTap: () => AppNavigation.goToOwnerPreview(context,
                            extra: prop),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 3. Requests Card
                GestureDetector(
                  onTap: () => AppNavigation.goToOwnerRequests(context),
                  child: WhiteCard(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFDF5E8),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child:
                              const Icon(Icons.notes, color: Color(0xFFD2760A)),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Requests for this property',
                                style: AppTheme.dm(
                                  size: 15,
                                  weight: FontWeight.w700,
                                  color: AppColors.navy,
                                ),
                              ),
                              Text(
                                '$_pendingRequests pending · tap to review',
                                style: AppTheme.dm(
                                  size: 12,
                                  color: AppColors.muted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right,
                            color: AppColors.border, size: 20),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // 4. Stats Grid (3x2)
                _buildStatsGrid(prop),
                const SizedBox(height: 24),

                // 5. Views Chart
                Text(
                  'Views · last 7 days',
                  style: AppTheme.dm(
                    size: 16,
                    weight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 12),
                WhiteCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('—',
                                  style: AppTheme.dm(
                                      size: 20, weight: FontWeight.w800)),
                              Text('Views are not tracked yet',
                                  style: AppTheme.dm(
                                      size: 12,
                                      weight: FontWeight.w600,
                                      color: AppColors.muted)),
                            ],
                          ),
                          Text('',
                              style: AppTheme.dm(
                                  size: 12, color: AppColors.muted)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const SizedBox(
                        height: 100,
                        child: CustomPaint(
                          size: Size(double.infinity, 100),
                          painter: _SparklinePainter(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          for (final d in ['M', 'T', 'W', 'T', 'F', 'S', 'S'])
                            Text(d,
                                style: AppTheme.dm(
                                    size: 10, color: AppColors.border)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // 6. Smart Lock
                Text(
                  'Smart Lock',
                  style: AppTheme.dm(
                    size: 16,
                    weight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.navy,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: AppColors.gold.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.lock_outline,
                            color: AppColors.gold, size: 22),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _lock == null
                                  ? 'Smart lock not connected'
                                  : 'Smart lock · ${_lockOnline ? 'Online' : 'Offline'}',
                              style: AppTheme.dm(
                                size: 14,
                                weight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              _bookings.any(
                                      (b) => b.phase == GuestStayPhase.active)
                                  ? 'Passcode active for current guest'
                                  : 'No guest staying right now',
                              style: AppTheme.dm(
                                size: 11,
                                color: Colors.white.withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: (_lockOnline
                                  ? const Color(0xFF2E7D32)
                                  : AppColors.muted)
                              .withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                              color: _lockOnline
                                  ? const Color(0xFF4CAF50)
                                  : AppColors.muted,
                              width: 0.5),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                                radius: 3,
                                backgroundColor: _lockOnline
                                    ? const Color(0xFF4CAF50)
                                    : AppColors.muted),
                            const SizedBox(width: 6),
                            Text(_lockOnline ? 'Online' : 'Offline',
                                style: AppTheme.dm(
                                    size: 10,
                                    weight: FontWeight.w700,
                                    color: _lockOnline
                                        ? const Color(0xFF4CAF50)
                                        : AppColors.muted)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Recent Access Log
                Text(
                  'RECENT ACCESS',
                  style: AppTheme.dm(
                    size: 11,
                    weight: FontWeight.w800,
                    color: AppColors.muted,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 10),
                WhiteCard(
                  child: Column(children: _accessRows()),
                ),
                const SizedBox(height: 12),
                WideButton(
                  label: 'Manage smart lock',
                  color: AppColors.navy,
                  outline: true,
                  height: 48,
                  radius: 12,
                  onTap: () => AppNavigation.goToOwnerSmartLock(context),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'Passcode locked during an active stay · change after checkout',
                    style: AppTheme.dm(size: 10, color: AppColors.muted),
                  ),
                ),
                const SizedBox(height: 28),

                // 7. Recent Reviews
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Reviews',
                      style: AppTheme.dm(
                        size: 16,
                        weight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => AppNavigation.goToMyReviews(context),
                      child: Text(
                        'See All',
                        style: AppTheme.dm(
                          size: 13,
                          weight: FontWeight.w700,
                          color: AppColors.gold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ..._recentReviews(),
                const SizedBox(height: 28),

                // 8. Availability
                Text(
                  'Availability',
                  style: AppTheme.dm(
                    size: 16,
                    weight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 12),
                AvailabilityCalendar(
                  blocked: _blockedDays,
                  ongoing: _stayDays(GuestStayPhase.active),
                  upcoming: _stayDays(GuestStayPhase.upcoming),
                  legend: const [
                    'Ongoing',
                    'Upcoming',
                    'Owner days-off',
                    'Blocked'
                  ],
                ),
                const SizedBox(height: 16),
                // Owner days-off card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDF9F4),
                    border:
                        Border.all(color: const Color(0xFFEAD9A8), width: 1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Owner days-off',
                              style: AppTheme.dm(
                                size: 14,
                                weight: FontWeight.w700,
                                color: const Color(0xFF9A7A22),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '2 personal days/month — block them for yourself or keep renting.',
                              style: AppTheme.dm(
                                size: 11,
                                weight: FontWeight.w500,
                                color: const Color(0xFF8A6D1E),
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFC9A84C),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Block days',
                            style: AppTheme.dm(
                              size: 12,
                              weight: FontWeight.w700,
                              color: AppColors.navy,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // 9. Inspection Checklist
                Text(
                  'Inspection Checklist',
                  style: AppTheme.dm(
                    size: 16,
                    weight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 12),
                WhiteCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _checklistRow(
                        icon: Icons.fact_check_outlined,
                        iconColor: AppColors.navy,
                        title: 'Pre check-in',
                        sub: 'Clean & verify before guest',
                        actionLabel: 'Start',
                        isActionCompleted: false,
                      ),
                      const Divider(height: 32, color: AppColors.border),
                      _checklistRow(
                        icon: Icons.watch_later_rounded,
                        iconColor: const Color(0xFFD2760A),
                        title: 'Post check-out',
                        sub: 'Within 24h of departure',
                        actionLabel: 'Start',
                        isActionCompleted: false,
                        onActionTap: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Pre check-in opens up to 2 days & at least 4h before arrival. Post check-out must be done within 24h of departure.',
                  style: AppTheme.dm(
                      size: 11, color: AppColors.muted, height: 1.4),
                ),
                const SizedBox(height: 16),
                WideButton(
                  label: 'Report damage · photos + receipt',
                  icon: Icons.warning_amber_rounded,
                  color: const Color(0xFFB22222),
                  outline: true,
                  height: 48,
                  radius: 12,
                  onTap: () => AppNavigation.goToOwnerViolationReport(context),
                ),
                const SizedBox(height: 28),

                // 10. Upcoming Bookings
                Text(
                  'Upcoming Bookings',
                  style: AppTheme.dm(
                    size: 16,
                    weight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 12),
                ..._upcomingBookings(),
                const SizedBox(height: 120),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static const _avatarColors = [Color(0xFF457B9D), Color(0xFFB39264)];

  static const _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  static String _stayDates(DateTime checkIn, DateTime checkOut) {
    final start = '${_months[checkIn.month - 1]} ${checkIn.day}';
    if (checkIn.month == checkOut.month) return '$start–${checkOut.day}';
    return '$start – ${_months[checkOut.month - 1]} ${checkOut.day}';
  }

  /// `guest_entry` -> `Guest entry`.
  static String _humanize(String event) {
    final text = event.replaceAll('_', ' ').trim();
    return text.isEmpty ? 'Access' : text[0].toUpperCase() + text.substring(1);
  }

  double get _revenue => _bookings.fold(0, (sum, b) => sum + b.payoutEgp);

  static String _compact(double egp) => egp >= 1000
      ? '${(egp / 1000).toStringAsFixed(1)}k'
      : egp.round().toString();

  /// Days of this month covered by stays in [phase].
  List<int> _stayDays(GuestStayPhase phase) {
    final now = DateTime.now();
    final days = <int>{};
    for (final b in _bookings.where((b) => b.phase == phase)) {
      for (var d = b.checkIn;
          d.isBefore(b.checkOut);
          d = d.add(const Duration(days: 1))) {
        if (d.year == now.year && d.month == now.month) days.add(d.day);
      }
    }
    return days.toList()..sort();
  }

  List<Widget> _accessRows() {
    if (_accessLog.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text('No lock activity yet.',
              style: AppTheme.dm(size: 12, color: AppColors.muted)),
        ),
      ];
    }
    final rows = <Widget>[];
    for (final entry in _accessLog.take(3)) {
      if (rows.isNotEmpty) {
        rows.add(const Divider(
            height: 1, indent: 44, endIndent: 16, color: AppColors.border));
      }
      final event =
          '${entry['event'] ?? entry['type'] ?? entry['action'] ?? ''}';
      final lower = event.toLowerCase();
      final (icon, color) = lower.contains('exit') || lower.contains('out')
          ? (Icons.logout_rounded, AppColors.muted)
          : lower.contains('code') || lower.contains('pass')
              ? (Icons.edit_outlined, const Color(0xFFD2760A))
              : (Icons.login_rounded, const Color(0xFF2E7D32));
      final who =
          '${entry['actor_name'] ?? entry['user_name'] ?? entry['by'] ?? ''}';
      final when =
          asDate(entry['created_at'] ?? entry['timestamp'] ?? entry['time']);
      rows.add(_accessItem(icon, color, _humanize(event), who,
          when == null ? '' : '${_months[when.month - 1]} ${when.day}'));
    }
    return rows;
  }

  List<Widget> _recentReviews() {
    if (_reviews.isEmpty) {
      return [
        Text('No reviews yet.',
            style: AppTheme.dm(size: 12, color: AppColors.muted)),
      ];
    }
    final recent = _reviews.take(2).toList();
    return [
      for (var i = 0; i < recent.length; i++) ...[
        if (i > 0) const SizedBox(height: 12),
        _reviewItem(recent[i].userName, recent[i].comment, recent[i].rating,
            _avatarColors[i % 2]),
      ],
    ];
  }

  List<Widget> _upcomingBookings() {
    final upcoming = _bookings
        .where((b) => b.phase == GuestStayPhase.upcoming)
        .toList()
      ..sort((a, b) => a.checkIn.compareTo(b.checkIn));
    if (upcoming.isEmpty) {
      return [
        Text('No upcoming bookings.',
            style: AppTheme.dm(size: 12, color: AppColors.muted)),
      ];
    }
    return [
      for (var i = 0; i < upcoming.length && i < 3; i++) ...[
        if (i > 0) const SizedBox(height: 10),
        _upcomingBookingItem(
            upcoming[i].guestName,
            _stayDates(upcoming[i].checkIn, upcoming[i].checkOut),
            upcoming[i].guests == 1
                ? '1 guest'
                : '${upcoming[i].guests} guests',
            CurrencyFormatter.format(upcoming[i].payoutEgp.round()),
            _avatarColors[i % 2]),
      ],
    ];
  }

  Widget _buildStatsGrid(Property prop) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _statCard('—', 'Views')),
            const SizedBox(width: 12),
            Expanded(child: _statCard('—', 'Saved', trend: 'in wishlists')),
            const SizedBox(width: 12),
            Expanded(
                child: _statCard('${_bookings.length}', 'Bookings',
                    trend: 'confirmed', trendColor: const Color(0xFF2E7D32))),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _statCard('—', 'Occupancy')),
            const SizedBox(width: 12),
            Expanded(
                child: _statCard(
                    prop.reviews == 0
                        ? '—'
                        : '★ ${prop.rating.toStringAsFixed(1)}',
                    'Rating',
                    trend: '${prop.reviews} reviews')),
            const SizedBox(width: 12),
            Expanded(
                child: _statCard(_compact(_revenue), 'Revenue',
                    trend: '${CurrencyFormatter.defaultSymbol} total')),
          ],
        ),
      ],
    );
  }

  Widget _statCard(String v, String l, {String? trend, Color? trendColor}) =>
      WhiteCard(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(v,
                style: AppTheme.dm(
                    size: 18, weight: FontWeight.w800, color: AppColors.navy)),
            const SizedBox(height: 2),
            Text(l, style: AppTheme.dm(size: 10, color: AppColors.muted)),
            if (trend != null) ...[
              const SizedBox(height: 4),
              Text(
                trend,
                style: AppTheme.dm(
                  size: 9,
                  weight: FontWeight.w700,
                  color: trendColor ?? AppColors.success,
                ),
              ),
            ],
          ],
        ),
      );

  Widget _accessItem(
          IconData icon, Color color, String type, String user, String time) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 12),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: AppTheme.dm(
                      size: 13, color: AppColors.navy, weight: FontWeight.w700),
                  children: [
                    TextSpan(text: '$type · '),
                    TextSpan(
                        text: user,
                        style: AppTheme.dm(
                            weight: FontWeight.w500, color: AppColors.muted)),
                  ],
                ),
              ),
            ),
            Text(time, style: AppTheme.dm(size: 11, color: AppColors.faint)),
          ],
        ),
      );

  Widget _reviewItem(
          String name, String text, double rating, Color avatarColor) =>
      WhiteCard(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(radius: 14, backgroundColor: avatarColor),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(name,
                      style: AppTheme.dm(size: 13, weight: FontWeight.w700)),
                ),
                Row(
                  children: List.generate(
                      5,
                      (i) => Icon(Icons.star,
                          size: 12,
                          color:
                              i < rating ? AppColors.gold : AppColors.border)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              text,
              style: AppTheme.dm(size: 12, color: AppColors.ink, height: 1.4),
            ),
          ],
        ),
      );

  Widget _checklistRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String sub,
    required String actionLabel,
    required bool isActionCompleted,
    VoidCallback? onActionTap,
  }) =>
      Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: AppTheme.dm(size: 14, weight: FontWeight.w700)),
                Text(sub,
                    style: AppTheme.dm(
                        size: 11,
                        color: (title == 'Post check-out')
                            ? const Color(0xFFD2760A)
                            : AppColors.muted,
                        weight: (title == 'Post check-out')
                            ? FontWeight.w700
                            : FontWeight.w500)),
              ],
            ),
          ),
          if (isActionCompleted)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFD7EEDD),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                actionLabel,
                style: AppTheme.dm(
                  size: 11,
                  weight: FontWeight.w800,
                  color: const Color(0xFF2E7D32),
                ),
              ),
            )
          else
            GestureDetector(
              onTap: onActionTap,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.navy,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  actionLabel,
                  style: AppTheme.dm(
                    size: 12,
                    weight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      );

  Widget _upcomingBookingItem(String name, String date, String guests,
          String price, Color avatarColor) =>
      WhiteCard(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(radius: 20, backgroundColor: avatarColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: AppTheme.dm(
                          size: 14,
                          weight: FontWeight.w700,
                          color: AppColors.navy),
                      children: [
                        TextSpan(text: '$name · '),
                        TextSpan(
                            text: date,
                            style: AppTheme.dm(
                                weight: FontWeight.w500,
                                color: AppColors.muted)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text('$guests · $price',
                      style: AppTheme.dm(size: 12, color: AppColors.muted)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.navy,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Upcoming',
                style: AppTheme.dm(
                  size: 10,
                  weight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
}

class _SparklinePainter extends CustomPainter {
  /// Daily views would be drawn here. The API has no view counts yet, so the
  /// chart stays empty rather than showing an invented curve.
  const _SparklinePainter();

  @override
  void paint(Canvas canvas, Size size) {}

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class OwnerEditPropertyScreen extends StatefulWidget {
  const OwnerEditPropertyScreen({super.key, this.property});

  /// The listing being edited.
  final Property? property;

  @override
  State<OwnerEditPropertyScreen> createState() =>
      _OwnerEditPropertyScreenState();
}

class _OwnerEditPropertyScreenState extends State<OwnerEditPropertyScreen> {
  late int _price = widget.property?.price ?? 0;
  late final TextEditingController _priceController =
      TextEditingController(text: '$_price');
  final TextEditingController _descController = TextEditingController();

  /// Photo URLs already on the listing, then local files picked here.
  late final List<String> _photos = [
    if ((widget.property?.image ?? '').isNotEmpty) widget.property!.image,
  ];
  final List<String> _amenities = [];
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final id = widget.property?.id ?? '';
    if (id.isNotEmpty) _loadDetails(id);
  }

  /// Description, amenities and the full photo set come from
  /// `GET /properties/:id`.
  Future<void> _loadDetails(String id) async {
    final result = await sl<PropertyRemoteDataSource>().getPropertyDetails(id);
    if (!mounted) return;
    result.fold((_) {}, (details) {
      setState(() {
        _descController.text = details.description;
        _amenities
          ..clear()
          ..addAll(details.amenities);
        final urls = details.images
            .map((image) => image.url)
            .where((url) => url.isNotEmpty)
            .toList();
        if (urls.isNotEmpty) {
          _photos
            ..removeWhere((p) => p.startsWith('http'))
            ..insertAll(0, urls);
        }
      });
    });
  }

  /// Saves the price and description (`PATCH /properties/:id`) and uploads
  /// the photos added here. Amenity changes go through Sahely's review and
  /// have no mobile endpoint, so they are not sent.
  Future<void> _save() async {
    final id = widget.property?.id ?? '';
    if (id.isEmpty || _saving) return;
    setState(() => _saving = true);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final result = await sl<PropertyRemoteDataSource>().updateProperty(id, {
      'base_price_per_night': _price.toStringAsFixed(2),
      'description': _descController.text.trim(),
    });
    var failed = result.isLeft();
    if (!failed) {
      try {
        for (final path in _photos.where((p) => !p.startsWith('http'))) {
          await sl<FileUploadApi>().uploadFile(
            filePath: path,
            uploadType: UploadTypes.propertyImage,
            propertyId: id,
          );
        }
      } catch (_) {
        failed = true;
      }
    }
    if (!mounted) return;
    setState(() => _saving = false);
    messenger.showSnackBar(SnackBar(
        content: Text(failed
            ? 'Could not save your changes. Please try again.'
            : 'Changes saved.')));
    if (!failed) navigator.pop(true);
  }

  final ImagePicker _picker = ImagePicker();

  void _updatePrice(int delta) {
    setState(() {
      _price = (_price + delta).clamp(0, 100000);
      _priceController.text = _price.toString();
    });
  }

  Future<void> _addPhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _photos.add(image.path);
      });
    }
  }

  void _addAmenity() {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Add Amenity',
            style: AppTheme.dm(
                size: 18, weight: FontWeight.w700, color: AppColors.navy)),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'e.g. Sea View, Parking',
            border: UnderlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel',
                style: AppTheme.dm(size: 14, color: AppColors.muted)),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() {
                  _amenities.add(controller.text.trim());
                });
              }
              Navigator.pop(ctx);
            },
            child: Text('Add',
                style: AppTheme.dm(
                    size: 14, weight: FontWeight.w700, color: AppColors.gold)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _priceController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PhoneScaffold(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
              children: [
                // 1. Header
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => AppNavigation.goBack(context),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.borderDefault),
                        ),
                        child: const Icon(Icons.chevron_left,
                            size: 24, color: AppColors.navy),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Edit Property',
                              style: AppTheme.dm(
                                  size: 22,
                                  weight: FontWeight.w700,
                                  color: AppColors.navy)),
                          Text(
                              [
                                widget.property?.name ?? '',
                                widget.property?.area ?? '',
                              ].where((s) => s.isNotEmpty).join(' · '),
                              style: AppTheme.dm(
                                  size: 13, color: AppColors.muted)),
                        ],
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: AppNetworkImage(
                          url: widget.property?.image ?? '',
                          width: 52,
                          height: 52),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // 2. Nightly Price Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('NIGHTLY PRICE',
                        style: AppTheme.dm(
                            size: 13,
                            weight: FontWeight.w800,
                            color: AppColors.navy,
                            letterSpacing: 0.5)),
                    const StatusBadge('Instant', kind: BadgeKind.greenSoft),
                  ],
                ),
                const SizedBox(height: 10),
                WhiteCard(
                  padding: const EdgeInsets.all(20),
                  radius: 20,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Minus Button
                          GestureDetector(
                            onTap: () => _updatePrice(-100),
                            child: Container(
                              width: 54,
                              height: 54,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: AppColors.borderDefault),
                              ),
                              child: const Icon(Icons.remove,
                                  color: AppColors.navy, size: 24),
                            ),
                          ),
                          // Price Display
                          Column(
                            children: [
                              Text('${CurrencyFormatter.defaultSymbol} / night',
                                  style: AppTheme.dm(
                                      size: 12,
                                      weight: FontWeight.w500,
                                      color: AppColors.muted)),
                              const SizedBox(height: 2),
                              Text(CurrencyFormatter.formatNumber(_price),
                                  style: AppTheme.dm(
                                      size: 38,
                                      weight: FontWeight.w800,
                                      color: AppColors.navy,
                                      letterSpacing: -1)),
                            ],
                          ),
                          // Plus Button
                          GestureDetector(
                            onTap: () => _updatePrice(100),
                            child: Container(
                              width: 54,
                              height: 54,
                              decoration: const BoxDecoration(
                                color: AppColors.navy,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.add,
                                  color: Colors.white, size: 24),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD7EEDD),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Applies immediately to new bookings · current ${CurrencyFormatter.format(_price)}',
                          textAlign: TextAlign.center,
                          style: AppTheme.dm(
                            size: 11,
                            weight: FontWeight.w700,
                            color: const Color(0xFF1B6B3A),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 3. Photos Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('PHOTOS',
                        style: AppTheme.dm(
                            size: 13,
                            weight: FontWeight.w800,
                            color: AppColors.navy,
                            letterSpacing: 0.5)),
                    const StatusBadge('Add only', kind: BadgeKind.gold),
                  ],
                ),
                const SizedBox(height: 10),
                WhiteCard(
                  padding: const EdgeInsets.all(16),
                  radius: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          for (int i = 0; i < _photos.length; i++)
                            _photoTile(_photos[i], cover: i == 0),
                          GestureDetector(
                            onTap: _addPhoto,
                            child: DottedBorder(
                              color: AppColors.gold,
                              radius: 12,
                              child: Container(
                                width: 85,
                                height: 85,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.add,
                                        color: AppColors.gold, size: 24),
                                    const SizedBox(height: 4),
                                    Text('Add photo',
                                        style: AppTheme.dm(
                                            size: 10,
                                            weight: FontWeight.w700,
                                            color: AppColors.gold)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDF5E8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.lock_outline,
                                size: 16, color: Color(0xFFD2760A)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: AppTheme.dm(
                                      size: 11,
                                      color: const Color(0xFF8A6D1E),
                                      height: 1.4),
                                  children: [
                                    const TextSpan(
                                        text:
                                            "Existing photos can't be deleted here. "),
                                    TextSpan(
                                      text: "Request removal from support →",
                                      style: AppTheme.dm(
                                              weight: FontWeight.w700,
                                              size: 11,
                                              color: const Color(0xFF8A6D1E))
                                          .copyWith(
                                              decoration:
                                                  TextDecoration.underline),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 4. Description Section
                Text('DESCRIPTION',
                    style: AppTheme.dm(
                        size: 13,
                        weight: FontWeight.w800,
                        color: AppColors.navy,
                        letterSpacing: 0.5)),
                const SizedBox(height: 10),
                WhiteCard(
                  padding: const EdgeInsets.all(16),
                  radius: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDECEC),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline,
                                size: 16, color: Color(0xFFB22222)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Note: no phone numbers or social media accounts allowed.',
                                style: AppTheme.dm(
                                    size: 11,
                                    weight: FontWeight.w700,
                                    color: const Color(0xFFB22222)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _descController,
                        maxLines: null,
                        style: AppTheme.dm(
                            size: 14, color: AppColors.navy, height: 1.5),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text('${_descController.text.length} / 400',
                            style:
                                AppTheme.dm(size: 11, color: AppColors.muted)),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 5. Features & Amenities Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('FEATURES & AMENITIES',
                        style: AppTheme.dm(
                            size: 13,
                            weight: FontWeight.w800,
                            color: AppColors.navy,
                            letterSpacing: 0.5)),
                    const StatusBadge('Reviewed · 24h', kind: BadgeKind.gold),
                  ],
                ),
                const SizedBox(height: 10),
                WhiteCard(
                  padding: const EdgeInsets.all(16),
                  radius: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Edits to the guest checklist are reviewed by Sahely before going live (~24h).',
                        style: AppTheme.dm(
                            size: 12, color: AppColors.muted, height: 1.4),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final amenity in _amenities)
                            _amenityChip(amenity),
                          GestureDetector(
                            onTap: _addAmenity,
                            child: DottedBorder(
                              color: AppColors.gold,
                              radius: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 8),
                                child: Text('+ Add',
                                    style: AppTheme.dm(
                                        size: 13,
                                        weight: FontWeight.w700,
                                        color: AppColors.gold)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 6. Bottom Buttons
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            decoration: const BoxDecoration(
              color: AppColors.cream,
              border:
                  Border(top: BorderSide(color: AppColors.border, width: 0.5)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 54,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: null,
                      ),
                      child: Text('Discard',
                          style: AppTheme.dm(
                              size: 16,
                              weight: FontWeight.w700,
                              color: AppColors.navy)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: NavyButton(
                    label: _saving ? 'Saving…' : 'Save changes',
                    height: 54,
                    radius: 16,
                    onTap: _save,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _photoTile(String img, {bool cover = false}) => ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 85,
          height: 85,
          decoration: const BoxDecoration(color: AppColors.cardWarm),
          child: Stack(
            fit: StackFit.expand,
            children: [
              img.startsWith('http')
                  ? AppNetworkImage(url: img)
                  : Image.file(File(img), fit: BoxFit.cover),
              if (cover)
                Positioned(
                  top: 6,
                  left: 6,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                        color: AppColors.gold,
                        borderRadius: BorderRadius.circular(6)),
                    child: Text('Cover',
                        style: AppTheme.dm(
                            size: 8,
                            weight: FontWeight.w800,
                            color: AppColors.navy)),
                  ),
                ),
              Positioned(
                bottom: 6,
                right: 6,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.lock, size: 12, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _amenityChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label,
              style: AppTheme.dm(
                  size: 13, weight: FontWeight.w700, color: Colors.white)),
          const SizedBox(width: 4),
          const Icon(Icons.check, size: 14, color: Colors.white),
        ],
      ),
    );
  }
}

class OwnerPreviewListingScreen extends StatelessWidget {
  const OwnerPreviewListingScreen({super.key, this.property});

  /// The listing previewed as guests see it.
  final Property? property;

  @override
  Widget build(BuildContext context) {
    final p = property;
    if (p == null) {
      return Scaffold(
        backgroundColor: AppColors.cream,
        body: Center(
          child: Text('Open a listing from My Properties.',
              style: AppTheme.dm(color: AppColors.muted)),
        ),
      );
    }
    final isLive = p.status == PropertyStatus.active;
    return PhoneScaffold(
      child: Column(children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            children: [
              TopBar(
                  title: 'Listing status',
                  subtitle: 'How guests see ${p.name}'),
              const SizedBox(height: 16),
              WhiteCard(
                padding: EdgeInsets.zero,
                radius: 16,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            height: 170,
                            width: double.infinity,
                            child: Stack(fit: StackFit.expand, children: [
                              AppNetworkImage(
                                  url: p.image,
                                  errorWidget: (_, __, ___) => const ColoredBox(
                                      color: AppColors.cardWarm)),
                              Positioned(
                                  top: 10,
                                  left: 10,
                                  child: StatusBadge(
                                      isLive
                                          ? 'Live · Bookable'
                                          : 'Not bookable',
                                      kind: isLive
                                          ? BadgeKind.green
                                          : BadgeKind.gray,
                                      dot: isLive)),
                              Positioned(
                                  top: 10,
                                  right: 10,
                                  child: SaveHeart(property: p)),
                            ])),
                        Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(p.name,
                                      style: AppTheme.dm(
                                          size: 16,
                                          weight: FontWeight.w700,
                                          color: AppColors.navy)),
                                  Text(p.area,
                                      style: AppTheme.dm(
                                          size: 12, color: AppColors.muted)),
                                  const SizedBox(height: 8),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                              p.reviews == 0
                                                  ? 'No reviews yet'
                                                  : '★ ${p.rating.toStringAsFixed(1)} · ${p.reviews} reviews',
                                              style: AppTheme.dm(
                                                  size: 12,
                                                  color: AppColors.muted),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                        const SizedBox(width: 8),
                                        PriceTag(price: p.price, size: 15),
                                      ]),
                                  const SizedBox(height: 10),
                                  Wrap(spacing: 7, runSpacing: 7, children: [
                                    Pill(p.type, border: AppColors.navy),
                                    if (p.guests > 0)
                                      Pill('${p.guests} Guests',
                                          border: AppColors.navy),
                                    for (final tag in p.tags)
                                      Pill(tag, border: AppColors.navy),
                                    if (p.petsOk)
                                      const Pill('🐾 Pets',
                                          bg: Color(0xFFD7EEDD),
                                          fg: AppColors.success),
                                  ]),
                                ])),
                      ]),
                ),
              ),
              const SizedBox(height: 14),
              WhiteCard(
                padding: const EdgeInsets.all(14),
                child: Row(children: [
                  Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                          color: const Color(0xFFD7EEDD),
                          borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.check, color: AppColors.success)),
                  const SizedBox(width: 12),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text(isLive ? 'Listed' : 'Not listed',
                            style: AppTheme.dm(
                                size: 14,
                                weight: FontWeight.w700,
                                color: AppColors.navy)),
                        Text(
                            isLive
                                ? 'Visible & accepting bookings'
                                : 'Guests cannot see or book it yet',
                            style:
                                AppTheme.dm(size: 11, color: AppColors.muted)),
                      ])),
                  Container(
                      width: 42,
                      height: 24,
                      decoration: BoxDecoration(
                          color: isLive ? AppColors.success : AppColors.border,
                          borderRadius: BorderRadius.circular(12)),
                      child: Align(
                          alignment: isLive
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: const Padding(
                              padding: EdgeInsets.all(2),
                              child: CircleAvatar(
                                  radius: 10, backgroundColor: Colors.white)))),
                ]),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [AppColors.gold, Color(0xFFB3923C)]),
                    borderRadius: BorderRadius.circular(14)),
                child: Row(children: [
                  Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                          color: AppColors.navy,
                          borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.lock_outline,
                          color: AppColors.gold)),
                  const SizedBox(width: 12),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text('Protected listing period',
                            style: AppTheme.dm(
                                size: 14,
                                weight: FontWeight.w700,
                                color: AppColors.navy)),
                        Text(
                            'New listings stay live for their first month. Part of our T&Cs.',
                            style: AppTheme.dm(
                                size: 11,
                                color: const Color(0xFF3A3320),
                                height: 1.4)),
                      ])),
                ]),
              ),
            ],
          ),
        ),
        const Padding(
            padding: EdgeInsets.all(16),
            child: WideButton(
                label: 'Unlisting locked during the first month',
                icon: Icons.lock,
                color: Color(0xFFE7DFD2),
                textColor: AppColors.muted,
                height: 52)),
      ]),
    );
  }
}

/// Days of the current month a listing is blocked
/// (`/properties/:id/availability` -> `blocked_dates`).
Future<List<int>> _blockedDaysThisMonth(String propertyId) async {
  final response =
      await sl<ApiClient>().get(ApiEndpoints.propertyAvailability(propertyId));
  final data = asMap(unwrapData(response.data));
  final dates = (pick(data, 'blocked_dates') as List?) ?? const [];
  final now = DateTime.now();
  return dates
      .map((d) => DateTime.tryParse('$d'))
      .whereType<DateTime>()
      .where((d) => d.year == now.year && d.month == now.month)
      .map((d) => d.day)
      .toSet()
      .toList()
    ..sort();
}
