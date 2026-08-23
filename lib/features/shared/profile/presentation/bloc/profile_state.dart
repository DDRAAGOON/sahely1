import 'package:equatable/equatable.dart';
import '../../domain/models/user_profile.dart';

enum ProfileStatus { initial, loading, loaded, success, error }

class ProfileState extends Equatable {
  final UserProfile? profile;
  final ProfileStatus status;
  final String? errorMessage;
  final String? successMessage;

  const ProfileState({
    this.profile,
    this.status = ProfileStatus.initial,
    this.errorMessage,
    this.successMessage,
  });

  ProfileState copyWith({
    UserProfile? profile,
    ProfileStatus? status,
    String? errorMessage,
    String? successMessage,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      status: status ?? this.status,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [profile, status, errorMessage, successMessage];
}
