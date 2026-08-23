import 'package:sahely/core/validation/common_validators.dart';
import 'package:sahely/core/validation/validator.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<void> execute({
    required String name,
    required String email,
    required String phone,
    required String role,
  }) {
    // Input Validation
    final nameResult = RequiredValidator<String>().validate(name, fieldName: 'Name');
    if (!nameResult.isValid) throw nameResult.toFailure();

    final emailResult = CompositeValidator<String>([
      RequiredValidator<String>(),
      EmailValidator(),
    ]).validate(email, fieldName: 'Email');
    if (!emailResult.isValid) throw emailResult.toFailure();

    final phoneResult = PhoneValidator().validate(phone, fieldName: 'Phone');
    if (!phoneResult.isValid) throw phoneResult.toFailure();

    return repository.signUp(
      name: name,
      email: email,
      phone: phone,
      role: role,
    );
  }
}
