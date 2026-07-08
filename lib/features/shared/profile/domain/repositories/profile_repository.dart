import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/user_profile.dart';

abstract class ProfileRepository {
  Future<Either<Failure, UserProfile>> getProfile(String userId);
  Future<Either<Failure, UserProfile>> updateProfile(UserProfile profile);
  Future<Either<Failure, String>> uploadAvatar(String filePath);
}
