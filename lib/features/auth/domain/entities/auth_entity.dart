import 'package:equatable/equatable.dart';
import 'package:sahely/data/models.dart';

/// Authentication entity representing the authenticated user state
class AuthEntity extends Equatable {
  final String accessToken;
  final String refreshToken;
  final UserEntity user;

  const AuthEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  @override
  List<Object?> get props => [accessToken, refreshToken, user];
}

/// User entity representing user information
class UserEntity extends Equatable {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final Role role;
  final String? avatar;
  final bool emailVerified;
  final bool phoneVerified;
  final DateTime? createdAt;

  const UserEntity({
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

  @override
  List<Object?> get props => [
        id,
        fullName,
        email,
        phone,
        role,
        avatar,
        emailVerified,
        phoneVerified,
        createdAt,
      ];
}
