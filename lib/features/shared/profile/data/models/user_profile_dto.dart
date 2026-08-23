import 'package:equatable/equatable.dart';
import '../../domain/models/user_profile.dart';

class UserProfileDto extends Equatable {
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

  const UserProfileDto({
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

  factory UserProfileDto.fromJson(Map<String, dynamic> json) {
    return UserProfileDto(
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      bio: json['bio'] as String,
      instagram: json['instagram'] as String?,
      tiktok: json['tiktok'] as String?,
      facebook: json['facebook'] as String?,
      avatarPath: json['avatar_path'] as String?,
      reviewsGiven: json['reviews_given'] as int,
      reviewsReceived: json['reviews_received'] as int,
      stars: json['stars'] as int,
      referralCode: json['referral_code'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'bio': bio,
      'instagram': instagram,
      'tiktok': tiktok,
      'facebook': facebook,
      'avatar_path': avatarPath,
      'reviews_given': reviewsGiven,
      'reviews_received': reviewsReceived,
      'stars': stars,
      'referral_code': referralCode,
    };
  }

  UserProfile toEntity() {
    return UserProfile(
      name: name,
      email: email,
      phone: phone,
      bio: bio,
      instagram: instagram,
      tiktok: tiktok,
      facebook: facebook,
      avatarPath: avatarPath,
      reviewsGiven: reviewsGiven,
      reviewsReceived: reviewsReceived,
      stars: stars,
      referralCode: referralCode,
    );
  }

  factory UserProfileDto.fromEntity(UserProfile entity) {
    return UserProfileDto(
      name: entity.name,
      email: entity.email,
      phone: entity.phone,
      bio: entity.bio,
      instagram: entity.instagram,
      tiktok: entity.tiktok,
      facebook: entity.facebook,
      avatarPath: entity.avatarPath,
      reviewsGiven: entity.reviewsGiven,
      reviewsReceived: entity.reviewsReceived,
      stars: entity.stars,
      referralCode: entity.referralCode,
    );
  }

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
