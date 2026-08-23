import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'cache_service.dart';
import 'cache_entry.dart';

class SharedPreferencesCacheService implements CacheService {
  final SharedPreferences _prefs;
  static const String _prefix = 'sahely_cache_';

  SharedPreferencesCacheService(this._prefs);

  @override
  Future<void> save<T>({
    required String key,
    required T data,
    Duration? ttl,
    String version = '1.0.0',
    required Map<String, dynamic> Function(T) toJson,
  }) async {
    final entry = CacheEntry<T>(
      data: data,
      timestamp: DateTime.now(),
      ttl: ttl,
      version: version,
    );
    
    final jsonString = jsonEncode(entry.toJson(toJson));
    await _prefs.setString('$_prefix$key', jsonString);
  }

  @override
  Future<CacheEntry<T>?> read<T>({
    required String key,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    final jsonString = _prefs.getString('$_prefix$key');
    if (jsonString == null) return null;

    try {
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      return CacheEntry<T>.fromJson(jsonMap, fromJson);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> exists(String key) async {
    return _prefs.containsKey('$_prefix$key');
  }

  @override
  Future<void> remove(String key) async {
    await _prefs.remove('$_prefix$key');
  }

  @override
  Future<void> clear() async {
    final keys = _prefs.getKeys().where((k) => k.startsWith(_prefix));
    for (final key in keys) {
      await _prefs.remove(key);
    }
  }

  @override
  Future<void> clearAll() => clear();
}
