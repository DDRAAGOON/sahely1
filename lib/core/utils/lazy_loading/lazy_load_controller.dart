import 'dart:async';
import 'dart:math' as math;
import 'lazy_load_state.dart';
import 'lazy_load_policy.dart';
import 'lazy_load_failure.dart';

typedef LazyLoaderTask<T> = Future<T> Function();

class LazyLoadController<T> {
  final LazyLoaderTask<T> _task;
  final LazyLoadPolicy _policy;
  final Duration? _timeout;
  final int _maxRetries;
  final Duration _retryInterval;
  final Duration? _periodicInterval;

  Timer? _periodicTimer;
  Timer? _retryTimer;
  int _retryCount = 0;
  bool _isDisposed = false;

  LazyLoadController({
    required LazyLoaderTask<T> task,
    LazyLoadPolicy policy = LazyLoadPolicy.deferred,
    Duration? timeout,
    int maxRetries = 3,
    Duration retryInterval = const Duration(seconds: 2),
    Duration? periodicInterval,
  })  : _task = task,
        _policy = policy,
        _timeout = timeout,
        _maxRetries = maxRetries,
        _retryInterval = retryInterval,
        _periodicInterval = periodicInterval {
    if (_policy == LazyLoadPolicy.immediate) {
      load();
    }
    if (_policy == LazyLoadPolicy.periodic && _periodicInterval != null) {
      _startPeriodicTask();
    }
  }

  final _stateController = StreamController<LazyLoadState<T>>.broadcast();
  LazyLoadState<T> _state = LazyLoadState<T>.idle();
  Future<T>? _activeFuture;

  Stream<LazyLoadState<T>> get stateStream => _stateController.stream;
  LazyLoadState<T> get state => _state;

  void _updateState(LazyLoadState<T> newState) {
    if (_isDisposed) return;
    _state = newState;
    if (!_stateController.isClosed) {
      _stateController.add(newState);
    }
  }

  Future<T?> load({bool forceRefresh = false}) async {
    if (_isDisposed) return null;

    // Prevent concurrent loading unless it's a refresh
    if (_state.isLoading && !forceRefresh) {
      return _activeFuture;
    }

    if (_state.isLoaded && !forceRefresh) {
      return _state.data;
    }

    final isRefresh = _state.isLoaded || _state.isRefreshing;
    _updateState(isRefresh
        ? LazyLoadState<T>.refreshing(_state.data)
        : LazyLoadState<T>.loading());

    _activeFuture = _runTask();

    try {
      final result = await _activeFuture!;
      _retryCount = 0;
      _updateState(LazyLoadState<T>.loaded(result));
      return result;
    } catch (e) {
      _updateState(LazyLoadState<T>.error(e.toString()));
      if (_policy == LazyLoadPolicy.autoRetry && _retryCount < _maxRetries) {
        _scheduleRetry();
      }
      rethrow;
    } finally {
      _activeFuture = null;
    }
  }

  void _scheduleRetry() {
    _retryTimer?.cancel();
    _retryCount++;

    // Exponential backoff
    final backoff = Duration(
      milliseconds:
          (_retryInterval.inMilliseconds * math.pow(2, _retryCount - 1))
              .toInt(),
    );

    _retryTimer = Timer(backoff, () {
      if (!_isDisposed) {
        load()
            .catchError((_) => null); // Silently handle background retry errors
      }
    });
  }

  void _startPeriodicTask() {
    _periodicTimer?.cancel();
    _periodicTimer = Timer.periodic(_periodicInterval!, (timer) {
      if (!_isDisposed && !_state.isLoading && !_state.isRefreshing) {
        load(forceRefresh: true).catchError((_) => null);
      }
    });
  }

  Future<T> _runTask() {
    final timeout = _timeout;
    if (timeout != null) {
      return _task().timeout(timeout, onTimeout: () {
        throw const LazyLoadException('Loading timed out');
      });
    }
    return _task();
  }

  void cancel() {
    _retryTimer?.cancel();
    if (_state.isLoading || _state.isRefreshing) {
      _updateState(LazyLoadState<T>.cancelled());
      _activeFuture = null;
    }
  }

  void reset() {
    cancel();
    _retryCount = 0;
    _updateState(LazyLoadState<T>.idle());
  }

  void dispose() {
    _isDisposed = true;
    _periodicTimer?.cancel();
    _retryTimer?.cancel();
    _stateController.close();
  }
}
