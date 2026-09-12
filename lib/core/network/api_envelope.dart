import 'package:sahely/core/errors/api_error.dart';
import 'package:sahely/core/errors/exceptions.dart';

/// Unwraps the backend response envelope `{ "success": true, "data": <payload> }`.
///
/// On success it returns the `data` payload; on `success: false` it throws a
/// [ServerException] carrying the machine-readable `error.code` and `error.field`
/// so callers can branch on the code and highlight the offending input.
dynamic unwrapData(dynamic body) {
  if (body is Map) {
    final map = Map<String, dynamic>.from(body);
    if (map.containsKey('success')) {
      if (map['success'] != true) {
        final apiError = ApiError.tryParse(map);
        throw ServerException(
          apiError?.message ?? '${map['message'] ?? 'Request failed'}',
          code: apiError?.code,
          field: apiError?.field,
        );
      }
      return map['data'];
    }
  }
  // Endpoints that answer with a bare payload (or a raw list) pass through.
  return body;
}

/// Coerce a payload to a mutable string-keyed map.
Map<String, dynamic> asMap(dynamic value) =>
    value is Map ? Map<String, dynamic>.from(value) : <String, dynamic>{};

/// Coerce a payload to a list of mutable string-keyed maps.
///
/// Accepts both a bare list and the paginated shape `{ items: [...] }` (also
/// `data` / `results` / `rows`, which different modules use).
List<Map<String, dynamic>> asListOfMaps(dynamic value) {
  final list = _extractList(value);
  if (list == null) return const [];
  return list
      .whereType<Map>()
      .map((e) => Map<String, dynamic>.from(e))
      .toList();
}

/// Coerce a payload to a list of strings.
List<String> asStringList(dynamic value) {
  final list = _extractList(value);
  if (list == null) return const [];
  return list.map((e) => '$e').toList();
}

List<dynamic>? _extractList(dynamic value) {
  if (value is List) return value;
  if (value is! Map) return null;

  // Common wrapper keys first.
  for (final key in const ['items', 'data', 'results', 'rows']) {
    final nested = value[key];
    if (nested is List) return nested;
  }

  // The backend also nests rows under a module-specific name -
  // `commissions`, `windows`, `perks`, `levels`, `pending`, `properties`,
  // `bookings`, `upcoming_renters`, ... Rather than chase every name, take the
  // sole list in the object. Only when it is unambiguous: if the payload holds
  // several lists it is a composite object, not a page of rows, and guessing
  // would silently pick the wrong one.
  final lists = value.values.whereType<List>().toList();
  if (lists.length == 1) return lists.first;

  return null;
}

/// Parse a numeric field that the backend may send as `num` or `String`.
num? asNum(dynamic value) {
  if (value is num) return value;
  if (value is String) return num.tryParse(value);
  return null;
}

/// Parse an ISO-8601 timestamp defensively.
DateTime? asDate(dynamic value) {
  if (value is DateTime) return value;
  if (value is String && value.isNotEmpty) return DateTime.tryParse(value);
  return null;
}

/// Reads a field that may be spelled either way.
///
/// The API guide documents JSON as snake_case, but the deployed backend
/// serialises its entities camelCase (`basePricePerNight`, `maxGuests`, ...).
/// Request bodies really are snake_case, so only *responses* need this.
/// Looking both up costs nothing and survives either serialisation.
dynamic pick(Map<String, dynamic> json, String snakeKey) {
  final direct = json[snakeKey];
  if (direct != null) return direct;
  return json[_camel(snakeKey)];
}

/// `base_price_per_night` -> `basePricePerNight`
String _camel(String snakeKey) {
  final parts = snakeKey.split('_');
  if (parts.length == 1) return snakeKey;
  return parts.first +
      parts
          .skip(1)
          .map((p) => p.isEmpty ? p : p[0].toUpperCase() + p.substring(1))
          .join();
}

/// Pagination metadata attached to list responses.
class PaginationMeta {
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  const PaginationMeta({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  bool get hasNextPage => page < totalPages;

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    final page = asNum(json['page'])?.toInt() ?? 1;
    final limit = asNum(json['limit'])?.toInt() ?? 20;
    final total = asNum(json['total'])?.toInt() ?? 0;
    final totalPages = asNum(pick(json, 'total_pages'))?.toInt() ??
        (limit > 0 ? (total + limit - 1) ~/ limit : 1);
    return PaginationMeta(
      page: page,
      limit: limit,
      total: total,
      totalPages: totalPages,
    );
  }
}

/// Extract pagination metadata from a payload, or `null` when absent.
///
/// The backend returns the counters *flat*, next to the rows:
/// `{ data: [...], total, page, limit, totalPages, hasNextPage }`.
/// A nested `meta`/`pagination` object is also accepted.
PaginationMeta? extractPagination(dynamic payload) {
  if (payload is! Map) return null;
  final map = Map<String, dynamic>.from(payload);

  final nested = map['meta'] ?? map['pagination'];
  if (nested is Map) {
    return PaginationMeta.fromJson(Map<String, dynamic>.from(nested));
  }

  if (map.containsKey('page') && map.containsKey('limit')) {
    return PaginationMeta.fromJson(map);
  }
  return null;
}

/// A page of already-parsed items plus its pagination metadata.
class Paginated<T> {
  final List<T> items;
  final PaginationMeta? meta;

  const Paginated(this.items, [this.meta]);

  bool get hasNextPage => meta?.hasNextPage ?? false;
}

/// Build the `?page=&limit=` query every list endpoint accepts.
Map<String, dynamic> pageQuery({
  int page = 1,
  int limit = 20,
  Map<String, dynamic>? extra,
}) {
  return <String, dynamic>{
    'page': page < 1 ? 1 : page,
    'limit': limit.clamp(1, 100),
    if (extra != null)
      ...Map<String, dynamic>.fromEntries(
        extra.entries.where((e) => e.value != null),
      ),
  };
}
