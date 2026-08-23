import 'lazy_load_controller.dart';
import 'lazy_load_policy.dart';

class LazyLoader<T> {
  final LazyLoadController<T> _controller;

  LazyLoader({
    required LazyLoaderTask<T> task,
    LazyLoadPolicy policy = LazyLoadPolicy.deferred,
    Duration? timeout,
    int maxRetries = 3,
    Duration retryInterval = const Duration(seconds: 2),
    Duration? periodicInterval,
  }) : _controller = LazyLoadController<T>(
          task: task,
          policy: policy,
          timeout: timeout,
          maxRetries: maxRetries,
          retryInterval: retryInterval,
          periodicInterval: periodicInterval,
        );

  Future<T?> get value => _controller.load();

  LazyLoadController<T> get controller => _controller;

  Future<T?> refresh() => _controller.load(forceRefresh: true);
  
  void cancel() => _controller.cancel();
  
  void reset() => _controller.reset();

  void dispose() => _controller.dispose();
}
