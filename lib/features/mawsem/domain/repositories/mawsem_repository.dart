import 'package:dartz/dartz.dart';
import 'package:sahely/core/errors/failures.dart';
import '../entities/mawsem_entity.dart';

/// Repository interface for MAWSEM loyalty program
abstract class MawsemRepository {
  /// Get user's MAWSEM status
  Future<Either<Failure, MawsemEntity>> getMawsemStatus();

  /// Get available MAWSEM levels
  Future<Either<Failure, List<MawsemLevelInfo>>> getMawsemLevels();

  /// Get MAWSEM leaderboard
  Future<Either<Failure, List<LeaderboardEntry>>> getLeaderboard({
    int limit = 10,
  });

  /// Get available perks for user
  Future<Either<Failure, List<MawsemPerkEntity>>> getAvailablePerks();

  /// Redeem a perk
  Future<Either<Failure, MawsemPerkEntity>> redeemPerk(String perkId);

  /// Get MAWSEM history
  Future<Either<Failure, List<MawsemHistoryEntity>>> getHistory({
    int page = 1,
    int limit = 20,
  });
}
