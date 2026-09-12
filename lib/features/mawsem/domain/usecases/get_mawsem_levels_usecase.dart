import 'package:dartz/dartz.dart';
import 'package:sahely/core/errors/failures.dart';
import '../repositories/mawsem_repository.dart';
import '../entities/mawsem_entity.dart';

/// Use case for getting available MAWSEM levels
class GetMawsemLevelsUseCase {
  final MawsemRepository repository;

  GetMawsemLevelsUseCase(this.repository);

  Future<Either<Failure, List<MawsemLevelInfo>>> call() async {
    return await repository.getMawsemLevels();
  }
}
