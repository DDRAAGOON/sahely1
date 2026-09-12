enum ImageCachePolicy {
  /// Default policy: check memory, then disk, then network.
  standard,

  /// Force fetch from network, bypass cache.
  refresh,

  /// Only use memory cache.
  memoryOnly,

  /// Only use disk cache.
  diskOnly,
}
