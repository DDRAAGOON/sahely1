import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class UserProfile extends Equatable {
  final String name;
  final String email;
  final String phone;
  final String bio;
  final String? instagram;
  final String? tiktok;
  final String? facebook;
  final String? avatarPath;
  final int reviewsGiven;
  final int reviewsReceived;
  final int stars;
  final String referralCode;

  const UserProfile({
    required this.name,
    required this.email,
    required this.phone,
    required this.bio,
    this.instagram,
    this.tiktok,
    this.facebook,
    this.avatarPath,
    required this.reviewsGiven,
    required this.reviewsReceived,
    required this.stars,
    required this.referralCode,
  });

  UserProfile copyWith({
    String? name,
    String? email,
    String? phone,
    String? bio,
    String? instagram,
    String? tiktok,
    String? facebook,
    String? avatarPath,
    int? reviewsGiven,
    int? reviewsReceived,
    int? stars,
    String? referralCode,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      bio: bio ?? this.bio,
      instagram: instagram ?? this.instagram,
      tiktok: tiktok ?? this.tiktok,
      facebook: facebook ?? this.facebook,
      avatarPath: avatarPath ?? this.avatarPath,
      reviewsGiven: reviewsGiven ?? this.reviewsGiven,
      reviewsReceived: reviewsReceived ?? this.reviewsReceived,
      stars: stars ?? this.stars,
      referralCode: referralCode ?? this.referralCode,
    );
  }

  // --- Domain Logic: Mawsem Levels ---

  int get currentLevel {
    for (int i = levelThresholds.length - 1; i >= 0; i--) {
      if (stars >= levelThresholds[i].stars) {
        return levelThresholds[i].level;
      }
    }
    return 1;
  }

  LevelData get levelData => levelThresholds[currentLevel - 1];

  LevelData? get nextLevelData {
    if (currentLevel < levelThresholds.length) {
      return levelThresholds[currentLevel];
    }
    return null;
  }

  int get starsToNextLevel {
    final next = nextLevelData;
    if (next == null) return 0;
    return (next.stars - stars).clamp(0, 9999);
  }

  double get levelProgress {
    final next = nextLevelData;
    if (next == null) return 1.0;
    if (next.stars == 0) return 1.0;
    return (stars / next.stars).clamp(0.0, 1.0);
  }

  static const List<LevelData> levelThresholds = [
    LevelData(
      level: 1,
      name: 'Coastal Regular',
      stars: 0,
      icon: Icons.directions_walk,
      color: Color(0xFF717171),
    ),
    LevelData(
      level: 2,
      name: 'Sand VIP',
      stars: 28,
      icon: Icons.explore,
      color: Color(0xFF2D9B9B),
    ),
    LevelData(
      level: 3,
      name: 'Wave Rider',
      stars: 47,
      icon: Icons.waves,
      color: Color(0xFF2D9B9B),
    ),
    LevelData(
      level: 4,
      name: 'Gold Elite',
      stars: 80,
      icon: Icons.anchor,
      color: Color(0xFFBC9B43),
    ),
    LevelData(
      level: 5,
      name: 'Platinum',
      stars: 150,
      icon: Icons.diamond,
      color: Color(0xFF6B4D8A),
    ),
  ];

  @override
  List<Object?> get props => [
        name,
        email,
        phone,
        bio,
        instagram,
        tiktok,
        facebook,
        avatarPath,
        reviewsGiven,
        reviewsReceived,
        stars,
        referralCode,
      ];
}

class LevelData extends Equatable {
  final int level;
  final String name;
  final int stars;
  final IconData icon;
  final Color color;

  const LevelData({
    required this.level,
    required this.name,
    required this.stars,
    required this.icon,
    required this.color,
  });

  @override
  List<Object?> get props => [level, name, stars, icon, color];
}
