import '../repositories/verification_repository.dart';

class AddPaymentCardUseCase {
  final VerificationRepository repository;

  AddPaymentCardUseCase(this.repository);

  Future<void> execute() {
    return repository.markCardAsAdded();
  }
}
