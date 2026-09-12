import 'package:dartz/dartz.dart';

import 'package:sahely/core/errors/exception_mapper.dart';
import 'package:sahely/core/errors/failures.dart';

import '../../domain/entities/mawsem_entity.dart'
    show
        LeaderboardEntry,
        MawsemEntity,
        MawsemHistoryEntity,
        MawsemLevelInfo,
        MawsemPerkEntity;
import '../../domain/repositories/mawsem_repository.dart';
import '../datasources/mawsem_remote_data_source.dart';
import '../models/mawsem_model.dart';

/// Repository implementation for the MAWSEM loyalty program.
class MawsemRepositoryImpl implements MawsemRepository {
  final MawsemRemoteDataSource remoteDataSource;

  MawsemRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, MawsemEntity>> getMawsemStatus() async {
    try {
      final result = await remoteDataSource.getMawsemStatus();
      return result.map((model) => model.toEntity());
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, List<MawsemLevelInfo>>> getMawsemLevels() async {
    try {
      return await remoteDataSource.getMawsemLevels();
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, List<LeaderboardEntry>>> getLeaderboard({
    int limit = 10,
  }) async {
    try {
      return await remoteDataSource.getLeaderboard(limit: limit);
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, List<MawsemPerkEntity>>> getAvailablePerks() async {
    try {
      final result = await remoteDataSource.getAvailablePerks();
      return result.map(
        (models) => models.map((model) => model.toEntity()).toList(),
      );
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  /// The redeem endpoints answer with the updated perk, so the response is
  /// parsed back into a perk entity for the UI to render.
  @override
  Future<Either<Failure, MawsemPerkEntity>> redeemPerk(String perkId) async {
    try {
      final result = await remoteDataSource.redeemPerk(perkId);
      return result.map(
        (json) => MawsemPerkModel.fromJson(
          json.isEmpty ? {'id': perkId} : json,
        ).toEntity(),
      );
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, List<MawsemHistoryEntity>>> getHistory({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final result =
          await remoteDataSource.getHistory(page: page, limit: limit);
      return result.map(
        (models) => models.map((model) => model.toEntity()).toList(),
      );
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }
}
