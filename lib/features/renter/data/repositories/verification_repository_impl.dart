import 'package:sahely/core/errors/exception_mapper.dart';
import 'package:sahely/core/network/api_client.dart';
import 'package:sahely/features/renter/data/datasources/verification_api_data_source.dart';
import 'package:sahely/features/renter/domain/repositories/verification_repository.dart';
import 'package:sahely/features/renter/presentation/verification/domain/models/verification_state.dart';

/// Verification (KYC) repository.
///
/// The status is authoritative on the backend (`GET /auth/verification/status`)
/// and is re-read through [getVerificationStatus]. The app cannot mark itself
/// verified, so the `mark*` calls - made after a step has been completed
/// against the API - have nothing to write: the next status read reflects it.
class VerificationRepositoryImpl implements VerificationRepository {
  VerificationRepositoryImpl(
      {VerificationApiDataSource? api, ApiClient? apiClient})
      : _api = api ?? VerificationApiDataSource(apiClient ?? ApiClient());

  final VerificationApiDataSource _api;

  @override
  Future<VerificationState> getVerificationStatus() async {
    try {
      return await _api.fetchStatus();
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  @override
  Future<void> markEmailAsVerified() async {}

  @override
  Future<void> markPhoneAsVerified() async {}

  @override
  Future<void> markIdAsVerified() async {}

  @override
  Future<void> markCardAsAdded() async {}
}
