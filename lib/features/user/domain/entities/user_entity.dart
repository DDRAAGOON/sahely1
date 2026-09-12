import 'package:equatable/equatable.dart';
import 'package:sahely/data/models.dart';

/// User entity representing user profile information
class UserEntity extends Equatable {
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

  const UserEntity({
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

  @override
  List<Object?> get props => [
        id,
        fullName,
        email,
        phone,
        role,
        avatar,
        bio,
        instagram,
        tiktok,
        facebook,
        emailVerified,
        phoneVerified,
        referralCode,
        reviewsGiven,
        reviewsReceived,
        createdAt,
        updatedAt,
        preferredLanguage,
        preferredCurrency,
      ];
}

/// User update request entity
class UserUpdateRequestEntity extends Equatable {
  final String? fullName;
  final String? phone;
  final String? bio;
  final String? instagram;
  final String? tiktok;
  final String? facebook;
  final String? preferredLanguage;
  final String? preferredCurrency;

  const UserUpdateRequestEntity({
    this.fullName,
    this.phone,
    this.bio,
    this.instagram,
    this.tiktok,
    this.facebook,
    this.preferredLanguage,
    this.preferredCurrency,
  });

  @override
  List<Object?> get props => [
        fullName,
        phone,
        bio,
        instagram,
        tiktok,
        facebook,
        preferredLanguage,
        preferredCurrency,
      ];
}
