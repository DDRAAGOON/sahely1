import 'package:dartz/dartz.dart';
import 'package:sahely/core/errors/failures.dart';
import '../repositories/user_repository.dart';

/// Use case for uploading user avatar
class UploadAvatarUseCase {
  final UserRepository repository;

  UploadAvatarUseCase(this.repository);

  Future<Either<Failure, String>> call(String imagePath) async {
    return await repository.uploadAvatar(imagePath);
  }
}
