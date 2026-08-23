class UploadPolicy {
  final int maxRetries;
  final bool autoRetry;
  final bool allowMobileData;
  final int concurrencyLimit;

  const UploadPolicy({
    this.maxRetries = 3,
    this.autoRetry = false,
    this.allowMobileData = true,
    this.concurrencyLimit = 2,
  });

  static const defaultPolicy = UploadPolicy();
}
