import 'package:flutter/material.dart';

import 'package:sahely/core/di/service_locator.dart' show sl;
import 'package:sahely/core/network/api_client.dart';
import 'package:sahely/core/network/api_endpoints.dart';
import 'package:sahely/core/network/api_envelope.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/kit.dart';
import 'package:sahely/features/owner/domain/repositories/owner_repository.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';
import 'package:sahely/features/shared/violations/data/violations_api_data_source.dart';

import '../../../core/utils/currency_formatter.dart';

/// Portfolio totals from `/properties/mine/portfolio/dashboard`, the owner's
/// listings and their violations. Views and wishlist saves are not in the
/// mobile API and show "—".
class PortfolioInsightsScreen extends StatefulWidget {
  const PortfolioInsightsScreen({super.key});

  @override
  State<PortfolioInsightsScreen> createState() =>
      _PortfolioInsightsScreenState();
}

class _PortfolioInsightsScreenState extends State<PortfolioInsightsScreen> {
  Map<String, dynamic> _dashboard = const {};
  List<Property> _properties = const [];
  int _openViolations = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  /// Each source loads on its own; one failing leaves the others intact.
  Future<void> _load() async {
    Map<String, dynamic> dashboard = const {};
    List<Property> properties = const [];
    var violations = 0;
    try {
      final response =
          await sl<ApiClient>().get(ApiEndpoints.myPortfolioDashboard);
      dashboard = asMap(unwrapData(response.data));
    } catch (_) {}
    try {
      properties = await sl<OwnerRepository>().getMyProperties();
    } catch (_) {}
    try {
      final rows = await sl<ViolationsApiDataSource>().mine();
      violations = rows.where((v) {
        final s = '${v['status'] ?? ''}'.toLowerCase();
        return !(s.contains('resolv') ||
            s.contains('clos') ||
            s.contains('dismiss') ||
            s.contains('reject'));
      }).length;
    } catch (_) {}
    if (!mounted) return;
    setState(() {
      _dashboard = dashboard;
      _properties = properties;
      _openViolations = violations;
    });
  }

  @override
  Widget build(BuildContext context) {
    final revenue = asMap(_dashboard['revenueAnalytics']);
    final occupancy = asMap(_dashboard['occupancy']);
    final operational = asMap(_dashboard['operational']);
    final thisMonth = (asNum(revenue['thisMonthEgp'])?.toDouble() ?? 0).round();
    final change = asNum(revenue['changePercentage']);
    final occupancyRate = asNum(occupancy['occupancyRate']);
    final rated = _properties.where((p) => p.reviews > 0).toList();
    final avgRating = rated.isEmpty
        ? null
        : rated.fold<double>(0, (sum, p) => sum + p.rating) / rated.length;
    final best = asListOfMaps(_dashboard['bestPerformingProperties']);
    final drafts =
        _properties.where((p) => p.status == PropertyStatus.draft).length;

    return PhoneScaffold(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        children: [
          TopBar(
              title: 'Portfolio',
              subtitle: 'All ${_properties.length} properties combined'),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Color(0xFF2A3A64), AppColors.navy]),
                borderRadius: BorderRadius.circular(16)),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Total revenue · this month',
                  style: AppTheme.dm(size: 13, color: const Color(0xFFCDD4E0))),
              const SizedBox(height: 6),
              Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Flexible(
                  child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(CurrencyFormatter.format(thisMonth),
                          style: AppTheme.dm(
                              size: 28,
                              weight: FontWeight.w700,
                              color: Colors.white))),
                ),
                const SizedBox(width: 10),
                if (change != null && change != 0)
                  Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Text(
                          '${change > 0 ? '▲' : '▼'} ${change.abs().round()}%',
                          style: AppTheme.dm(
                              size: 13,
                              weight: FontWeight.w700,
                              color: change > 0
                                  ? const Color(0xFF7BE0A0)
                                  : const Color(0xFFFF8A80)))),
              ]),
            ]),
          ),
          const SizedBox(height: 14),
          StatRow(cards: [
            const StatCard(value: '—', label: 'Total views'),
            const StatCard(value: '—', label: 'Wishlist saves'),
            StatCard(
                value: '${asNum(operational['activeBookings'])?.toInt() ?? 0}',
                label: 'Bookings'),
          ]),
          const SizedBox(height: 10),
          StatRow(cards: [
            StatCard(
                value:
                    occupancyRate == null ? '—' : '${occupancyRate.round()}%',
                label: 'Avg occupancy'),
            StatCard(
                value: avgRating == null
                    ? '—'
                    : '★ ${avgRating.toStringAsFixed(1)}',
                label: 'Avg rating'),
            StatCard(
                value: '$_openViolations',
                label:
                    _openViolations == 1 ? 'Open violation' : 'Open violations',
                valueColor: const Color(0xFFD2760A)),
          ]),
          const SizedBox(height: 18),
          Text('Performance · head to head',
              style: AppTheme.dm(
                  size: 15, weight: FontWeight.w700, color: AppColors.navy)),
          Text('Ranked by occupancy & revenue',
              style: AppTheme.dm(size: 12, color: AppColors.muted)),
          const SizedBox(height: 12),
          if (best.isEmpty)
            Text('Rankings appear once your listings have bookings.',
                style: AppTheme.dm(size: 12, color: AppColors.muted))
          else
            for (var i = 0; i < best.length && i < 3; i++) ...[
              if (i > 0) const SizedBox(height: 10),
              _bestCard(best[i], top: i == 0),
            ],
          if (drafts > 0) ...[
            const SizedBox(height: 16),
            InfoNote(
                text: drafts == 1
                    ? "1 listing isn't published yet — finishing its setup lets guests book it."
                    : "$drafts listings aren't published yet — finishing their setup lets guests book them."),
          ],
        ],
      ),
    );
  }

  /// A `bestPerformingProperties` row; the field names are read leniently.
  Widget _bestCard(Map<String, dynamic> row, {required bool top}) {
    final name = '${row['title'] ?? row['name'] ?? ''}';
    final revenueEgp = asNum(row['revenueEgp'] ??
                row['totalRevenueEgp'] ??
                row['thisMonthEgp'])
            ?.toDouble() ??
        (asNum(row['revenue'] ?? row['totalRevenue'])?.toDouble() ?? 0) / 100;
    final rate = asNum(row['occupancyRate'] ?? row['occupancy'])?.toDouble();
    final pct = rate == null ? 0.0 : (rate > 1 ? rate / 100 : rate);
    return _barCard(
        name,
        '${CurrencyFormatter.format(revenueEgp.round())} this month',
        pct.clamp(0.0, 1.0),
        top ? AppColors.gold : AppColors.navy,
        top: top);
  }

  Widget _barCard(String name, String revenue, double pct, Color color,
          {bool top = false}) =>
      WhiteCard(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(
                child: Text(name,
                    style: AppTheme.dm(
                        size: 14,
                        weight: FontWeight.w700,
                        color: AppColors.navy))),
            if (top) const StatusBadge('Top performer', kind: BadgeKind.gold),
            const SizedBox(width: 8),
            Text('${(pct * 100).round()}%',
                style: AppTheme.dm(
                    size: 14, weight: FontWeight.w700, color: AppColors.navy)),
          ]),
          const SizedBox(height: 4),
          Text(revenue, style: AppTheme.dm(size: 12, color: AppColors.muted)),
          const SizedBox(height: 8),
          ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                  value: pct,
                  minHeight: 8,
                  backgroundColor: const Color(0xFFE6EAF2),
                  valueColor: AlwaysStoppedAnimation(color))),
        ]),
      );
}
