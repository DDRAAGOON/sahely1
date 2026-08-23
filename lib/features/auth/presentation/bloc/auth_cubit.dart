import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sahely/core/errors/failures.dart';
import '../../domain/use_cases/login_use_case.dart';
import '../../domain/use_cases/logout_use_case.dart';
import '../../domain/use_cases/register_use_case.dart';
import '../../domain/use_cases/reset_password_use_case.dart';
import '../../domain/repositories/auth_repository.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthSuccess extends AuthState {
  final AuthResponse response;
  const AuthSuccess(this.response);
  @override
  List<Object?> get props => [response];
}
class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
  @override
  List<Object?> get props => [message];
}

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final RegisterUseCase _registerUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;

  AuthCubit({
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
    required RegisterUseCase registerUseCase,
    required ResetPasswordUseCase resetPasswordUseCase,
  }) : _loginUseCase = loginUseCase,
       _logoutUseCase = logoutUseCase,
       _registerUseCase = registerUseCase,
       _resetPasswordUseCase = resetPasswordUseCase,
       super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final response = await _loginUseCase.execute(email, password);
      emit(AuthSuccess(response));
    } catch (e) {
      final message = e is Failure ? e.message : e.toString();
      emit(AuthError(message));
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());
    try {
      await _logoutUseCase.execute();
      emit(AuthInitial());
    } catch (e) {
      final message = e is Failure ? e.message : e.toString();
      emit(AuthError(message));
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String phone,
    required String role,
  }) async {
    emit(AuthLoading());
    try {
      await _registerUseCase.execute(
        name: name,
        email: email,
        phone: phone,
        role: role,
      );
      emit(AuthInitial()); // Or a specific RegisterSuccess state
    } catch (e) {
      final message = e is Failure ? e.message : e.toString();
      emit(AuthError(message));
    }
  }

  Future<void> resetPassword(String email) async {
    emit(AuthLoading());
    try {
      await _resetPasswordUseCase.execute(email);
      emit(AuthInitial());
    } catch (e) {
      final message = e is Failure ? e.message : e.toString();
      emit(AuthError(message));
    }
  }
}
