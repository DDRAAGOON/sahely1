enum LazyLoadStatus {
  idle,
  loading,
  loaded,
  error,
  cancelled,
  refreshing,
}

class LazyLoadState<T> {
  final LazyLoadStatus status;
  final T? data;
  final String? errorMessage;

  const LazyLoadState._({
    required this.status,
    this.data,
    this.errorMessage,
  });

  factory LazyLoadState.idle() =>
      const LazyLoadState._(status: LazyLoadStatus.idle);

  factory LazyLoadState.loading() =>
      const LazyLoadState._(status: LazyLoadStatus.loading);

  factory LazyLoadState.loaded(T data) => LazyLoadState._(
        status: LazyLoadStatus.loaded,
        data: data,
      );

  factory LazyLoadState.error(String message) => LazyLoadState._(
        status: LazyLoadStatus.error,
        errorMessage: message,
      );

  factory LazyLoadState.cancelled() =>
      const LazyLoadState._(status: LazyLoadStatus.cancelled);

  factory LazyLoadState.refreshing(T? oldData) => LazyLoadState._(
        status: LazyLoadStatus.refreshing,
        data: oldData,
      );

  bool get isIdle => status == LazyLoadStatus.idle;
  bool get isLoading => status == LazyLoadStatus.loading;
  bool get isLoaded => status == LazyLoadStatus.loaded;
  bool get isError => status == LazyLoadStatus.error;
  bool get isCancelled => status == LazyLoadStatus.cancelled;
  bool get isRefreshing => status == LazyLoadStatus.refreshing;
}
