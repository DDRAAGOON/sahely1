import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/broker_dashboard.dart';

class BrokerDashboardDto extends Equatable {
  final String name;
  final String role;
  final String level;
  final int levelIconCode;
  final int currentStars;
  final int starsToNextLevel;
  final String nextLevelName;
  final String thisMonthEarnings;
  final int liveProps;
  final int needHelp;
  final List<Map<String, dynamic>> upcomingCheckins;
  final List<Map<String, dynamic>> trendingProperties;

  const BrokerDashboardDto({
    required this.name,
    required this.role,
    required this.level,
    required this.levelIconCode,
    required this.currentStars,
    required this.starsToNextLevel,
    required this.nextLevelName,
    required this.thisMonthEarnings,
    required this.liveProps,
    required this.needHelp,
    required this.upcomingCheckins,
    required this.trendingProperties,
  });

  factory BrokerDashboardDto.fromJson(Map<String, dynamic> json) {
    return BrokerDashboardDto(
      name: json['name'] as String,
      role: json['role'] as String,
      level: json['level'] as String,
      levelIconCode: json['levelIconCode'] as int,
      currentStars: json['currentStars'] as int,
      starsToNextLevel: json['starsToNextLevel'] as int,
      nextLevelName: json['nextLevelName'] as String,
      thisMonthEarnings: json['thisMonthEarnings'] as String,
      liveProps: json['liveProps'] as int,
      needHelp: json['needHelp'] as int,
      upcomingCheckins: List<Map<String, dynamic>>.from(json['upcomingCheckins'] as List),
      trendingProperties: List<Map<String, dynamic>>.from(json['trendingProperties'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'role': role,
      'level': level,
      'levelIconCode': levelIconCode,
      'currentStars': currentStars,
      'starsToNextLevel': starsToNextLevel,
      'nextLevelName': nextLevelName,
      'thisMonthEarnings': thisMonthEarnings,
      'liveProps': liveProps,
      'needHelp': needHelp,
      'upcomingCheckins': upcomingCheckins,
      'trendingProperties': trendingProperties,
    };
  }

  BrokerDashboard toEntity() {
    return BrokerDashboard(
      name: name,
      role: role,
      level: level,
      levelIcon: IconData(levelIconCode, fontFamily: 'MaterialIcons'),
      currentStars: currentStars,
      starsToNextLevel: starsToNextLevel,
      nextLevelName: nextLevelName,
      thisMonthEarnings: thisMonthEarnings,
      liveProps: liveProps,
      needHelp: needHelp,
      upcomingCheckins: upcomingCheckins,
      trendingProperties: trendingProperties,
    );
  }

  factory BrokerDashboardDto.fromEntity(BrokerDashboard entity) {
    return BrokerDashboardDto(
      name: entity.name,
      role: entity.role,
      level: entity.level,
      levelIconCode: entity.levelIcon.codePoint,
      currentStars: entity.currentStars,
      starsToNextLevel: entity.starsToNextLevel,
      nextLevelName: entity.nextLevelName,
      thisMonthEarnings: entity.thisMonthEarnings,
      liveProps: entity.liveProps,
      needHelp: entity.needHelp,
      upcomingCheckins: entity.upcomingCheckins,
      trendingProperties: entity.trendingProperties,
    );
  }

  @override
  List<Object?> get props => [
        name,
        role,
        level,
        levelIconCode,
        currentStars,
        starsToNextLevel,
        nextLevelName,
        thisMonthEarnings,
        liveProps,
        needHelp,
        upcomingCheckins,
        trendingProperties,
      ];
}
