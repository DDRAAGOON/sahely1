import 'dart:async';

import '../../data/models.dart';

class AuthResponse {
  final String token;
  final Role role;
  AuthResponse({required this.token, required this.role});
}

/// A tiny mock auth service to simulate backend responses while the real
/// authentication API is not available.
class MockAuthService {
  Future<AuthResponse> signIn(String email, String password) async {
    // Simulate network latency
    await Future.delayed(const Duration(milliseconds: 250));

    // Decide role by email hints (simple heuristic for testing)
    final lower = email.toLowerCase();
    final role = lower.contains('broker')
        ? Role.broker
        : (lower.contains('owner') ? Role.owner : Role.renter);

    final token = 'mock-${role.name}-token';

    return AuthResponse(token: token, role: role);
  }
}
