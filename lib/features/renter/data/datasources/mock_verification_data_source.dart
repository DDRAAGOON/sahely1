import 'package:sahely/features/renter/presentation/verification/domain/models/verification_state.dart';

class MockVerificationDataSource {
  Future<VerificationState> fetchVerificationStatus() async {
    await Future.delayed(const Duration(seconds: 1));
    return const VerificationState(
      emailVerified: true,
      phoneVerified: true,
      idVerified: true,
      cardAdded: true,
    );
  }

  Future<void> markEmailVerified() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> markPhoneVerified() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> markIdVerified() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> markCardAdded() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
