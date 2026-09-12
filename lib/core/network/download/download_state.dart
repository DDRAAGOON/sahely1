import 'package:equatable/equatable.dart';
import 'download_status.dart';
import 'download_failure.dart';

class DownloadState extends Equatable {
  final String downloadId;
  final DownloadStatus status;
  final double progress; // 0.0 to 1.0
  final DownloadFailure? failure;
  final String? destinationPath;

  const DownloadState({
    required this.downloadId,
    this.status = DownloadStatus.idle,
    this.progress = 0.0,
    this.failure,
    this.destinationPath,
  });

  DownloadState copyWith({
    DownloadStatus? status,
    double? progress,
    DownloadFailure? failure,
    String? destinationPath,
  }) {
    return DownloadState(
      downloadId: downloadId,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      failure: failure ?? this.failure,
      destinationPath: destinationPath ?? this.destinationPath,
    );
  }

  @override
  List<Object?> get props =>
      [downloadId, status, progress, failure, destinationPath];
}
