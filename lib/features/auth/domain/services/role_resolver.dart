import 'package:sahely/data/models.dart';

/// A domain service responsible for resolving user roles based on business rules.
/// Currently used to simulate role selection for testing purposes.
class RoleResolver {
  Role resolveRoleFromEmail(String email) {
    final lower = email.toLowerCase();

    if (lower.contains('broker')) {
      return Role.broker;
    } else if (lower.contains('owner')) {
      return Role.owner;
    } else {
      return Role.renter;
    }
  }
}
