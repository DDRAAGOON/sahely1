import 'dart:convert';
import 'package:crypto/crypto.dart';

class RequestCacheKey {
  static String from({
    required String path,
    Map<String, dynamic>? queryParameters,
    dynamic body,
  }) {
    final components = [
      path.toLowerCase(),
      if (queryParameters != null) _sortMap(queryParameters),
      if (body != null) body.toString(),
    ];
    
    final rawKey = components.join('|');
    return sha256.convert(utf8.encode(rawKey)).toString();
  }

  static String _sortMap(Map<String, dynamic> map) {
    final sortedKeys = map.keys.toList()..sort();
    final sortedMap = {for (var key in sortedKeys) key: map[key]};
    return sortedMap.toString();
  }
}
