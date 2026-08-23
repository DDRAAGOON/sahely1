enum CachePolicy {
  /// Always fetch from remote, never save to cache.
  noCache,

  /// Read from cache if available and not expired, otherwise fetch from remote and save to cache.
  cacheFirst,

  /// Always fetch from remote and save to cache. Only read from cache if remote fails.
  remoteFirst,

  /// Read from cache only. Never fetch from remote.
  cacheOnly,

  /// Read from cache, then fetch from remote and update cache. Returns two results (via Stream or multiple calls).
  cacheAndRemote,
}
