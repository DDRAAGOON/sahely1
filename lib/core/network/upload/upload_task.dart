import 'dart:async';
import 'upload_state.dart';
import 'upload_status.dart';
import 'upload_failure.dart';

typedef FileUploader = Future<String> Function(
  String uploadId,
  void Function(double progress) onProgress,
  CancellationToken cancellationToken,
);

class CancellationToken {
  bool _isCancelled = false;
  bool get isCancelled => _isCancelled;
  void cancel() => _isCancelled = true;
}

class UploadTask {
  final String id;
  final dynamic fileData; // Generic file type (File, XFile, bytes, etc.)
  final Map<String, String>? metadata;
  final FileUploader uploader;

  final _stateController = StreamController<UploadState>.broadcast();
  UploadState _state;
  CancellationToken? _cancellationToken;

  UploadTask({
    required this.id,
    required this.fileData,
    required this.uploader,
    this.metadata,
  }) : _state = UploadState(uploadId: id);

  Stream<UploadState> get stateStream => _stateController.stream;
  UploadState get state => _state;

  void _updateState(UploadState newState) {
    _state = newState;
    if (!_stateController.isClosed) {
      _stateController.add(newState);
    }
  }

  Future<void> start() async {
    if (_state.status.isUploading || _state.status.isSuccess) return;

    _cancellationToken = CancellationToken();
    _updateState(
        _state.copyWith(status: UploadStatus.uploading, failure: null));

    try {
      final url = await uploader(
        id,
        (progress) {
          if (!_cancellationToken!.isCancelled) {
            _updateState(_state.copyWith(progress: progress));
          }
        },
        _cancellationToken!,
      );

      if (_cancellationToken!.isCancelled) {
        _updateState(_state.copyWith(status: UploadStatus.cancelled));
      } else {
        _updateState(_state.copyWith(
          status: UploadStatus.success,
          progress: 1.0,
          resultUrl: url,
        ));
      }
    } catch (e) {
      if (_cancellationToken!.isCancelled) {
        _updateState(_state.copyWith(status: UploadStatus.cancelled));
      } else {
        _updateState(_state.copyWith(
          status: UploadStatus.error,
          failure: UploadFailure(e.toString(), originalError: e),
        ));
      }
    }
  }

  void pause() {
    if (_state.status.isUploading) {
      // Pause implementation depends on the underlying network library
      // For now, we update status.
      _updateState(_state.copyWith(status: UploadStatus.paused));
    }
  }

  void resume() {
    if (_state.status.isPaused) {
      start();
    }
  }

  void cancel() {
    _cancellationToken?.cancel();
    _updateState(_state.copyWith(status: UploadStatus.cancelled));
  }

  void dispose() {
    _stateController.close();
  }
}
