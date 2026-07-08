import 'package:dartz/dart_z.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/network_info.dart';
import '../models/user_profile_model.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ApiClient apiClient;
  final NetworkInfo networkInfo;

  ProfileRepositoryImpl({required this.apiClient, required this.networkInfo});

  @override
  Future<Either<Failure, UserProfile>> getProfile(String userId) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await apiClient.get('profile/$userId');
        return Right(UserProfileModel.fromJson(response.data['profile']));
      } catch (e) {
        return const Left(ServerFailure('Failed to load profile'));
      }
    }
    return const Left(NetworkFailure('No internet connection'));
  }

  @override
  Future<Either<Failure, UserProfile>> updateProfile(UserProfile profile) async {
    if (await networkInfo.isConnected) {
      try {
        final model = UserProfileModel(
          id: profile.id,
          name: profile.name,
          email: profile.email,
          role: profile.role,
          phoneNumber: profile.phoneNumber,
          avatarUrl: profile.avatarUrl,
        );
        final response = await apiClient.put('profile/update', data: model.toJson());
        return Right(UserProfileModel.fromJson(response.data['profile']));
      } catch (e) {
        return const Left(ServerFailure('Failed to update profile'));
      }
    }
    return const Left(NetworkFailure('No internet connection'));
  }

  @override
  Future<Either<Failure, String>> uploadAvatar(String filePath) async {
    // Logic for multipart file upload
    return const Right('https://via.placeholder.com/150');
  }
}
