import 'package:sahely/features/renter/presentation/verification/domain/models/verification_state.dart';

abstract class VerificationRepository {
  Future<VerificationState> getVerificationStatus();
  Future<void> markEmailAsVerified();
  Future<void> markPhoneAsVerified();
  Future<void> markIdAsVerified();
  Future<void> markCardAsAdded();
}
