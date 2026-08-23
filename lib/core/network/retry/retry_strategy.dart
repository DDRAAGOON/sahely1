import 'dart:math' as math;

abstract class RetryStrategy {
  Duration getDelay(int attempt);
}

class FixedDelayStrategy implements RetryStrategy {
  final Duration delay;
  const FixedDelayStrategy({this.delay = const Duration(seconds: 2)});

  @override
  Duration getDelay(int attempt) => delay;
}

class LinearBackoffStrategy implements RetryStrategy {
  final Duration baseDelay;
  const LinearBackoffStrategy({this.baseDelay = const Duration(seconds: 1)});

  @override
  Duration getDelay(int attempt) => baseDelay * attempt;
}

class ExponentialBackoffStrategy implements RetryStrategy {
  final Duration baseDelay;
  final double factor;
  final Duration maxDelay;

  const ExponentialBackoffStrategy({
    this.baseDelay = const Duration(seconds: 1),
    this.factor = 2.0,
    this.maxDelay = const Duration(seconds: 30),
  });

  @override
  Duration getDelay(int attempt) {
    final delayMs = baseDelay.inMilliseconds * math.pow(factor, attempt - 1);
    final delay = Duration(milliseconds: delayMs.toInt());
    return delay > maxDelay ? maxDelay : delay;
  }
}
