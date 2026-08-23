import 'package:sahely/core/errors/exception_mapper.dart';
import 'package:sahely/features/renter/data/datasources/mock_verification_data_source.dart';
import 'package:sahely/features/renter/presentation/verification/domain/models/verification_state.dart';
import 'package:sahely/features/renter/domain/repositories/verification_repository.dart';

class VerificationRepositoryImpl implements VerificationRepository {
  final MockVerificationDataSource dataSource;

  VerificationRepositoryImpl({required this.dataSource});

  @override
  Future<VerificationState> getVerificationStatus() async {
    try {
      return await dataSource.fetchVerificationStatus();
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  @override
  Future<void> markEmailAsVerified() async {
    try {
      await dataSource.markEmailVerified();
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  @override
  Future<void> markPhoneAsVerified() async {
    try {
      await dataSource.markPhoneVerified();
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  @override
  Future<void> markIdAsVerified() async {
    try {
      await dataSource.markIdVerified();
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  @override
  Future<void> markCardAsAdded() async {
    try {
      await dataSource.markCardAdded();
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }
}
