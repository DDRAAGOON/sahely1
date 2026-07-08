import 'package:equatable/equatable.dart';

/// App-level roles for Sahely users.
enum UserRole { renter, owner, broker }

/// Base User entity for all roles in the application.
class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final UserRole role;
  final String? profileImage;
  final String? phoneNumber;

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.profileImage,
    this.phoneNumber,
  });

  @override
  List<Object?> get props => [id, email, name, role, profileImage, phoneNumber];
}
