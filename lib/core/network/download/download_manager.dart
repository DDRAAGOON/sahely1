import 'dart:async';
import 'download_task.dart';
import 'download_state.dart';
import 'download_status.dart';
import 'download_policy.dart';

class DownloadManager {
  final Map<String, DownloadTask> _tasks = {};
  final List<String> _queue = [];
  final DownloadPolicy _policy;
  
  int _activeDownloads = 0;

  final _globalStateController = StreamController<Map<String, DownloadState>>.broadcast();

  DownloadManager({DownloadPolicy policy = DownloadPolicy.defaultPolicy}) : _policy = policy;

  Stream<Map<String, DownloadState>> get globalStateStream => _globalStateController.stream;
  
  Map<String, DownloadState> get currentStates => 
      _tasks.map((key, task) => MapEntry(key, task.state));

  void addTask(DownloadTask task) {
    if (_tasks.containsKey(task.id)) return;

    _tasks[task.id] = task;
    _queue.add(task.id);
    
    task.stateStream.listen((state) {
      _notifyGlobal();
      if (state.status.isFinished) {
        _activeDownloads--;
        _processQueue();
      }
    });

    _processQueue();
  }

  void _processQueue() {
    if (_activeDownloads >= _policy.concurrencyLimit) return;
    if (_queue.isEmpty) return;

    final id = _queue.removeAt(0);
    final task = _tasks[id];

    if (task != null) {
      _activeDownloads++;
      task.start();
    }
  }

  void pauseDownload(String downloadId) {
    _tasks[downloadId]?.pause();
  }

  void resumeDownload(String downloadId) {
    _tasks[downloadId]?.resume();
  }

  void cancelDownload(String downloadId) {
    _tasks[downloadId]?.cancel();
    _queue.remove(downloadId);
  }

  void retryDownload(String downloadId) {
    final task = _tasks[downloadId];
    if (task != null && task.state.status.isError) {
      _queue.add(downloadId);
      _processQueue();
    }
  }

  void _notifyGlobal() {
    if (!_globalStateController.isClosed) {
      _globalStateController.add(currentStates);
    }
  }

  void dispose() {
    for (final task in _tasks.values) {
      task.dispose();
    }
    _globalStateController.close();
  }
}
