import '../repositories/auth_repository.dart';
import '../services/role_resolver.dart';

class LoginUseCase {
  final AuthRepository repository;
  final RoleResolver roleResolver;

  LoginUseCase(this.repository, this.roleResolver);

  Future<AuthResponse> execute(String email, String password) async {
    // 1. Perform authentication via repository (Data layer)
    final response = await repository.signIn(email, password);
    
    // 2. Resolve the correct role based on business logic (Domain layer)
    // In a real production app, the server would return the role.
    // For our current architecture, we resolve it here to decouple the repository.
    final resolvedRole = roleResolver.resolveRoleFromEmail(email);

    return AuthResponse(
      token: response.token,
      role: resolvedRole,
    );
  }
}
