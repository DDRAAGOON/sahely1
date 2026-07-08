import 'dart:convert';
import 'package:sahely/core/storage/secure_storage.dart';
import 'package:sahely/core/constants/app_constants.dart';
import 'package:sahely/features/shared/auth/data/models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel userToCache);
  Future<UserModel?> getCachedUser();
  Future<void> cacheToken(String token);
  Future<String?> getToken();
  Future<void> clearCache();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SecureStorage _secureStorage;

  AuthLocalDataSourceImpl(this._secureStorage);

  @override
  Future<void> cacheUser(UserModel userToCache) async {
    await _secureStorage.write(
      AppConstants.userKey,
      json.encode(userToCache.toJson()),
    );
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final jsonString = await _secureStorage.read(AppConstants.userKey);
    if (jsonString != null) {
      return UserModel.fromJson(json.decode(jsonString));
    }
    return null;
  }

  @override
  Future<void> cacheToken(String token) async {
    await _secureStorage.write(AppConstants.tokenKey, token);
  }

  @override
  Future<String?> getToken() async {
    return await _secureStorage.read(AppConstants.tokenKey);
  }

  @override
  Future<void> clearCache() async {
    await _secureStorage.delete(AppConstants.userKey);
    await _secureStorage.delete(AppConstants.tokenKey);
  }
}
