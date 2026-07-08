import 'package:shared_preferences/shared_preferences.dart';

/// Contract for managing non-sensitive data storage (e.g., App Settings, Theme, Locale).
abstract class LocalStorage {
  Future<void> write(String key, String value);
  Future<String?> read(String key);
  Future<void> writeBool(String key, bool value);
  Future<bool?> readBool(String key);
  Future<void> delete(String key);
  Future<void> clearAll();
}

/// Implementation using [SharedPreferences].
class LocalStorageImpl implements LocalStorage {
  final SharedPreferences _prefs;

  LocalStorageImpl(this._prefs);

  @override
  Future<void> write(String key, String value) async {
    await _prefs.setString(key, value);
  }

  @override
  Future<String?> read(String key) async {
    return _prefs.getString(key);
  }

  @override
  Future<void> writeBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  @override
  Future<bool?> readBool(String key) async {
    return _prefs.getBool(key);
  }

  @override
  Future<void> delete(String key) async {
    await _prefs.remove(key);
  }

  @override
  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
