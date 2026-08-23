import '../repositories/verification_repository.dart';

class VerifyIdentityUseCase {
  final VerificationRepository repository;

  VerifyIdentityUseCase(this.repository);

  Future<void> execute() {
    return repository.markIdAsVerified();
  }
}
