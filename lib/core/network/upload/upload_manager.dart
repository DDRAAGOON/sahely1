import 'dart:async';
import 'upload_task.dart';
import 'upload_state.dart';
import 'upload_status.dart';
import 'upload_policy.dart';

class UploadManager {
  final Map<String, UploadTask> _tasks = {};
  final List<String> _queue = [];
  final UploadPolicy _policy;
  
  int _activeUploads = 0;

  final _globalStateController = StreamController<Map<String, UploadState>>.broadcast();

  UploadManager({UploadPolicy policy = UploadPolicy.defaultPolicy}) : _policy = policy;

  Stream<Map<String, UploadState>> get globalStateStream => _globalStateController.stream;
  
  Map<String, UploadState> get currentStates => 
      _tasks.map((key, task) => MapEntry(key, task.state));

  void addTask(UploadTask task) {
    if (_tasks.containsKey(task.id)) return;

    _tasks[task.id] = task;
    _queue.add(task.id);
    
    task.stateStream.listen((state) {
      _notifyGlobal();
      if (state.status.isFinished) {
        _activeUploads--;
        _processQueue();
      }
    });

    _processQueue();
  }

  void _processQueue() {
    if (_activeUploads >= _policy.concurrencyLimit) return;
    if (_queue.isEmpty) return;

    final id = _queue.removeAt(0);
    final task = _tasks[id];

    if (task != null) {
      _activeUploads++;
      task.start();
    }
  }

  void pauseUpload(String uploadId) {
    _tasks[uploadId]?.pause();
  }

  void resumeUpload(String uploadId) {
    _tasks[uploadId]?.resume();
  }

  void cancelUpload(String uploadId) {
    _tasks[uploadId]?.cancel();
    _queue.remove(uploadId);
  }

  void retryUpload(String uploadId) {
    final task = _tasks[uploadId];
    if (task != null && task.state.status.isError) {
      _queue.add(uploadId);
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
