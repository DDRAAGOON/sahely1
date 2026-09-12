import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sahely/core/di/service_locator.dart' show sl;
import 'package:sahely/core/navigation/app_navigation.dart';
import 'package:sahely/core/network/api_client.dart';
import 'package:sahely/core/network/api_endpoints.dart';
import 'package:sahely/core/network/api_envelope.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/theme/system_ui.dart';
import 'package:sahely/core/widgets/image.dart';
import 'package:sahely/core/widgets/kit.dart';
import 'package:sahely/features/broker/presentation/bloc/broker_home_cubit.dart';
import 'package:sahely/features/broker/presentation/bloc/broker_home_state.dart';
import 'package:sahely/features/renter/domain/repositories/renter_repository.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';

/// A property the broker referred, opened from the portfolio.
///
/// `/broker/properties` only lists id, title and status, so the listing
/// details come from `/properties/:id` and the blocked days from its
/// availability. Per-property bookings, occupancy and views are not in the
/// mobile API; those figures show "—".
class ReferredPropertyDetailPage extends StatefulWidget {
  const ReferredPropertyDetailPage({super.key, this.property});

  final Property? property;

  @override
  State<ReferredPropertyDetailPage> createState() =>
      _ReferredPropertyDetailPageState();
}

class _ReferredPropertyDetailPageState
    extends State<ReferredPropertyDetailPage> {
  Property? _details;
  List<int> _blockedDays = const [];

  @override
  void initState() {
    super.initState();
    final id = widget.property?.id ?? '';
    if (id.isNotEmpty) {
      _loadDetails(id);
      _loadBlockedDays(id);
    }
  }

  Future<void> _loadDetails(String id) async {
    try {
      final details = await sl<RenterRepository>().getProperty(id);
      if (mounted) setState(() => _details = details);
    } catch (_) {
      // The portfolio's own values stay on screen.
    }
  }

  /// Days of the current month the listing is blocked
  /// (`/properties/:id/availability` -> `blocked_dates`).
  Future<void> _loadBlockedDays(String id) async {
    try {
      final response =
          await sl<ApiClient>().get(ApiEndpoints.propertyAvailability(id));
      final data = asMap(unwrapData(response.data));
      final dates = (pick(data, 'blocked_dates') as List?) ?? const [];
      final now = DateTime.now();
      final days = dates
          .map((d) => DateTime.tryParse('$d'))
          .whereType<DateTime>()
          .where((d) => d.year == now.year && d.month == now.month)
          .map((d) => d.day)
          .toSet()
          .toList()
        ..sort();
      if (mounted) setState(() => _blockedDays = days);
    } catch (_) {
      // Without availability the calendar shows no marks.
    }
  }

  static String _rate(double rate) {
    final percent = rate <= 1 ? rate * 100 : rate;
    return percent == percent.roundToDouble()
        ? '${percent.round()}%'
        : '${percent.toStringAsFixed(1)}%';
  }

  static String _statusLabel(PropertyStatus status) => switch (status) {
        PropertyStatus.active => 'Live',
        PropertyStatus.underReview => 'In review',
        PropertyStatus.draft => 'Draft',
        _ => 'Not listed',
      };

  @override
  Widget build(BuildContext context) {
    final property = _details ?? widget.property;
    if (property == null) {
      return Scaffold(
        backgroundColor: AppColors.cream,
        body: Center(
          child: Text('Open a property from your portfolio.',
              style: AppTheme.dm(color: AppColors.muted)),
        ),
      );
    }
    final isLive = property.status == PropertyStatus.active;
    final dashboard = context
        .select<BrokerHomeCubit, BrokerHomeState>((cubit) => cubit.state);
    final rate = dashboard is BrokerHomeLoaded
        ? _rate(dashboard.dashboard.commissionRate)
        : '—';

    return LightStatusBar(
      child: Scaffold(
        backgroundColor: AppColors.cream,
        body: CreamBackground(
          child: ListView(padding: EdgeInsets.zero, children: [
            Stack(children: [
              SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: AppNetworkImage(
                      url: property.image,
                      errorWidget: (_, __, ___) =>
                          const ColoredBox(color: AppColors.cardWarm))),
              Positioned(
                  top: 44,
                  left: 16,
                  child: GestureDetector(
                      onTap: () => Navigator.maybePop(context),
                      child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.92),
                              shape: BoxShape.circle),
                          child: const Icon(Icons.chevron_left,
                              color: AppColors.navy)))),
              Positioned(
                  top: 50,
                  right: 16,
                  child: StatusBadge(_statusLabel(property.status),
                      kind: isLive ? BadgeKind.green : BadgeKind.gray,
                      dot: isLive)),
              Positioned(
                  left: 18,
                  right: 18,
                  bottom: 14,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(property.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTheme.dm(
                                size: 20,
                                weight: FontWeight.w700,
                                color: Colors.white)),
                        if (property.area.isNotEmpty)
                          Text(property.area,
                              style:
                                  AppTheme.dm(size: 12, color: Colors.white70)),
                      ])),
            ]),
            Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(spacing: 7, runSpacing: 7, children: [
                        Pill(property.type, border: AppColors.navy),
                        if (property.beds > 0)
                          Pill('${property.beds} Bedrooms',
                              border: AppColors.navy),
                        if (property.guests > 0)
                          Pill('${property.guests} Guests',
                              border: AppColors.navy),
                        for (final tag in property.tags)
                          Pill(tag, border: AppColors.navy),
                      ]),
                      const SizedBox(height: 16),
                      Text('Availability',
                          style: AppTheme.dm(
                              size: 15,
                              weight: FontWeight.w700,
                              color: AppColors.navy)),
                      const SizedBox(height: 8),
                      AvailabilityCalendar(
                          blocked: _blockedDays,
                          ongoing: const [],
                          upcoming: const []),
                      const SizedBox(height: 16),
                      Text('Your earnings from this property',
                          style: AppTheme.dm(
                              size: 15,
                              weight: FontWeight.w700,
                              color: AppColors.navy)),
                      const SizedBox(height: 8),
                      WhiteCard(
                          padding: const EdgeInsets.all(14),
                          child: Column(children: [
                            KeyValueRow('Your commission rate', rate),
                            const KeyValueRow('Bookings (season)', '—'),
                            const KeyValueRow('Nights rented', '—'),
                            const KeyValueRow('Commission earned', '—',
                                valueColor: AppColors.success),
                            const KeyValueRow('Pending commission', '—',
                                valueColor: Color(0xFFD2760A)),
                          ])),
                      const SizedBox(height: 16),
                      Text('Listing performance',
                          style: AppTheme.dm(
                              size: 15,
                              weight: FontWeight.w700,
                              color: AppColors.navy)),
                      const SizedBox(height: 8),
                      StatRow(cards: [
                        StatCard(
                            value: property.reviews == 0
                                ? '—'
                                : '★ ${property.rating.toStringAsFixed(1)}',
                            label: '${property.reviews} reviews'),
                        const StatCard(value: '—', label: 'Occupancy'),
                        const StatCard(value: '—', label: 'Views/wk'),
                      ]),
                      const SizedBox(height: 16),
                      NavyButton(
                          label: 'View public listing',
                          radius: 14,
                          onTap: () => AppNavigation.goToPropertyDetail(context,
                              extra: property)),
                    ])),
          ]),
        ),
      ),
    );
  }
}
