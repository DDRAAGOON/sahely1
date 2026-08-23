import 'retry_strategy.dart';
import 'retry_decision.dart';

typedef RetryEvaluator = RetryDecision Function(dynamic error, int attempt);

class RetryPolicy {
  final int maxRetries;
  final RetryStrategy strategy;
  final RetryEvaluator evaluator;
  final Duration? timeout;

  const RetryPolicy({
    this.maxRetries = 3,
    this.strategy = const ExponentialBackoffStrategy(),
    required this.evaluator,
    this.timeout,
  });

  factory RetryPolicy.always({
    int maxRetries = 3,
    RetryStrategy strategy = const ExponentialBackoffStrategy(),
  }) {
    return RetryPolicy(
      maxRetries: maxRetries,
      strategy: strategy,
      evaluator: (error, attempt) => RetryDecision.retry,
    );
  }
}
