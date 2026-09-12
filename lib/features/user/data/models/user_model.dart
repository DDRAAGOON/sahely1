import 'package:sahely/core/network/api_envelope.dart';
import '../../domain/entities/user_entity.dart';
import 'package:sahely/data/models.dart';

/// User model from API response
class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final Role role;
  final String? avatar;
  final String? bio;
  final String? instagram;
  final String? tiktok;
  final String? facebook;
  final bool emailVerified;
  final bool phoneVerified;
  final String? referralCode;
  final int reviewsGiven;
  final int reviewsReceived;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? preferredLanguage;
  final String? preferredCurrency;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    this.avatar,
    this.bio,
    this.instagram,
    this.tiktok,
    this.facebook,
    required this.emailVerified,
    required this.phoneVerified,
    this.referralCode,
    required this.reviewsGiven,
    required this.reviewsReceived,
    this.createdAt,
    this.updatedAt,
    this.preferredLanguage,
    this.preferredCurrency,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      fullName: pick(json, 'full_name') ?? json['fullName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      role: _parseRole(json['role']),
      avatar: json['avatar'],
      bio: json['bio'],
      instagram: json['instagram'],
      tiktok: json['tiktok'],
      facebook: json['facebook'],
      emailVerified:
          pick(json, 'email_verified') ?? json['emailVerified'] ?? false,
      phoneVerified:
          pick(json, 'phone_verified') ?? json['phoneVerified'] ?? false,
      referralCode: pick(json, 'referral_code') ?? json['referralCode'],
      reviewsGiven: pick(json, 'reviews_given') as int? ?? 0,
      reviewsReceived: pick(json, 'reviews_received') as int? ?? 0,
      createdAt: pick(json, 'created_at') != null
          ? DateTime.tryParse(pick(json, 'created_at'))
          : null,
      updatedAt: pick(json, 'updated_at') != null
          ? DateTime.tryParse(pick(json, 'updated_at'))
          : null,
      preferredLanguage:
          pick(json, 'preferred_language') ?? json['preferredLanguage'],
      preferredCurrency:
          pick(json, 'preferred_currency') ?? json['preferredCurrency'],
    );
  }

  static Role _parseRole(dynamic role) {
    if (role == null) return Role.renter;
    final roleStr = role.toString().toLowerCase();
    return switch (roleStr) {
      'owner' => Role.owner,
      'broker' => Role.broker,
      _ => Role.renter,
    };
  }

  /// Convert to domain entity
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      fullName: fullName,
      email: email,
      phone: phone,
      role: role,
      avatar: avatar,
      bio: bio,
      instagram: instagram,
      tiktok: tiktok,
      facebook: facebook,
      emailVerified: emailVerified,
      phoneVerified: phoneVerified,
      referralCode: referralCode,
      reviewsGiven: reviewsGiven,
      reviewsReceived: reviewsReceived,
      createdAt: createdAt,
      updatedAt: updatedAt,
      preferredLanguage: preferredLanguage,
      preferredCurrency: preferredCurrency,
    );
  }

  /// Convert to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'phone': phone,
      'bio': bio,
      'instagram': instagram,
      'tiktok': tiktok,
      'facebook': facebook,
      'preferred_language': preferredLanguage,
      'preferred_currency': preferredCurrency,
    };
  }
}
