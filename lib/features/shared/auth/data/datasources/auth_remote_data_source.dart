import 'package:sahely/core/network/api_client.dart';
import 'package:sahely/core/constants/api_constants.dart';
import 'package:sahely/core/errors/exceptions.dart';
import 'package:sahely/features/shared/auth/data/models/user_model.dart';
import 'package:sahely/features/shared/auth/domain/entities/user.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String name, String email, String password, UserRole role);
  Future<void> verifyOtp(String email, String otp);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDataSourceImpl(this._apiClient);

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.login,
        data: {'email': email, 'password': password},
      );
      return UserModel.fromJson(response.data['user']);
    } catch (e) {
      throw ServerException(message: 'Login failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> register(String name, String email, String password, UserRole role) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.register,
        data: {
          'name': name,
          'email': email,
          'password': password,
          'role': role.name,
        },
      );
      return UserModel.fromJson(response.data['user']);
    } catch (e) {
      throw ServerException(message: 'Registration failed');
    }
  }

  @override
  Future<void> verifyOtp(String email, String otp) async {
    try {
      await _apiClient.post(
        ApiConstants.verifyOtp,
        data: {'email': email, 'otp': otp},
      );
    } catch (e) {
      throw ServerException(message: 'OTP Verification failed');
    }
  }
}
