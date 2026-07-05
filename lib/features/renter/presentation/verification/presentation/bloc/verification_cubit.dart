import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/models/verification_state.dart';
import '../../data/repositories/verification_repository.dart';

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
class VerificationCubit extends Cubit<VerificationCubitState> {
  final VerificationRepository _repository;
  
  // Internal data state tracking
  VerificationState _currentState = const VerificationState(
    emailVerified: false,
    phoneVerified: false,
    idVerified: false,
    cardAdded: false,
  );

  VerificationCubit(this._repository) : super(VerificationInitial());

  // Load verification status
  Future<void> loadVerificationStatus() async {
    emit(VerificationLoading());
    try {
      final status = await _repository.getVerificationStatus();
      _currentState = status;
      emit(VerificationLoaded(status));
    } catch (e) {
      emit(VerificationError('Failed to load verification status: $e'));
    }
  }

  // Update email verified
  Future<void> updateEmailVerified() async {
    try {
      await _repository.markEmailAsVerified();
      _currentState = _currentState.copyWith(emailVerified: true);
      emit(VerificationLoaded(_currentState));
    } catch (e) {
      emit(VerificationError('Failed to verify email: $e'));
    }
  }

  // Update phone verified
  Future<void> updatePhoneVerified() async {
    try {
      await _repository.markPhoneAsVerified();
      _currentState = _currentState.copyWith(phoneVerified: true);
      emit(VerificationLoaded(_currentState));
    } catch (e) {
      emit(VerificationError('Failed to verify phone: $e'));
    }
  }

  // Update ID verified
  Future<void> updateIdVerified() async {
    try {
      await _repository.markIdAsVerified();
      _currentState = _currentState.copyWith(idVerified: true);
      emit(VerificationLoaded(_currentState));
    } catch (e) {
      emit(VerificationError('Failed to verify ID: $e'));
    }
  }

  // Update card added
  Future<void> updateCardAdded() async {
    try {
      await _repository.markCardAsAdded();
      _currentState = _currentState.copyWith(cardAdded: true);
      emit(VerificationLoaded(_currentState));
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
