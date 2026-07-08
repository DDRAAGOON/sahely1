import '../../domain/models/verification_state.dart';

class VerificationRepository {
  // TODO: لما الـ API يجي، هتحذف الـ Mock Data وتستخدم الـ API
  Future<VerificationState> getVerificationStatus() async {
    // TODO: API Call
    // final response = await _apiService.get('/auth/verification/status');
    // return VerificationState(
    //   emailVerified: response.data['email_verified'],
    //   phoneVerified: response.data['phone_verified'],
    //   idVerified: response.data['id_verified'],
    //   cardAdded: response.data['card_added'],
    // );

    // Mock Data - للتجربة لحد ما الـ API يجي
    await Future.delayed(const Duration(seconds: 1)); // محاكاة الـ API delay

    return const VerificationState(
      emailVerified: true,
      phoneVerified: true,
      idVerified: true,
      cardAdded: false, // مش مضاف عشان نجرب الـ Blocked Gate
    );
  }

  Future<void> markEmailAsVerified() async {
    // TODO: API Call
    // await _apiService.post('/auth/verify-email');
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> markPhoneAsVerified() async {
    // TODO: API Call
    // await _apiService.post('/auth/verify-phone');
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> markIdAsVerified() async {
    // TODO: API Call
    // await _apiService.post('/auth/verify-id');
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> markCardAsAdded() async {
    // TODO: API Call
    // await _apiService.post('/auth/add-payment-card');
    await Future.delayed(const Duration(milliseconds: 500));
  }
}