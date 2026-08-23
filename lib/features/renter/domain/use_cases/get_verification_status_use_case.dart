import '../../presentation/verification/domain/models/verification_state.dart';
import '../repositories/verification_repository.dart';

class GetVerificationStatusUseCase {
  final VerificationRepository repository;

  GetVerificationStatusUseCase(this.repository);

  Future<VerificationState> execute() {
    return repository.getVerificationStatus();
  }
}
