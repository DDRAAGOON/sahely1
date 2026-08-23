import 'package:equatable/equatable.dart';
import 'upload_status.dart';
import 'upload_failure.dart';

class UploadState extends Equatable {
  final String uploadId;
  final UploadStatus status;
  final double progress; // 0.0 to 1.0
  final UploadFailure? failure;
  final String? resultUrl;

  const UploadState({
    required this.uploadId,
    this.status = UploadStatus.idle,
    this.progress = 0.0,
    this.failure,
    this.resultUrl,
  });

  UploadState copyWith({
    UploadStatus? status,
    double? progress,
    UploadFailure? failure,
    String? resultUrl,
  }) {
    return UploadState(
      uploadId: uploadId,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      failure: failure ?? this.failure,
      resultUrl: resultUrl ?? this.resultUrl,
    );
  }

  @override
  List<Object?> get props => [uploadId, status, progress, failure, resultUrl];
}
