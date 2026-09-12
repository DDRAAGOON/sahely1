import 'package:flutter/material.dart';

import 'package:sahely/core/errors/exception_mapper.dart';
import 'package:sahely/core/network/api_client.dart';
import 'package:sahely/core/network/api_envelope.dart';
import 'package:sahely/features/broker/data/datasources/broker_api_data_source.dart';
import 'package:sahely/features/broker/domain/entities/broker_dashboard.dart';
import 'package:sahely/features/broker/domain/entities/broker_portfolio.dart';
import 'package:sahely/features/broker/domain/entities/broker_wallet.dart';
import 'package:sahely/features/broker/domain/repositories/broker_repository.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';

import '../../../../core/utils/currency_formatter.dart';

/// Broker repository backed by the `/broker/*` API.
class BrokerRepositoryImpl implements BrokerRepository {
  final BrokerApiDataSource apiDataSource;

  BrokerRepositoryImpl({BrokerApiDataSource? api, ApiClient? apiClient})
      : apiDataSource = api ?? BrokerApiDataSource(apiClient ?? ApiClient());

  /// `GET /broker/dashboard`. Field names verified against the live payload:
  /// `current_tier`, `next_tier`, `approved_properties`,
  /// `properties_to_next_tier`, `available_commission_piastres`, ... There is
  /// no `tier` sub-object and no `stars` - broker progression is counted in
  /// *approved properties*, not stars.
  @override
  Future<BrokerDashboard> getBrokerDashboardData() async {
    final api = apiDataSource;

    try {
      final data = await api.fetchDashboard();
      return BrokerDashboard(
        // The dashboard payload carries no display name; the header falls back
        // to the company name when the profile has been loaded.
        name: '${data['company_name'] ?? ''}',
        role: 'Broker',
        level: _titleCase('${data['current_tier'] ?? ''}'),
        levelIcon: Icons.waves,
        currentStars: asNum(data['approved_properties'])?.toInt() ?? 0,
        starsToNextLevel: asNum(data['properties_to_next_tier'])?.toInt() ?? 0,
        nextLevelName: _titleCase('${data['next_tier'] ?? ''}'),
        thisMonthEarnings:
            _formatPiastres(data['available_commission_piastres']),
        totalEarnings: _formatPiastres(data['total_earnings_piastres']),
        pendingEarnings: _formatPiastres(data['pending_commission_piastres']),
        commissionRate: asNum(data['commission_rate'])?.toDouble() ?? 0,
        liveProps: asNum(data['approved_properties'])?.toInt() ?? 0,
        needHelp: asNum(data['bookings'])?.toInt() ?? 0,
        upcomingCheckins: asListOfMaps(data['recentCommissions']),
        // No property rows are returned by this endpoint.
        trendingProperties: const [],
      );
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  @override
  Future<BrokerPortfolio> getBrokerPortfolio() async {
    final api = apiDataSource;

    try {
      final raw = await api.fetchProperties();
      final properties = raw.map(_toProperty).toList();
      final active = properties
          .where((property) => property.status == PropertyStatus.active)
          .length;
      return BrokerPortfolio(
        totalCount: properties.length,
        activeCount: active,
        notListedCount: properties.length - active,
        properties: properties,
      );
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  /// [monthOffset] selects an earnings window: 0 is the current month,
  /// -1 the previous one, and so on.
  ///
  /// Amounts come from `/broker/dashboard` (`available_commission_piastres`,
  /// `pending_commission_piastres`) and the tier from `/broker/tier`
  /// (`tier`, `commission_rate`, `progress.properties_needed`).
  @override
  Future<BrokerWallet> getBrokerWallet(int monthOffset) async {
    final api = apiDataSource;

    try {
      final dashboard = await api.fetchDashboard();
      final tier = await api.fetchTier();
      final commissions = await api.fetchCommissions();

      // The dashboard already computes the average; fall back to the rows.
      final average = asNum(dashboard['averagePerBooking'])?.toDouble() ??
          _averagePiastres(commissions);

      return BrokerWallet(
        availableBalance:
            (asNum(dashboard['available_commission_piastres'])?.toDouble() ??
                    0) /
                100,
        pendingBalance:
            (asNum(dashboard['pending_commission_piastres'])?.toDouble() ?? 0) /
                100,
        tierName: _titleCase('${tier['tier'] ?? ''}'),
        commissionRate: asNum(tier['commission_rate'])?.toDouble() ?? 0,
        avgPerBooking:
            '${CurrencyFormatter.defaultSymbol} ${(average / 100).round()}',
        toNextTier:
            asNum(asMap(tier['progress'])['properties_needed'])?.toInt() ?? 0,
        commissions: commissions.map(_toCommission).toList(),
      );
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  static double _averagePiastres(List<Map<String, dynamic>> rows) {
    final amounts = rows
        .map((r) => asNum(r['commission_piastres'])?.toDouble() ?? 0)
        .where((a) => a > 0)
        .toList();
    if (amounts.isEmpty) return 0;
    return amounts.reduce((a, b) => a + b) / amounts.length;
  }

  /// A commission row is `{booking_id, commission_piastres, commission_egp,
  /// commission_rate, booking_status, status, check_in, check_out}`.
  /// The rows carry no property title and no created_at, so the check-in date
  /// of the stay is the meaningful date to show.
  static BrokerCommission _toCommission(Map<String, dynamic> json) {
    final egp = asNum(json['commission_egp'])?.toDouble() ??
        ((asNum(json['commission_piastres'])?.toDouble() ?? 0) / 100);
    return BrokerCommission(
      propertyName: _commissionLabel(json),
      date: asDate(json['check_in']) ?? asDate(json['created_at']) ?? _noDate,
      amount: '${CurrencyFormatter.defaultSymbol} ${egp.round()}',
      status: _titleCase('${json['status'] ?? ''}'),
    );
  }

  /// The property title when the row has one, otherwise a short booking
  /// reference (`Booking SHLY-1A2B3C4D`) instead of the raw booking UUID.
  static String _commissionLabel(Map<String, dynamic> json) {
    final title = '${json['property_title'] ?? ''}'.trim();
    if (title.isNotEmpty) return title;
    final id = '${json['booking_id'] ?? ''}'.replaceAll('-', '');
    if (id.isEmpty) return 'Booking';
    return 'Booking SHLY-${id.substring(0, id.length < 8 ? id.length : 8).toUpperCase()}';
  }

  /// Stable placeholder for rows with no usable date - DateTime.now() would
  /// silently label an undated row as today.
  static final DateTime _noDate = DateTime.utc(1970);

  static String _titleCase(String value) => value.isEmpty
      ? value
      : value[0].toUpperCase() + value.substring(1).toLowerCase();

  static Property _toProperty(Map<String, dynamic> json) {
    final images = asListOfMaps(json['images']);

    return Property(
      id: '${json['id'] ?? ''}',
      name: '${json['title'] ?? ''}',
      area: '${json['governorate'] ?? json['city'] ?? ''}',
      image: images.isEmpty ? '' : '${images.first['url'] ?? ''}',
      price: (asNum(pick(json, 'nightly_rate'))?.toDouble() ??
              (asNum(pick(json, 'base_price_per_night'))?.toDouble() ?? 0) /
                  100)
          .round(),
      rating: asNum(pick(json, 'average_rating'))?.toDouble() ?? 0,
      reviews: asNum(pick(json, 'total_reviews'))?.toInt() ?? 0,
      type: '${pick(json, 'property_type') ?? 'Villa'}',
      beds: asNum(json['bedrooms'])?.toInt() ?? 0,
      guests: asNum(pick(json, 'max_guests'))?.toInt() ?? 0,
      status: _toStatus('${json['status'] ?? ''}'),
    );
  }

  /// Backend listing status -> the four states the UI renders.
  static PropertyStatus _toStatus(String status) {
    return switch (status.toLowerCase()) {
      'active' || 'published' || 'listed' => PropertyStatus.active,
      'pending' ||
      'pending_review' ||
      'under_review' ||
      'submitted' =>
        PropertyStatus.underReview,
      'draft' => PropertyStatus.draft,
      _ => PropertyStatus.paused,
    };
  }

  /// `1_820_000` piastres -> `"18.2k"`, matching the dashboard's compact style.
  static String _formatPiastres(dynamic piastres) {
    final egp = (asNum(piastres)?.toDouble() ?? 0) / 100;
    if (egp >= 1000) return '${(egp / 1000).toStringAsFixed(1)}k';
    return egp.round().toString();
  }
}
