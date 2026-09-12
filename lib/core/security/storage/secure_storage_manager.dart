import 'dart:convert';
import 'secure_storage_service.dart';
import 'secure_storage_failure.dart';

class SecureStorageManager {
  final SecureStorageService _service;
  final String _namespace;
  final String _version;

  SecureStorageManager({
    required SecureStorageService service,
    String namespace = 'app',
    String version = '1.0.0',
  })  : _service = service,
        _namespace = namespace,
        _version = version;

  String _buildKey(String key) => '$_namespace:$_version:$key';

  Future<void> write<T>({
    required String key,
    required T value,
    Map<String, dynamic> Function(T)? toJson,
  }) async {
    try {
      final String stringValue;
      if (toJson != null) {
        stringValue = jsonEncode(toJson(value));
      } else if (value is String || value is num || value is bool) {
        stringValue = value.toString();
      } else {
        stringValue = jsonEncode(value);
      }
      await _service.write(key: _buildKey(key), value: stringValue);
    } catch (e) {
      throw SecureStorageException('Error writing to secure storage: $e');
    }
  }

  Future<T?> read<T>({
    required String key,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final value = await _service.read(key: _buildKey(key));
      if (value == null) return null;

      if (fromJson != null) {
        return fromJson(jsonDecode(value) as Map<String, dynamic>);
      }

      if (T == String) return value as T;
      if (T == int) return int.tryParse(value) as T?;
      if (T == double) return double.tryParse(value) as T?;
      if (T == bool) return (value == 'true') as T;

      return jsonDecode(value) as T?;
    } catch (e) {
      throw SecureStorageException('Error reading from secure storage: $e');
    }
  }

  Future<void> delete({required String key}) async {
    await _service.delete(key: _buildKey(key));
  }

  Future<void> deleteAll() async {
    await _service.deleteAll();
  }

  Future<bool> containsKey({required String key}) async {
    return await _service.containsKey(key: _buildKey(key));
  }

  Future<Map<String, String>> readAll() async {
    final all = await _service.readAll();
    final result = <String, String>{};
    final prefix = '$_namespace:$_version:';

    all.forEach((key, value) {
      if (key.startsWith(prefix)) {
        result[key.replaceFirst(prefix, '')] = value;
      }
    });

    return result;
  }
}
