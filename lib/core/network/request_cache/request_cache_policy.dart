enum RequestCachePolicy {
  /// Always fetch from remote, never save to or read from cache.
  noCache,

  /// Read from cache if available and not expired, otherwise fetch from remote and save.
  cacheFirst,

  /// Always fetch from remote and save to cache. Only read from cache if remote fails.
  networkFirst,

  /// Read from cache only. Never fetch from remote.
  cacheOnly,

  /// Fetch from network only. Never read from cache, but may save to cache for future requests.
  networkOnly,

  /// Return cached data immediately, then fetch from network in the background and update cache.
  staleWhileRevalidate,
}
