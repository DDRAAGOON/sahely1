import 'dart:async';
import 'infinite_scroll_state.dart';
import 'infinite_scroll_status.dart';
import 'infinite_scroll_request.dart';
import 'infinite_scroll_result.dart';
import 'infinite_scroll_policy.dart';

typedef InfiniteScrollTask<T> = Future<InfiniteScrollResult<T>> Function(InfiniteScrollRequest request);

class InfiniteScrollController<T> {
  final InfiniteScrollTask<T> _task;
  final int _pageSize;
  final InfiniteScrollPolicy _policy;
  final Map<String, dynamic>? _initialParams;
  
  // Forwarded to Lazy Loading infrastructure if needed
  final Duration? _timeout;
  final int _maxRetries;
  final Duration _retryInterval;

  final _stateController = StreamController<InfiniteScrollState<T>>.broadcast();
  InfiniteScrollState<T> _state = const InfiniteScrollState();
  Future<void>? _activeFuture;
  bool _isDisposed = false;

  InfiniteScrollController({
    required InfiniteScrollTask<T> task,
    int pageSize = 10,
    InfiniteScrollPolicy policy = InfiniteScrollPolicy.automatic,
    Map<String, dynamic>? initialParams,
    Duration? timeout,
    int maxRetries = 3,
    Duration retryInterval = const Duration(seconds: 2),
  })  : _task = task,
        _pageSize = pageSize,
        _policy = policy,
        _initialParams = initialParams,
        _timeout = timeout,
        _maxRetries = maxRetries,
        _retryInterval = retryInterval;

  Stream<InfiniteScrollState<T>> get stateStream => _stateController.stream;
  InfiniteScrollState<T> get state => _state;

  InfiniteScrollPolicy get policy => _policy;

  void _updateState(InfiniteScrollState<T> newState) {
    if (_isDisposed) return;
    _state = newState;
    if (!_stateController.isClosed) {
      _stateController.add(newState);
    }
  }

  Future<void> init() async {
    if (_state.status != InfiniteScrollStatus.idle) return;
    return loadInitial();
  }

  Future<void> loadInitial() async {
    if (_state.status.isLoading) return _activeFuture;
    
    _updateState(_state.copyWith(
      status: InfiniteScrollStatus.loadingInitial,
      errorMessage: null,
    ));
    
    _activeFuture = _fetchPage(1, forceRefresh: true);
    return _activeFuture;
  }

  Future<void> loadNextPage() async {
    if (_state.status.isLoading || !_state.hasNext) return _activeFuture;
    
    _updateState(_state.copyWith(
      status: InfiniteScrollStatus.loadingNextPage,
      errorMessage: null,
    ));
    
    _activeFuture = _fetchPage(_state.currentPage + 1);
    return _activeFuture;
  }

  Future<void> refresh() async {
    if (_state.status.isLoading) return _activeFuture;
    
    _updateState(_state.copyWith(
      status: InfiniteScrollStatus.refreshing,
      errorMessage: null,
    ));
    
    _activeFuture = _fetchPage(1, forceRefresh: true);
    return _activeFuture;
  }

  Future<void> retry() async {
    if (_state.status != InfiniteScrollStatus.error) return;
    
    if (_state.currentPage == 0) {
      return loadInitial();
    } else {
      return loadNextPage();
    }
  }

  Future<void> _fetchPage(int page, {bool forceRefresh = false}) async {
    try {
      final request = InfiniteScrollRequest(
        page: page,
        pageSize: _pageSize,
        params: _initialParams,
      );
      
      // We could use LazyLoadController here if we wanted to reuse its retry/timeout logic
      // But for infinite scroll, we often want specific control over the result merging.
      
      final result = await _runWithRetry(() => _task(request));
      
      final List<T> newItems = forceRefresh 
          ? result.items 
          : [..._state.items, ...result.items];
          
      _updateState(_state.copyWith(
        status: newItems.isEmpty ? InfiniteScrollStatus.empty : InfiniteScrollStatus.success,
        items: newItems,
        currentPage: result.page,
        totalItems: result.totalItems,
        totalPages: result.totalPages,
        hasNext: result.hasNext,
        errorMessage: null,
      ));
    } catch (e) {
      _updateState(_state.copyWith(
        status: InfiniteScrollStatus.error,
        errorMessage: e.toString(),
      ));
    } finally {
      _activeFuture = null;
    }
  }

  Future<InfiniteScrollResult<T>> _runWithRetry(Future<InfiniteScrollResult<T>> Function() task) async {
    int attempts = 0;
    while (true) {
      try {
        final timeout = _timeout;
        if (timeout != null) {
          return await task().timeout(timeout);
        }
        return await task();
      } catch (e) {
        attempts++;
        if (attempts > _maxRetries || _isDisposed) rethrow;
        await Future.delayed(_retryInterval);
      }
    }
  }

  void reset() {
    _activeFuture = null;
    _updateState(const InfiniteScrollState());
  }

  void cancel() {
    _activeFuture = null;
    if (_state.status.isLoading) {
      _updateState(_state.copyWith(status: InfiniteScrollStatus.idle));
    }
  }

  void restore(InfiniteScrollState<T> state) {
    _updateState(state);
  }

  void appendItems(List<T> items, {bool hasNext = true}) {
    final newItems = [..._state.items, ...items];
    _updateState(_state.copyWith(
      items: newItems,
      hasNext: hasNext,
      status: newItems.isEmpty ? InfiniteScrollStatus.empty : InfiniteScrollStatus.success,
    ));
  }

  void replaceItems(List<T> items, {bool hasNext = true}) {
    _updateState(_state.copyWith(
      items: items,
      currentPage: 1,
      hasNext: hasNext,
      status: items.isEmpty ? InfiniteScrollStatus.empty : InfiniteScrollStatus.success,
    ));
  }

  void dispose() {
    _isDisposed = true;
    _stateController.close();
  }
}
