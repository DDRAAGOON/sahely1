enum UploadStatus {
  idle,
  queued,
  uploading,
  paused,
  success,
  error,
  cancelled,
}

extension UploadStatusX on UploadStatus {
  bool get isIdle => this == UploadStatus.idle;
  bool get isQueued => this == UploadStatus.queued;
  bool get isUploading => this == UploadStatus.uploading;
  bool get isPaused => this == UploadStatus.paused;
  bool get isSuccess => this == UploadStatus.success;
  bool get isError => this == UploadStatus.error;
  bool get isCancelled => this == UploadStatus.cancelled;
  bool get isFinished => isSuccess || isError || isCancelled;
}
