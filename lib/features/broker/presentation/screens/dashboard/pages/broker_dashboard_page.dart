import 'package:flutter/material.dart';
import 'package:sahely/core/navigation/app_navigation.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/kit.dart';
import 'package:sahely/core/widgets/image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahely/core/providers/profile_provider.dart';
import 'package:sahely/features/broker/domain/entities/broker_dashboard.dart';
import 'package:sahely/features/broker/presentation/bloc/broker_home_cubit.dart';
import 'package:sahely/features/broker/presentation/bloc/broker_home_state.dart';

class BrokerDashboardPage extends StatelessWidget {
  const BrokerDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: BlocBuilder<BrokerHomeCubit, BrokerHomeState>(
            builder: (context, state) {
          if (state is BrokerHomeInitial) {
            WidgetsBinding.instance.addPostFrameCallback(
                (_) => context.read<BrokerHomeCubit>().loadDashboard());
          }
          final d = state is BrokerHomeLoaded ? state.dashboard : null;
          final name = context.watch<ProfileProvider>().name;
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.border),
                    ),
                    child:
                        const Icon(Icons.chevron_left, color: AppColors.navy),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // 1. Header
              Row(children: [
                const AvatarCircle(
                    size: 44, colors: [Color(0xFFC9A84C), Color(0xFF8A7330)]),
                const SizedBox(width: 12),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(
                          name.isEmpty
                              ? 'Good morning'
                              : 'Good morning, ${name.split(' ').first}',
                          style: AppTheme.dm(
                              size: 18,
                              weight: FontWeight.w700,
                              color: AppColors.navy)),
                      Text(
                          d == null
                              ? ''
                              : '${d.level} Broker · ${_rate(d.commissionRate)} rate',
                          style: AppTheme.dm(size: 12, color: AppColors.muted)),
                    ])),
              ]),
              const SizedBox(height: 14),

              // 2. Tier Card
              GestureDetector(
                onTap: () => AppNavigation.goToBrokerTier(context),
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [Color(0xFF2A3A64), Color(0xFF141D33)]),
                      borderRadius: BorderRadius.circular(16)),
                  child: Column(children: [
                    Row(children: [
                      Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                              color: AppColors.gold.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(10)),
                          child: const Icon(Icons.home_outlined,
                              color: AppColors.gold, size: 20)),
                      const SizedBox(width: 10),
                      Text(d == null ? '—' : '${d.level} Tier',
                          style: AppTheme.dm(
                              size: 16,
                              weight: FontWeight.w700,
                              color: AppColors.gold)),
                      const Spacer(),
                      Text(
                          d == null || d.nextLevelName.isEmpty
                              ? ''
                              : '${d.starsToNextLevel} to ${d.nextLevelName}',
                          style: AppTheme.dm(
                              size: 11, color: const Color(0xFF9FB0CF))),
                    ]),
                    const SizedBox(height: 12),
                    ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                            value: _progress(d),
                            minHeight: 6,
                            backgroundColor: Colors.white24,
                            valueColor:
                                const AlwaysStoppedAnimation(AppColors.gold))),
                    const SizedBox(height: 14),
                    Row(children: [
                      _miniStat(d == null ? '—' : '${d.liveProps}',
                          'Properties', Colors.white),
                      _miniStat(d == null ? '—' : d.totalEarnings,
                          'Total earned', Colors.white),
                      _miniStat(d == null ? '—' : d.thisMonthEarnings,
                          'This month', AppColors.gold),
                      _miniStat(d == null ? '—' : d.pendingEarnings, 'Pending',
                          AppColors.goldBright),
                    ]),
                  ]),
                ),
              ),
              const SizedBox(height: 12),

              // 3. Main Action Tiles
              Row(children: [
                Expanded(
                    child: _actionTile(
                        context,
                        'Wallet',
                        Icons.account_balance_wallet_outlined,
                        () => AppNavigation.goToBrokerWallet(context))),
                const SizedBox(width: 10),
                Expanded(
                    child: _actionTile(
                        context,
                        'Portfolio',
                        Icons.grid_view_outlined,
                        () => AppNavigation.goToBrokerPortfolio(context))),
                const SizedBox(width: 10),
                Expanded(
                    child: _actionTile(
                        context,
                        'Refer',
                        Icons.person_add_outlined,
                        () => AppNavigation.goToShareEarn(context))),
              ]),
              const SizedBox(height: 12),

              // 4. White Stats Row
              StatRow(cards: [
                StatCard(
                    value: d == null ? '—' : d.thisMonthEarnings,
                    label: 'This Month',
                    onTap: () => AppNavigation.goToBrokerWallet(context)),
                StatCard(
                    value: d == null ? '—' : d.totalEarnings,
                    label: 'Total Earned',
                    onTap: () => AppNavigation.goToBrokerWallet(context)),
                StatCard(
                    value: d == null ? '—' : '${d.liveProps}',
                    label: 'Live Props',
                    onTap: () => AppNavigation.goToBrokerPortfolio(context)),
              ]),
              const SizedBox(height: 12),

              // 5. Referred Properties Link
              GestureDetector(
                onTap: () => AppNavigation.goToBrokerPortfolio(context),
                behavior: HitTestBehavior.opaque,
                child: WhiteCard(
                    padding: const EdgeInsets.all(14),
                    child: Row(children: [
                      Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              color: AppColors.cream,
                              borderRadius: BorderRadius.circular(12)),
                          child: const Icon(Icons.grid_view_outlined,
                              color: AppColors.navy, size: 20)),
                      const SizedBox(width: 12),
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Text('Referred Properties',
                                style: AppTheme.dm(
                                    size: 14,
                                    weight: FontWeight.w700,
                                    color: AppColors.navy)),
                            Text(
                                '${d == null ? '—' : d.liveProps} live · tap to view',
                                style: AppTheme.dm(
                                    size: 12, color: AppColors.muted)),
                          ])),
                      const Icon(Icons.chevron_right,
                          color: AppColors.faint, size: 18),
                    ])),
              ),
              const SizedBox(height: 24),

              // 6. Upcoming Check-ins
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Upcoming Check-ins',
                    style: AppTheme.dm(
                        size: 18,
                        weight: FontWeight.w700,
                        color: AppColors.navy)),
                GestureDetector(
                  onTap: () => AppNavigation.goToBrokerBookings(context,
                      tab: 'Upcoming'),
                  child: Text('See All',
                      style: AppTheme.dm(
                          size: 13,
                          weight: FontWeight.w600,
                          color: AppColors.gold)),
                ),
              ]),
              const SizedBox(height: 12),
              ..._upcomingCheckIns(context, d),

              const SizedBox(height: 24),

              // 7. Top Referred Properties
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Top Referred Properties',
                    style: AppTheme.dm(
                        size: 18,
                        weight: FontWeight.w700,
                        color: AppColors.navy)),
                GestureDetector(
                  onTap: () => AppNavigation.goToBrokerPortfolio(context),
                  child: Text(d == null ? 'All' : 'All ${d.liveProps}',
                      style: AppTheme.dm(
                          size: 13,
                          weight: FontWeight.w600,
                          color: AppColors.gold)),
                ),
              ]),
              const SizedBox(height: 12),
              Text('Results per property will show here as bookings come in.',
                  style: AppTheme.dm(size: 12, color: AppColors.muted)),
            ],
          );
        }),
      ),
    );
  }

  Widget _miniStat(String v, String l, Color c) => Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Text(v,
            style: AppTheme.dm(size: 16, weight: FontWeight.w700, color: c)),
        const SizedBox(height: 2),
        Text(l, style: AppTheme.dm(size: 9, color: const Color(0xFF9FB0CF))),
      ]));

  Widget _actionTile(BuildContext context, String label, IconData icon,
          VoidCallback onTap) =>
      GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
            height: 76,
            decoration: BoxDecoration(
                color: AppColors.navy, borderRadius: BorderRadius.circular(14)),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(icon, color: AppColors.gold, size: 22),
              const SizedBox(height: 6),
              Text(label,
                  style: AppTheme.dm(
                      size: 12, weight: FontWeight.w700, color: Colors.white)),
            ])),
      );

  Widget _checkInItem(BuildContext context, String name, String meta,
          String img, String margin, int nights) =>
      GestureDetector(
        onTap: () => AppNavigation.goToBookingUpcoming(context, extra: {
          'propertyName': name,
          'location': '',
          'imageUrl': img,
          'total': margin,
          'guests': '',
          'nights': nights,
        }),
        behavior: HitTestBehavior.opaque,
        child: WhiteCard(
          padding: const EdgeInsets.all(12),
          child: Row(children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: AppNetworkImage(url: img, width: 44, height: 44)),
            const SizedBox(width: 12),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(name,
                      style: AppTheme.dm(
                          size: 14,
                          weight: FontWeight.w700,
                          color: AppColors.navy)),
                  Text(meta,
                      style: AppTheme.dm(size: 12, color: AppColors.muted)),
                ])),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(margin,
                  style: AppTheme.dm(
                      size: 14,
                      weight: FontWeight.w700,
                      color: AppColors.success)),
              Text('your margin',
                  style: AppTheme.dm(size: 10, color: AppColors.muted)),
            ]),
          ]),
        ),
      );

  static String _rate(double rate) {
    final percent = rate <= 1 ? rate * 100 : rate;
    return percent == percent.roundToDouble()
        ? '${percent.round()}%'
        : '${percent.toStringAsFixed(1)}%';
  }

  /// Share of the way to the next tier, in approved properties.
  static double _progress(BrokerDashboard? d) {
    if (d == null) return 0;
    final total = d.currentStars + d.starsToNextLevel;
    return total == 0 ? 0 : d.currentStars / total;
  }

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

  /// The next two stays on referred properties, from the dashboard's recent
  /// commissions. Those rows carry the booking but no property title.
  List<Widget> _upcomingCheckIns(BuildContext context, BrokerDashboard? d) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final rows =
        (d?.upcomingCheckins ?? const <Map<String, dynamic>>[]).where((row) {
      final checkIn = DateTime.tryParse('${row['check_in'] ?? ''}');
      final status = '${row['booking_status'] ?? ''}'.toUpperCase();
      return checkIn != null &&
          !checkIn.isBefore(today) &&
          !status.contains('CANCEL') &&
          !status.contains('EXPIRE') &&
          !status.contains('REJECT');
    }).toList()
          ..sort((a, b) => '${a['check_in']}'.compareTo('${b['check_in']}'));

    if (rows.isEmpty) {
      return [
        Text('No upcoming check-ins yet.',
            style: AppTheme.dm(size: 12, color: AppColors.muted)),
      ];
    }
    return [
      for (final row in rows.take(2)) ...[
        _checkInFromRow(context, row),
        const SizedBox(height: 10),
      ],
    ];
  }

  Widget _checkInFromRow(BuildContext context, Map<String, dynamic> row) {
    final checkIn = DateTime.parse('${row['check_in']}');
    final checkOut = DateTime.tryParse('${row['check_out'] ?? ''}') ?? checkIn;
    final nights = checkOut.difference(checkIn).inDays;
    final id = '${row['booking_id'] ?? ''}'.replaceAll('-', '');
    final reference = id.isEmpty
        ? 'Booking'
        : 'Booking SHLY-${id.substring(0, id.length < 8 ? id.length : 8).toUpperCase()}';
    final commission = double.tryParse('${row['commission_egp'] ?? ''}') ??
        (double.tryParse('${row['commission_piastres'] ?? ''}') ?? 0) / 100;
    return _checkInItem(
      context,
      reference,
      '${_months[checkIn.month - 1]} ${checkIn.day} · $nights ${nights == 1 ? 'night' : 'nights'}',
      '',
      '+${commission.round()}',
      nights,
    );
  }
}
