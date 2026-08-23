import '../repositories/profile_repository.dart';

class UpdateCurrencyUseCase {
  final ProfileRepository repository;

  UpdateCurrencyUseCase(this.repository);

  Future<void> execute(String currencyCode) {
    return repository.updateCurrency(currencyCode);
  }
}
