import 'package:flutter/material.dart';

class BrokerDashboard {
  final String name;
  final String role;
  final String level;
  final IconData levelIcon;
  final int currentStars;
  final int starsToNextLevel;
  final String nextLevelName;
  final String thisMonthEarnings;

  /// Commission earned since joining, compact (`312k`).
  final String totalEarnings;

  /// Commission not yet released, compact.
  final String pendingEarnings;

  /// Share of each booking the broker earns, e.g. `0.02`.
  final double commissionRate;
  final int liveProps;
  final int needHelp;
  final List<Map<String, dynamic>> upcomingCheckins;
  final List<Map<String, dynamic>> trendingProperties;

  const BrokerDashboard({
    required this.name,
    required this.role,
    required this.level,
    required this.levelIcon,
    required this.currentStars,
    required this.starsToNextLevel,
    required this.nextLevelName,
    required this.thisMonthEarnings,
    this.totalEarnings = '',
    this.pendingEarnings = '',
    this.commissionRate = 0,
    required this.liveProps,
    required this.needHelp,
    required this.upcomingCheckins,
    required this.trendingProperties,
  });
}
