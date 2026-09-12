import 'package:dartz/dartz.dart';

import 'package:sahely/core/errors/exception_mapper.dart';
import 'package:sahely/core/errors/failures.dart';
import 'package:sahely/core/network/api_client.dart';
import 'package:sahely/core/network/api_endpoints.dart';
import 'package:sahely/core/network/api_envelope.dart';

import '../../domain/entities/mawsem_entity.dart'
    show LeaderboardEntry, MawsemLevel, MawsemLevelInfo;
import '../models/mawsem_model.dart';

/// Remote data source for the MAWSEM loyalty program.
///
/// The season-admin routes (`/mawsem/admin/*`) are back-office only and are not
/// wired into the app.
class MawsemRemoteDataSource {
  final ApiClient _apiClient;

  MawsemRemoteDataSource(this._apiClient);

  /// The signed-in user's standing: stars, level, season progress.
  Future<Either<Failure, MawsemModel>> getMawsemStatus() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.mawsemMe);
      return Right(MawsemModel.fromJson(asMap(unwrapData(response.data))));
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  Future<Either<Failure, List<MawsemLevelInfo>>> getMawsemLevels() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.mawsemLevels);
      final levels = asListOfMaps(unwrapData(response.data))
          .map(_parseLevelInfo)
          .toList(growable: false);
      return Right(levels);
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  /// Past level-ups for the signed-in user.
  Future<Either<Failure, List<Map<String, dynamic>>>> getLevelHistory() =>
      _list(ApiEndpoints.mawsemLevelHistory);

  Future<Either<Failure, List<LeaderboardEntry>>> getLeaderboard({
    int limit = 10,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.mawsemLeaderboard,
        queryParameters: {'limit': limit},
      );
      final entries = asListOfMaps(unwrapData(response.data))
          .map(_parseLeaderboardEntry)
          .toList(growable: false);
      return Right(entries);
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  Future<Either<Failure, List<MawsemPerkModel>>> getAvailablePerks() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.mawsemPerks);
      final perks = asListOfMaps(unwrapData(response.data))
          .map(MawsemPerkModel.fromJson)
          .toList(growable: false);
      return Right(perks);
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  /// Redeems a perk.
  ///
  /// The API exposes one concrete perk redemption - free cleaning, level 5+
  /// (`POST /mawsem/perks/free-cleaning/use`). Everything else is spent as a
  /// reward token through [useToken].
  Future<Either<Failure, Map<String, dynamic>>> redeemPerk(
    String perkId, {
    String? bookingId,
  }) async {
    try {
      final isFreeCleaning =
          perkId == 'free_cleaning' || perkId == 'free-cleaning';
      final response = await _apiClient.post(
        isFreeCleaning
            ? ApiEndpoints.mawsemFreeCleaning
            : ApiEndpoints.mawsemUseToken,
        data: {
          if (isFreeCleaning) ...{
            if (bookingId != null) 'booking_id': bookingId,
          } else ...{
            'token_id': perkId,
            if (bookingId != null) 'booking_id': bookingId,
          },
        },
      );
      return Right(asMap(unwrapData(response.data)));
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  /// Reward tokens the user currently holds.
  Future<Either<Failure, List<Map<String, dynamic>>>> getTokens() =>
      _list(ApiEndpoints.mawsemTokens);

  Future<Either<Failure, Map<String, dynamic>>> useToken(
    String tokenId, {
    String? bookingId,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.mawsemUseToken,
        data: {
          'token_id': tokenId,
          if (bookingId != null) 'booking_id': bookingId,
        },
      );
      return Right(asMap(unwrapData(response.data)));
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  /// The currently running season (dates, prize pool, enrolment state).
  Future<Either<Failure, Map<String, dynamic>>> getCurrentSeason() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.mawsemCurrentSeason);
      return Right(asMap(unwrapData(response.data)));
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  Future<Either<Failure, List<MawsemHistoryModel>>> getHistory({
    int page = 1,
    int limit = ApiEndpoints.defaultPageSize,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.mawsemHistory,
        queryParameters: pageQuery(page: page, limit: limit),
      );
      final history = asListOfMaps(unwrapData(response.data))
          .map(MawsemHistoryModel.fromJson)
          .toList(growable: false);
      return Right(history);
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  Future<Either<Failure, List<Map<String, dynamic>>>> _list(String path) async {
    try {
      final response = await _apiClient.get(path);
      return Right(asListOfMaps(unwrapData(response.data)));
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  MawsemLevelInfo _parseLevelInfo(Map<String, dynamic> json) {
    return MawsemLevelInfo(
      level: _parseLevel(json['level']),
      requiredStars: asNum(json['required_stars'])?.toInt() ?? 0,
      discountRate: asNum(json['discount_rate'])?.toDouble() ?? 0.0,
      benefits: asStringList(json['benefits']),
    );
  }

  LeaderboardEntry _parseLeaderboardEntry(Map<String, dynamic> json) {
    return LeaderboardEntry(
      userId: '${json['user_id'] ?? ''}',
      userName: '${json['user_name'] ?? ''}',
      userAvatar: json['user_avatar'] as String?,
      stars: asNum(json['stars'])?.toInt() ?? 0,
      level: _parseLevel(json['level']),
      rank: asNum(json['rank'])?.toInt() ?? 0,
    );
  }

  MawsemLevel _parseLevel(dynamic level) {
    return switch ('$level'.toLowerCase()) {
      'silver' => MawsemLevel.silver,
      'gold' => MawsemLevel.gold,
      'platinum' => MawsemLevel.platinum,
      'diamond' => MawsemLevel.diamond,
      _ => MawsemLevel.bronze,
    };
  }
}
