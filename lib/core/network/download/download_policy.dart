class DownloadPolicy {
  final int maxRetries;
  final bool autoRetry;
  final int concurrencyLimit;

  const DownloadPolicy({
    this.maxRetries = 3,
    this.autoRetry = false,
    this.concurrencyLimit = 2,
  });

  static const defaultPolicy = DownloadPolicy();
}
