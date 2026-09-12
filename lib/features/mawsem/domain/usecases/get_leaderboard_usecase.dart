import 'package:dartz/dartz.dart';
import 'package:sahely/core/errors/failures.dart';
import '../repositories/mawsem_repository.dart';
import '../entities/mawsem_entity.dart';

/// Use case for getting MAWSEM leaderboard
class GetLeaderboardUseCase {
  final MawsemRepository repository;

  GetLeaderboardUseCase(this.repository);

  Future<Either<Failure, List<LeaderboardEntry>>> call({int limit = 10}) async {
    return await repository.getLeaderboard(limit: limit);
  }
}
