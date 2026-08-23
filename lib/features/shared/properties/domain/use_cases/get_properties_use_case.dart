import '../../../../renter/domain/repositories/renter_repository.dart';
import '../entities/property.dart';

class GetPropertiesUseCase {
  final RenterRepository repository;

  GetPropertiesUseCase(this.repository);

  Future<List<Property>> execute() {
    return repository.getAllProperties();
  }
}
