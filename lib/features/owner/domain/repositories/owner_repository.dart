import 'package:sahely/features/owner/domain/entities/owner_dashboard.dart';

abstract class OwnerRepository {
  Future<OwnerDashboard> getOwnerDashboard();
}
