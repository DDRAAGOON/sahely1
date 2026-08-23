import 'dart:async';
import 'download_state.dart';
import 'download_status.dart';
import 'download_failure.dart';

typedef FileDownloader = Future<void> Function(
  String downloadId,
  String url,
  String destination,
  void Function(double progress) onProgress,
  DownloadCancellationToken cancellationToken,
);

class DownloadCancellationToken {
  bool _isCancelled = false;
  bool get isCancelled => _isCancelled;
  void cancel() => _isCancelled = true;
}

class DownloadTask {
  final String id;
  final String url;
  final String destination;
  final FileDownloader downloader;

  final _stateController = StreamController<DownloadState>.broadcast();
  DownloadState _state;
  DownloadCancellationToken? _cancellationToken;

  DownloadTask({
    required this.id,
    required this.url,
    required this.destination,
    required this.downloader,
  }) : _state = DownloadState(downloadId: id, destinationPath: destination);

  Stream<DownloadState> get stateStream => _stateController.stream;
  DownloadState get state => _state;

  void _updateState(DownloadState newState) {
    _state = newState;
    if (!_stateController.isClosed) {
      _stateController.add(newState);
    }
  }

  Future<void> start() async {
    if (_state.status.isDownloading || _state.status.isSuccess) return;

    _cancellationToken = DownloadCancellationToken();
    _updateState(_state.copyWith(status: DownloadStatus.downloading, failure: null));

    try {
      await downloader(
        id,
        url,
        destination,
        (progress) {
          if (!_cancellationToken!.isCancelled) {
            _updateState(_state.copyWith(progress: progress));
          }
        },
        _cancellationToken!,
      );

      if (_cancellationToken!.isCancelled) {
        _updateState(_state.copyWith(status: DownloadStatus.cancelled));
      } else {
        _updateState(_state.copyWith(
          status: DownloadStatus.success,
          progress: 1.0,
        ));
      }
    } catch (e) {
      if (_cancellationToken!.isCancelled) {
        _updateState(_state.copyWith(status: DownloadStatus.cancelled));
      } else {
        _updateState(_state.copyWith(
          status: DownloadStatus.error,
          failure: DownloadFailure(e.toString(), originalError: e),
        ));
      }
    }
  }

  void pause() {
    if (_state.status.isDownloading) {
      _updateState(_state.copyWith(status: DownloadStatus.paused));
    }
  }

  void resume() {
    if (_state.status.isPaused) {
      start();
    }
  }

  void cancel() {
    _cancellationToken?.cancel();
    _updateState(_state.copyWith(status: DownloadStatus.cancelled));
  }

  void dispose() {
    _stateController.close();
  }
}
