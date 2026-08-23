import '../repositories/verification_repository.dart';

class VerifyPhoneUseCase {
  final VerificationRepository repository;

  VerifyPhoneUseCase(this.repository);

  Future<void> execute() {
    return repository.markPhoneAsVerified();
  }
}
