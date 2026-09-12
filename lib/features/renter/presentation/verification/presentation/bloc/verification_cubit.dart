import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahely/core/providers/auth_provider.dart';

import 'package:sahely/features/renter/domain/use_cases/get_verification_status_use_case.dart';
import 'package:sahely/features/renter/domain/use_cases/verify_email_use_case.dart';
import 'package:sahely/features/renter/domain/use_cases/verify_phone_use_case.dart';
import 'package:sahely/features/renter/domain/use_cases/verify_identity_use_case.dart';
import 'package:sahely/features/renter/domain/use_cases/add_payment_card_use_case.dart';
import 'package:sahely/features/renter/presentation/verification/domain/models/verification_state.dart';
import 'package:sahely/core/bloc/safe_emit.dart';

// UI States
abstract class VerificationCubitState {}

class VerificationInitial extends VerificationCubitState {}

class VerificationLoading extends VerificationCubitState {}

class VerificationLoaded extends VerificationCubitState {
  final VerificationState verificationState;

  VerificationLoaded(this.verificationState);
}

class VerificationError extends VerificationCubitState {
  final String message;

  VerificationError(this.message);
}

// Cubit
class VerificationCubit extends Cubit<VerificationCubitState>
    with SafeEmit<VerificationCubitState> {
  final GetVerificationStatusUseCase _getStatusUseCase;
  final VerifyEmailUseCase _verifyEmailUseCase;
  final VerifyPhoneUseCase _verifyPhoneUseCase;
  final VerifyIdentityUseCase _verifyIdUseCase;
  final AddPaymentCardUseCase _addCardUseCase;
  final AuthProvider? _authProvider;

  // Internal data state tracking
  VerificationState _currentState = const VerificationState(
    emailVerified: false,
    phoneVerified: false,
    idVerified: false,
    cardAdded: false,
  );

  VerificationCubit({
    required GetVerificationStatusUseCase getStatusUseCase,
    required VerifyEmailUseCase verifyEmailUseCase,
    required VerifyPhoneUseCase verifyPhoneUseCase,
    required VerifyIdentityUseCase verifyIdUseCase,
    required AddPaymentCardUseCase addCardUseCase,
    AuthProvider? authProvider,
  })  : _getStatusUseCase = getStatusUseCase,
        _verifyEmailUseCase = verifyEmailUseCase,
        _verifyPhoneUseCase = verifyPhoneUseCase,
        _verifyIdUseCase = verifyIdUseCase,
        _addCardUseCase = addCardUseCase,
        _authProvider = authProvider,
        super(VerificationInitial());

  /// Synchronizes verification completeness into [AuthProvider] so GoRouter
  /// can react to it via its [refreshListenable].
  void _syncVerified() {
    _authProvider?.setVerified(_currentState.isComplete);
  }

  // Load verification status
  Future<void> loadVerificationStatus() async {
    emit(VerificationLoading());
    try {
      final status = await _getStatusUseCase.execute();
      _currentState = status;
      emit(VerificationLoaded(status));
      _syncVerified();
    } catch (e) {
      emit(VerificationError('Failed to load verification status: $e'));
    }
  }

  // Update email verified
  Future<void> updateEmailVerified() async {
    try {
      await _verifyEmailUseCase.execute();
      _currentState = _currentState.copyWith(emailVerified: true);
      emit(VerificationLoaded(_currentState));
      _syncVerified();
    } catch (e) {
      emit(VerificationError('Failed to verify email: $e'));
    }
  }

  // Update phone verified
  Future<void> updatePhoneVerified() async {
    try {
      await _verifyPhoneUseCase.execute();
      _currentState = _currentState.copyWith(phoneVerified: true);
      emit(VerificationLoaded(_currentState));
      _syncVerified();
    } catch (e) {
      emit(VerificationError('Failed to verify phone: $e'));
    }
  }

  // Update ID verified
  Future<void> updateIdVerified() async {
    try {
      await _verifyIdUseCase.execute();
      _currentState = _currentState.copyWith(idVerified: true);
      emit(VerificationLoaded(_currentState));
      _syncVerified();
    } catch (e) {
      emit(VerificationError('Failed to verify ID: $e'));
    }
  }

  Future<void> updateCardAdded() async {
    try {
      await _addCardUseCase.execute();
      _currentState = _currentState.copyWith(cardAdded: true);
      emit(VerificationLoaded(_currentState));
      _syncVerified();
    } catch (e) {
      emit(VerificationError('Failed to add payment card: $e'));
    }
  }

  // Check if user can perform action
  bool canPerformAction() {
    return _currentState.isComplete;
  }

  // Get current data state
  VerificationState get currentDataState => _currentState;
}
