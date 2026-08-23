import '../repositories/verification_repository.dart';

class VerifyEmailUseCase {
  final VerificationRepository repository;

  VerifyEmailUseCase(this.repository);

  Future<void> execute() {
    return repository.markEmailAsVerified();
  }
}
