enum InfiniteScrollStatus {
  idle,
  loadingInitial,
  loadingNextPage,
  success,
  error,
  refreshing,
  empty,
}

extension InfiniteScrollStatusX on InfiniteScrollStatus {
  bool get isIdle => this == InfiniteScrollStatus.idle;
  bool get isLoadingInitial => this == InfiniteScrollStatus.loadingInitial;
  bool get isLoadingNextPage => this == InfiniteScrollStatus.loadingNextPage;
  bool get isSuccess => this == InfiniteScrollStatus.success;
  bool get isError => this == InfiniteScrollStatus.error;
  bool get isRefreshing => this == InfiniteScrollStatus.refreshing;
  bool get isEmpty => this == InfiniteScrollStatus.empty;
  bool get isLoading => isLoadingInitial || isLoadingNextPage || isRefreshing;
}
