import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahely/core/errors/failures.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import '../../domain/usecases/upload_profile_image_usecase.dart';
import '../../domain/usecases/delete_profile_image_usecase.dart';
import '../../domain/usecases/change_password_usecase.dart';
import '../../domain/usecases/update_language_usecase.dart';
import '../../domain/usecases/update_currency_usecase.dart';
import '../../domain/usecases/delete_account_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final UploadProfileImageUseCase uploadProfileImageUseCase;
  final DeleteProfileImageUseCase deleteProfileImageUseCase;
  final ChangePasswordUseCase changePasswordUseCase;
  final UpdateLanguageUseCase updateLanguageUseCase;
  final UpdateCurrencyUseCase updateCurrencyUseCase;
  final DeleteAccountUseCase deleteAccountUseCase;
  final LogoutUseCase logoutUseCase;

  ProfileCubit({
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
    required this.uploadProfileImageUseCase,
    required this.deleteProfileImageUseCase,
    required this.changePasswordUseCase,
    required this.updateLanguageUseCase,
    required this.updateCurrencyUseCase,
    required this.deleteAccountUseCase,
    required this.logoutUseCase,
  }) : super(const ProfileState());

  Future<void> fetchProfile() async {
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      final profile = await getProfileUseCase.execute();
      emit(state.copyWith(status: ProfileStatus.loaded, profile: profile));
    } catch (e) {
      final message = e is Failure ? e.message : e.toString();
      emit(state.copyWith(status: ProfileStatus.error, errorMessage: message));
    }
  }

  Future<void> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? bio,
    String? instagram,
    String? tiktok,
    String? facebook,
  }) async {
    if (state.profile == null) return;

    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      final updatedProfile = state.profile!.copyWith(
        name: name,
        email: email,
        phone: phone,
        bio: bio,
        instagram: instagram,
        tiktok: tiktok,
        facebook: facebook,
      );
      await updateProfileUseCase.execute(updatedProfile);
      emit(state.copyWith(
        status: ProfileStatus.success,
        profile: updatedProfile,
        successMessage: 'Profile updated successfully',
      ));
    } catch (e) {
      final message = e is Failure ? e.message : e.toString();
      emit(state.copyWith(status: ProfileStatus.error, errorMessage: message));
    }
  }

  Future<void> uploadAvatar(String path) async {
    if (state.profile == null) return;

    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      final newAvatarUrl = await uploadProfileImageUseCase.execute(path);
      final updatedProfile = state.profile!.copyWith(avatarPath: newAvatarUrl);
      emit(state.copyWith(
        status: ProfileStatus.success,
        profile: updatedProfile,
        successMessage: 'Avatar uploaded successfully',
      ));
    } catch (e) {
      final message = e is Failure ? e.message : e.toString();
      emit(state.copyWith(status: ProfileStatus.error, errorMessage: message));
    }
  }

  Future<void> deleteAvatar() async {
    if (state.profile == null) return;

    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      await deleteProfileImageUseCase.execute();
      final updatedProfile = state.profile!.copyWith(avatarPath: null);
      emit(state.copyWith(
        status: ProfileStatus.success,
        profile: updatedProfile,
        successMessage: 'Avatar deleted successfully',
      ));
    } catch (e) {
      final message = e is Failure ? e.message : e.toString();
      emit(state.copyWith(status: ProfileStatus.error, errorMessage: message));
    }
  }

  Future<void> changePassword(String currentPassword, String newPassword) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      await changePasswordUseCase.execute(currentPassword, newPassword);
      emit(state.copyWith(
        status: ProfileStatus.success,
        successMessage: 'Password changed successfully',
      ));
    } catch (e) {
      final message = e is Failure ? e.message : e.toString();
      emit(state.copyWith(status: ProfileStatus.error, errorMessage: message));
    }
  }

  Future<void> updateLanguage(String languageCode) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      await updateLanguageUseCase.execute(languageCode);
      emit(state.copyWith(
        status: ProfileStatus.success,
        successMessage: 'Language updated successfully',
      ));
    } catch (e) {
      final message = e is Failure ? e.message : e.toString();
      emit(state.copyWith(status: ProfileStatus.error, errorMessage: message));
    }
  }

  Future<void> updateCurrency(String currencyCode) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      await updateCurrencyUseCase.execute(currencyCode);
      emit(state.copyWith(
        status: ProfileStatus.success,
        successMessage: 'Currency updated successfully',
      ));
    } catch (e) {
      final message = e is Failure ? e.message : e.toString();
      emit(state.copyWith(status: ProfileStatus.error, errorMessage: message));
    }
  }

  Future<void> deleteAccount() async {
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      await deleteAccountUseCase.execute();
      emit(state.copyWith(
        status: ProfileStatus.success,
        successMessage: 'Account deleted successfully',
      ));
    } catch (e) {
      final message = e is Failure ? e.message : e.toString();
      emit(state.copyWith(status: ProfileStatus.error, errorMessage: message));
    }
  }

  Future<void> logout() async {
    try {
      await logoutUseCase.execute();
    } catch (e) {
      final message = e is Failure ? e.message : e.toString();
      emit(state.copyWith(status: ProfileStatus.error, errorMessage: message));
    }
  }
}
