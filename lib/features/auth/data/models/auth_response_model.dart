import 'package:sahely/core/network/api_envelope.dart';
import 'package:sahely/data/models.dart';
import '../../domain/entities/auth_entity.dart';

/// Response model for authentication API calls
class AuthResponseModel {
  final String accessToken;
  final String refreshToken;
  final UserModel user;

  AuthResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      accessToken: pick(json, 'access_token') ?? json['accessToken'] ?? '',
      refreshToken: pick(json, 'refresh_token') ?? json['refreshToken'] ?? '',
      user: UserModel.fromJson(json['user'] ?? {}),
    );
  }

  /// Convert to domain entity
  AuthEntity toEntity() {
    return AuthEntity(
      accessToken: accessToken,
      refreshToken: refreshToken,
      user: user.toEntity(),
    );
  }
}

/// Response model for registration step 1
class RegisterStep1ResponseModel {
  final String sessionId;

  RegisterStep1ResponseModel({required this.sessionId});

  factory RegisterStep1ResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterStep1ResponseModel(
      sessionId: pick(json, 'session_id') ?? json['sessionId'] ?? '',
    );
  }
}

/// Response model for registration step 4 - phone OTP send
class RegisterStep4ResponseModel {
  final String testHint;

  RegisterStep4ResponseModel({required this.testHint});

  factory RegisterStep4ResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterStep4ResponseModel(
      testHint: pick(json, 'test_hint') ?? '',
    );
  }
}

/// User model from API response
class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final Role role;
  final String? avatar;
  final bool emailVerified;
  final bool phoneVerified;
  final DateTime? createdAt;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    this.avatar,
    required this.emailVerified,
    required this.phoneVerified,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      fullName: _fullName(json),
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      role: _parseRole(json['role']),
      avatar: json['avatar'] ?? pick(json, 'avatar_url') ?? json['avatarUrl'],
      emailVerified:
          pick(json, 'email_verified') ?? json['emailVerified'] ?? false,
      phoneVerified:
          pick(json, 'phone_verified') ?? json['phoneVerified'] ?? false,
      createdAt: pick(json, 'created_at') != null
          ? DateTime.tryParse(pick(json, 'created_at'))
          : null,
    );
  }

  /// The API stores first/last separately (`UpdateUserProfileDto`); older
  /// payloads used a single `full_name`. Both are accepted.
  static String _fullName(Map<String, dynamic> json) {
    final combined = pick(json, 'full_name') ?? json['fullName'];
    if (combined is String && combined.trim().isNotEmpty) {
      return combined.trim();
    }
    return [pick(json, 'first_name'), pick(json, 'last_name')]
        .whereType<String>()
        .join(' ')
        .trim();
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
      emailVerified: emailVerified,
      phoneVerified: phoneVerified,
      createdAt: createdAt,
    );
  }
}
