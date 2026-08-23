class CacheEntry<T> {
  final T data;
  final DateTime timestamp;
  final Duration? ttl;
  final String version;

  CacheEntry({
    required this.data,
    required this.timestamp,
    this.ttl,
    this.version = '1.0.0',
  });

  bool get isExpired {
    if (ttl == null) return false;
    return DateTime.now().isAfter(timestamp.add(ttl!));
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) {
    return {
      'data': toJsonT(data),
      'timestamp': timestamp.toIso8601String(),
      'ttl': ttl?.inMilliseconds,
      'version': version,
    };
  }

  factory CacheEntry.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return CacheEntry(
      data: fromJsonT(json['data'] as Map<String, dynamic>),
      timestamp: DateTime.parse(json['timestamp'] as String),
      ttl: json['ttl'] != null ? Duration(milliseconds: json['ttl'] as int) : null,
      version: json['version'] as String? ?? '1.0.0',
    );
  }
}
