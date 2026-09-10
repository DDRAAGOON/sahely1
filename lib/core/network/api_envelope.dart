import 'package:sahely/core/errors/exceptions.dart';

/// Unwraps the backend's `{ success, data }` response envelope.
///
/// Throws [ServerException] when the call reports failure so repositories can
/// map it like any other network error.
dynamic unwrapData(dynamic body) {
  if (body is Map<String, dynamic>) {
    if (body.containsKey('success') && body.containsKey('data')) {
      if (body['success'] != true) {
        throw ServerException(
          '${(body['error'] is Map ? body['error']['message'] : null) ?? body['message'] ?? 'Request failed'}',
        );
      }
      return body['data'];
    }
  }
  return body;
}

/// Coerce to a mutable string-keyed map.
Map<String, dynamic> asMap(dynamic v) =>
    v is Map ? Map<String, dynamic>.from(v) : <String, dynamic>{};

/// Coerce to a list of mutable string-keyed maps.
List<Map<String, dynamic>> asListOfMaps(dynamic v) {
  if (v is List) {
    return v.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
  }
  return const [];
}
