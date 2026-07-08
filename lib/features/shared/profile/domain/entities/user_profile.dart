import 'package:equatable/equatable.dart';
import '../../../auth/domain/entities/user.dart';

class UserProfile extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? avatarUrl;
  final UserRole role;
  final DateTime? createdAt;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.avatarUrl,
    required this.role,
    this.createdAt,
  });

  UserProfile copyWith({
    String? name,
    String? phoneNumber,
    String? avatarUrl,
  }) {
    return UserProfile(
      id: id,
      name: name ?? this.name,
      email: email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role,
      createdAt: createdAt,
    );
  }

  @override
  List<Object?> get props => [id, name, email, phoneNumber, avatarUrl, role, createdAt];
}
