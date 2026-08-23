import 'dart:async';
import 'retry_policy.dart';
import 'retry_decision.dart';
import 'retry_failure.dart';

typedef RetryCallback<T> = Future<T> Function();
typedef OnRetryListener = void Function(int attempt, dynamic error, Duration delay);

class RetryCancellationToken {
  bool _isCancelled = false;
  bool get isCancelled => _isCancelled;

  void cancel() {
    _isCancelled = true;
  }
}

class RetryManager {
  final List<OnRetryListener> _globalListeners = [];

  void addGlobalListener(OnRetryListener listener) {
    _globalListeners.add(listener);
  }

  void removeGlobalListener(OnRetryListener listener) {
    _globalListeners.remove(listener);
  }

  Future<T> run<T>({
    required RetryCallback<T> task,
    required RetryPolicy policy,
    RetryCancellationToken? cancellationToken,
    OnRetryListener? onRetry,
  }) async {
    int attempt = 0;

    while (true) {
      try {
        if (cancellationToken?.isCancelled ?? false) {
          throw const RetryException('Retry task was cancelled');
        }

        if (policy.timeout != null) {
          return await task().timeout(policy.timeout!);
        } else {
          return await task();
        }
      } catch (e) {
        if (e is TimeoutException) {
          // Handle timeout specifically as a retryable error if needed
        }

        if (cancellationToken?.isCancelled ?? false) {
          throw RetryException('Retry task was cancelled', originalError: e);
        }

        attempt++;

        final decision = policy.evaluator(e, attempt);

        if (attempt > policy.maxRetries || decision == RetryDecision.stop) {
          rethrow;
        }

        if (decision == RetryDecision.cancel) {
          throw RetryException('Retry task was cancelled by policy', originalError: e);
        }

        final delay = policy.strategy.getDelay(attempt);

        // Notify local listener
        onRetry?.call(attempt, e, delay);

        // Notify global listeners
        for (final listener in _globalListeners) {
          listener(attempt, e, delay);
        }

        await Future.delayed(delay);
      }
    }
  }
}
