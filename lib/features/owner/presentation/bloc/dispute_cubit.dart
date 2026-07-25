import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahely/features/owner/domain/repositories/owner_repository.dart';
import 'package:sahely/features/owner/presentation/bloc/dispute_state.dart';

class DisputeCubit extends Cubit<DisputeState> {
  final OwnerRepository repository;

  DisputeCubit({required this.repository}) : super(DisputeInitial());

  Future<void> submitDispute({
    required String reason,
    List<String>? attachments,
  }) async {
    if (reason.isEmpty) {
      emit(const DisputeError('Please explain your case'));
      return;
    }

    emit(DisputeSubmitting());

    try {
      await repository.submitDispute(reason: reason, attachments: attachments);
      emit(DisputeSuccess());
    } catch (e) {
      emit(DisputeError('Failed to submit dispute: $e'));
    }
  }
}
