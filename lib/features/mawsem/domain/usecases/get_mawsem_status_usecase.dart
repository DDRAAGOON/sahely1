import 'package:dartz/dartz.dart';
import 'package:sahely/core/errors/failures.dart';
import '../repositories/mawsem_repository.dart';
import '../entities/mawsem_entity.dart';

/// Use case for getting user's MAWSEM status
class GetMawsemStatusUseCase {
  final MawsemRepository repository;

  GetMawsemStatusUseCase(this.repository);

  Future<Either<Failure, MawsemEntity>> call() async {
    return await repository.getMawsemStatus();
  }
}
