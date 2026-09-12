import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sahely/data/models.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import '../../domain/entities/auth_entity.dart';
import '../../data/models/login_request_model.dart';
import '../../data/models/register_request_model.dart';
import 'package:sahely/core/bloc/safe_emit.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final AuthEntity user;
  const AuthSuccess(this.user);
  @override
  List<Object?> get props => [user];
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
  @override
  List<Object?> get props => [message];
}

class RegisterStep1Success extends AuthState {
  final String sessionId;
  const RegisterStep1Success(this.sessionId);
  @override
  List<Object?> get props => [sessionId];
}

class OtpSentSuccess extends AuthState {
  final String testHint;
  const OtpSentSuccess(this.testHint);
  @override
  List<Object?> get props => [testHint];
}

class AuthCubit extends Cubit<AuthState> with SafeEmit<AuthState> {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final RegisterStep1UseCase _registerStep1UseCase;
  final RegisterStep2UseCase _registerStep2UseCase;
  final VerifyEmailOtpUseCase _verifyEmailOtpUseCase;
  final SendPhoneOtpUseCase _sendPhoneOtpUseCase;
  final VerifyPhoneOtpUseCase _verifyPhoneOtpUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;

  AuthCubit({
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
    required RegisterStep1UseCase registerStep1UseCase,
    required RegisterStep2UseCase registerStep2UseCase,
    required VerifyEmailOtpUseCase verifyEmailOtpUseCase,
    required SendPhoneOtpUseCase sendPhoneOtpUseCase,
    required VerifyPhoneOtpUseCase verifyPhoneOtpUseCase,
    required ResetPasswordUseCase resetPasswordUseCase,
  })  : _loginUseCase = loginUseCase,
        _logoutUseCase = logoutUseCase,
        _registerStep1UseCase = registerStep1UseCase,
        _registerStep2UseCase = registerStep2UseCase,
        _verifyEmailOtpUseCase = verifyEmailOtpUseCase,
        _sendPhoneOtpUseCase = sendPhoneOtpUseCase,
        _verifyPhoneOtpUseCase = verifyPhoneOtpUseCase,
        _resetPasswordUseCase = resetPasswordUseCase,
        super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    final request = LoginRequestModel(email: email, password: password);
    final result = await _loginUseCase(request);

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthSuccess(user)),
    );
  }

  Future<void> logout() async {
    emit(AuthLoading());
    final result = await _logoutUseCase();

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(AuthInitial()),
    );
  }

  Future<void> registerStep1(Role role) async {
    emit(AuthLoading());
    final result = await _registerStep1UseCase(role);

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (sessionId) => emit(RegisterStep1Success(sessionId)),
    );
  }

  Future<void> registerStep2(RegisterStep2RequestModel request) async {
    emit(AuthLoading());
    final result = await _registerStep2UseCase(request);

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(AuthInitial()),
    );
  }

  Future<void> verifyEmailOtp(String sessionId, String otp) async {
    emit(AuthLoading());
    final result = await _verifyEmailOtpUseCase(sessionId, otp);

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(AuthInitial()),
    );
  }

  Future<void> sendPhoneOtp(String sessionId) async {
    emit(AuthLoading());
    final result = await _sendPhoneOtpUseCase(sessionId);

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (testHint) => emit(OtpSentSuccess(testHint)),
    );
  }

  Future<void> verifyPhoneOtp(String sessionId, String otp) async {
    emit(AuthLoading());
    final result = await _verifyPhoneOtpUseCase(sessionId, otp);

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(AuthInitial()),
    );
  }

  Future<void> resetPassword(String email) async {
    emit(AuthLoading());
    final result = await _resetPasswordUseCase(email);

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(AuthInitial()),
    );
  }
}
