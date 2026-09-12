import 'package:equatable/equatable.dart';

/// MAWSEM entity representing user's loyalty program status
class MawsemEntity extends Equatable {
  final String userId;
  final MawsemLevel currentLevel;
  final int stars; // total stars earned
  final int starsToNextLevel; // stars needed for next level
  final int totalBookings;
  final int totalSpent; // in piastres (divide by 100 for display)
  final List<MawsemPerkEntity> availablePerks;
  final List<MawsemHistoryEntity> history;
  final DateTime? levelUpDate;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const MawsemEntity({
    required this.userId,
    required this.currentLevel,
    required this.stars,
    required this.starsToNextLevel,
    required this.totalBookings,
    required this.totalSpent,
    required this.availablePerks,
    required this.history,
    this.levelUpDate,
    required this.createdAt,
    this.updatedAt,
  });

  /// Get total spent in EGP (divide piastres by 100)
  double get totalSpentInEgp => totalSpent / 100;

  /// Calculate progress to next level (0.0 to 1.0)
  double get progressToNextLevel {
    if (starsToNextLevel == 0) return 1.0;
    final previousLevelStars = currentLevel.requiredStars;
    final currentProgress = stars - previousLevelStars;
    final needed = starsToNextLevel - previousLevelStars;
    return (currentProgress / needed).clamp(0.0, 1.0);
  }

  @override
  List<Object?> get props => [
        userId,
        currentLevel,
        stars,
        starsToNextLevel,
        totalBookings,
        totalSpent,
        availablePerks,
        history,
        levelUpDate,
        createdAt,
        updatedAt,
      ];
}

/// MAWSEM level enum
enum MawsemLevel {
  bronze,
  silver,
  gold,
  platinum,
  diamond,
}

extension MawsemLevelX on MawsemLevel {
  String get displayName => switch (this) {
        MawsemLevel.bronze => 'Bronze',
        MawsemLevel.silver => 'Silver',
        MawsemLevel.gold => 'Gold',
        MawsemLevel.platinum => 'Platinum',
        MawsemLevel.diamond => 'Diamond',
      };

  int get requiredStars => switch (this) {
        MawsemLevel.bronze => 0,
        MawsemLevel.silver => 100,
        MawsemLevel.gold => 500,
        MawsemLevel.platinum => 1500,
        MawsemLevel.diamond => 5000,
      };

  double get discountRate => switch (this) {
        MawsemLevel.bronze => 0.0,
        MawsemLevel.silver => 0.05, // 5%
        MawsemLevel.gold => 0.10, // 10%
        MawsemLevel.platinum => 0.15, // 15%
        MawsemLevel.diamond => 0.20, // 20%
      };
}

/// MAWSEM perk entity
class MawsemPerkEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final MawsemLevel requiredLevel;
  final PerkType type;
  final String? value; // percentage, fixed amount, etc.
  final bool isActive;
  final bool isRedeemed;
  final DateTime? redeemedAt;
  final DateTime? expiresAt;

  const MawsemPerkEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.requiredLevel,
    required this.type,
    this.value,
    required this.isActive,
    required this.isRedeemed,
    this.redeemedAt,
    this.expiresAt,
  });

  bool get canRedeem =>
      isActive &&
      !isRedeemed &&
      (expiresAt == null || expiresAt!.isAfter(DateTime.now()));

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        requiredLevel,
        type,
        value,
        isActive,
        isRedeemed,
        redeemedAt,
        expiresAt,
      ];
}

/// Perk type enum
enum PerkType {
  discount,
  freeCancellation,
  lateCheckout,
  earlyCheckin,
  prioritySupport,
  exclusiveAccess,
}

extension PerkTypeX on PerkType {
  String get displayName => switch (this) {
        PerkType.discount => 'Discount',
        PerkType.freeCancellation => 'Free Cancellation',
        PerkType.lateCheckout => 'Late Checkout',
        PerkType.earlyCheckin => 'Early Check-in',
        PerkType.prioritySupport => 'Priority Support',
        PerkType.exclusiveAccess => 'Exclusive Access',
      };
}

/// MAWSEM history entity
class MawsemHistoryEntity extends Equatable {
  final String id;
  final String userId;
  final HistoryType type;
  final int stars; // stars earned or lost
  final String? description;
  final String? referenceId; // booking ID, etc.
  final DateTime createdAt;

  const MawsemHistoryEntity({
    required this.id,
    required this.userId,
    required this.type,
    required this.stars,
    this.description,
    this.referenceId,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        type,
        stars,
        description,
        referenceId,
        createdAt,
      ];
}

/// History type enum
enum HistoryType {
  bookingCompleted,
  referral,
  bonus,
  levelUp,
  redeemed,
  penalty,
}

extension HistoryTypeX on HistoryType {
  String get displayName => switch (this) {
        HistoryType.bookingCompleted => 'Booking Completed',
        HistoryType.referral => 'Referral',
        HistoryType.bonus => 'Bonus',
        HistoryType.levelUp => 'Level Up',
        HistoryType.redeemed => 'Redeemed',
        HistoryType.penalty => 'Penalty',
      };
}

/// MAWSEM level information
class MawsemLevelInfo {
  final MawsemLevel level;
  final int requiredStars;
  final double discountRate;
  final List<String> benefits;

  const MawsemLevelInfo({
    required this.level,
    required this.requiredStars,
    required this.discountRate,
    required this.benefits,
  });
}

/// Leaderboard entry
class LeaderboardEntry {
  final String userId;
  final String userName;
  final String? userAvatar;
  final int stars;
  final MawsemLevel level;
  final int rank;

  const LeaderboardEntry({
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.stars,
    required this.level,
    required this.rank,
  });
}
