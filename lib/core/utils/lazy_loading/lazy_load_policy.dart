enum LazyLoadPolicy {
  /// Start loading immediately upon initialization.
  immediate,

  /// Wait for an explicit call to load().
  deferred,

  /// Automatically retry loading if it fails.
  autoRetry,

  /// Reload data periodically (can be extended with Duration).
  periodic,
}
