import 'package:sahely/features/owner/domain/entities/owner_dashboard.dart';
import 'package:sahely/features/owner/domain/repositories/owner_repository.dart';

class GetOwnerDashboardUseCase {
  final OwnerRepository repository;

  GetOwnerDashboardUseCase(this.repository);

  Future<OwnerDashboard> execute() {
    return repository.getOwnerDashboard();
  }
}
