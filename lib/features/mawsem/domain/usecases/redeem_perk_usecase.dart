import 'package:dartz/dartz.dart';
import 'package:sahely/core/errors/failures.dart';
import '../repositories/mawsem_repository.dart';
import '../entities/mawsem_entity.dart';

/// Use case for redeeming a perk
class RedeemPerkUseCase {
  final MawsemRepository repository;

  RedeemPerkUseCase(this.repository);

  Future<Either<Failure, MawsemPerkEntity>> call(String perkId) async {
    return await repository.redeemPerk(perkId);
  }
}
