enum DownloadStatus {
  idle,
  queued,
  downloading,
  paused,
  success,
  error,
  cancelled,
}

extension DownloadStatusX on DownloadStatus {
  bool get isIdle => this == DownloadStatus.idle;
  bool get isQueued => this == DownloadStatus.queued;
  bool get isDownloading => this == DownloadStatus.downloading;
  bool get isPaused => this == DownloadStatus.paused;
  bool get isSuccess => this == DownloadStatus.success;
  bool get isError => this == DownloadStatus.error;
  bool get isCancelled => this == DownloadStatus.cancelled;
  bool get isFinished => isSuccess || isError || isCancelled;
}
