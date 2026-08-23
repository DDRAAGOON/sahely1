import '../../../../renter/domain/repositories/renter_repository.dart';
import '../entities/property.dart';

class GetPropertyDetailsUseCase {
  final RenterRepository repository;

  GetPropertyDetailsUseCase(this.repository);

  Future<Property?> execute(String id) async {
    final properties = await repository.getAllProperties();
    try {
      return properties.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}
