import 'package:sahely/core/errors/exception_mapper.dart';
import '../../domain/models/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';
import '../models/user_profile_dto.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserProfile> getProfile() async {
    try {
      final dto = await remoteDataSource.getProfile();
      return dto.toEntity();
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  @override
  Future<void> updateProfile(UserProfile profile) async {
    try {
      await remoteDataSource.updateProfile(UserProfileDto.fromEntity(profile));
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  @override
  Future<String> uploadProfileImage(String path) async {
    try {
      return await remoteDataSource.uploadProfileImage(path);
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  @override
  Future<void> deleteProfileImage() async {
    try {
      await remoteDataSource.deleteProfileImage();
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  @override
  Future<void> changePassword(String currentPassword, String newPassword) async {
    try {
      await remoteDataSource.changePassword(currentPassword, newPassword);
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  @override
  Future<void> updateLanguage(String languageCode) async {
    try {
      await remoteDataSource.updateLanguage(languageCode);
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  @override
  Future<void> updateCurrency(String currencyCode) async {
    try {
      await remoteDataSource.updateCurrency(currencyCode);
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      await remoteDataSource.deleteAccount();
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }
}
