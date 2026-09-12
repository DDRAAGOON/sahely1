import 'package:dartz/dartz.dart';
import 'package:sahely/core/errors/failures.dart';
import '../repositories/mawsem_repository.dart';
import '../entities/mawsem_entity.dart';

/// Use case for getting available perks
class GetAvailablePerksUseCase {
  final MawsemRepository repository;

  GetAvailablePerksUseCase(this.repository);

  Future<Either<Failure, List<MawsemPerkEntity>>> call() async {
    return await repository.getAvailablePerks();
  }
}
