import 'package:sahely/core/network/api_envelope.dart';
import '../../domain/entities/mawsem_entity.dart';

/// MAWSEM model from API response
class MawsemModel {
  final String userId;
  final MawsemLevel currentLevel;
  final int stars;
  final int starsToNextLevel;
  final int totalBookings;
  final int totalSpent;
  final List<MawsemPerkModel> availablePerks;
  final List<MawsemHistoryModel> history;
  final DateTime? levelUpDate;
  final DateTime createdAt;
  final DateTime? updatedAt;

  MawsemModel({
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

  factory MawsemModel.fromJson(Map<String, dynamic> json) {
    return MawsemModel(
      userId: pick(json, 'user_id')?.toString() ?? '',
      currentLevel: _parseLevel(pick(json, 'current_level')),
      stars: json['stars'] as int? ?? 0,
      starsToNextLevel: pick(json, 'stars_to_next_level') as int? ?? 0,
      totalBookings: pick(json, 'total_bookings') as int? ?? 0,
      totalSpent: pick(json, 'total_spent') as int? ?? 0,
      availablePerks: (pick(json, 'available_perks') as List<dynamic>?)
              ?.map((e) => MawsemPerkModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      history: (json['history'] as List<dynamic>?)
              ?.map(
                  (e) => MawsemHistoryModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      levelUpDate: pick(json, 'level_up_date') != null
          ? DateTime.tryParse(pick(json, 'level_up_date'))
          : null,
      createdAt: pick(json, 'created_at') != null
          ? DateTime.tryParse(pick(json, 'created_at')) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: pick(json, 'updated_at') != null
          ? DateTime.tryParse(pick(json, 'updated_at'))
          : null,
    );
  }

  static MawsemLevel _parseLevel(dynamic level) {
    if (level == null) return MawsemLevel.bronze;
    final levelStr = level.toString().toLowerCase();
    return switch (levelStr) {
      'bronze' => MawsemLevel.bronze,
      'silver' => MawsemLevel.silver,
      'gold' => MawsemLevel.gold,
      'platinum' => MawsemLevel.platinum,
      'diamond' => MawsemLevel.diamond,
      _ => MawsemLevel.bronze,
    };
  }

  MawsemEntity toEntity() {
    return MawsemEntity(
      userId: userId,
      currentLevel: currentLevel,
      stars: stars,
      starsToNextLevel: starsToNextLevel,
      totalBookings: totalBookings,
      totalSpent: totalSpent,
      availablePerks: availablePerks.map((e) => e.toEntity()).toList(),
      history: history.map((e) => e.toEntity()).toList(),
      levelUpDate: levelUpDate,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

/// MAWSEM perk model
class MawsemPerkModel {
  final String id;
  final String name;
  final String description;
  final MawsemLevel requiredLevel;
  final PerkType type;
  final String? value;
  final bool isActive;
  final bool isRedeemed;
  final DateTime? redeemedAt;
  final DateTime? expiresAt;

  MawsemPerkModel({
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

  factory MawsemPerkModel.fromJson(Map<String, dynamic> json) {
    return MawsemPerkModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      requiredLevel: MawsemModel._parseLevel(pick(json, 'required_level')),
      type: _parsePerkType(json['type']),
      value: json['value']?.toString(),
      isActive: pick(json, 'is_active') as bool? ?? false,
      isRedeemed: pick(json, 'is_redeemed') as bool? ?? false,
      redeemedAt: pick(json, 'redeemed_at') != null
          ? DateTime.tryParse(pick(json, 'redeemed_at'))
          : null,
      expiresAt: pick(json, 'expires_at') != null
          ? DateTime.tryParse(pick(json, 'expires_at'))
          : null,
    );
  }

  static PerkType _parsePerkType(dynamic type) {
    if (type == null) return PerkType.discount;
    final typeStr = type.toString().toLowerCase();
    return switch (typeStr) {
      'discount' => PerkType.discount,
      'free_cancellation' => PerkType.freeCancellation,
      'late_checkout' => PerkType.lateCheckout,
      'early_checkin' => PerkType.earlyCheckin,
      'priority_support' => PerkType.prioritySupport,
      'exclusive_access' => PerkType.exclusiveAccess,
      _ => PerkType.discount,
    };
  }

  MawsemPerkEntity toEntity() {
    return MawsemPerkEntity(
      id: id,
      name: name,
      description: description,
      requiredLevel: requiredLevel,
      type: type,
      value: value,
      isActive: isActive,
      isRedeemed: isRedeemed,
      redeemedAt: redeemedAt,
      expiresAt: expiresAt,
    );
  }
}

/// MAWSEM history model
class MawsemHistoryModel {
  final String id;
  final String userId;
  final HistoryType type;
  final int stars;
  final String? description;
  final String? referenceId;
  final DateTime createdAt;

  MawsemHistoryModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.stars,
    this.description,
    this.referenceId,
    required this.createdAt,
  });

  factory MawsemHistoryModel.fromJson(Map<String, dynamic> json) {
    return MawsemHistoryModel(
      id: json['id']?.toString() ?? '',
      userId: pick(json, 'user_id')?.toString() ?? '',
      type: _parseHistoryType(json['type']),
      stars: json['stars'] as int? ?? 0,
      description: json['description'],
      referenceId: pick(json, 'reference_id')?.toString(),
      createdAt: pick(json, 'created_at') != null
          ? DateTime.tryParse(pick(json, 'created_at')) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  static HistoryType _parseHistoryType(dynamic type) {
    if (type == null) return HistoryType.bookingCompleted;
    final typeStr = type.toString().toLowerCase();
    return switch (typeStr) {
      'booking_completed' => HistoryType.bookingCompleted,
      'referral' => HistoryType.referral,
      'bonus' => HistoryType.bonus,
      'level_up' => HistoryType.levelUp,
      'redeemed' => HistoryType.redeemed,
      'penalty' => HistoryType.penalty,
      _ => HistoryType.bookingCompleted,
    };
  }

  MawsemHistoryEntity toEntity() {
    return MawsemHistoryEntity(
      id: id,
      userId: userId,
      type: type,
      stars: stars,
      description: description,
      referenceId: referenceId,
      createdAt: createdAt,
    );
  }
}
