import '../../domain/entities/user.dart';

/// User Model that adds JSON serialization logic to the User entity.
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
    required super.role,
    super.profileImage,
    super.phoneNumber,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      role: _parseRole(json['role']),
      profileImage: json['profile_image'],
      phoneNumber: json['phone_number'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role.name,
      'profile_image': profileImage,
      'phone_number': phoneNumber,
    };
  }

  static UserRole _parseRole(String? role) {
    switch (role?.toLowerCase()) {
      case 'owner':
        return UserRole.owner;
      case 'broker':
        return UserRole.broker;
      case 'renter':
      default:
        return UserRole.renter;
    }
  }
}
