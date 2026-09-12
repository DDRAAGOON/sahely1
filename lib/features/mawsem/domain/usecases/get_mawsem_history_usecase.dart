import 'package:dartz/dartz.dart';
import 'package:sahely/core/errors/failures.dart';
import '../repositories/mawsem_repository.dart';
import '../entities/mawsem_entity.dart';

/// Use case for getting MAWSEM history
class GetMawsemHistoryUseCase {
  final MawsemRepository repository;

  GetMawsemHistoryUseCase(this.repository);

  Future<Either<Failure, List<MawsemHistoryEntity>>> call({
    int page = 1,
    int limit = 20,
  }) async {
    return await repository.getHistory(
      page: page,
      limit: limit,
    );
  }
}
