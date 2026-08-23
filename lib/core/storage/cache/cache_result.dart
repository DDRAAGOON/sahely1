import '../../errors/failures.dart';

class CacheResult<T> {
  final T? data;
  final CacheFailure? failure;
  final bool isFromCache;

  const CacheResult._({this.data, this.failure, this.isFromCache = false});

  factory CacheResult.success(T data, {bool isFromCache = false}) =>
      CacheResult._(data: data, isFromCache: isFromCache);

  factory CacheResult.failure(CacheFailure failure) => CacheResult._(failure: failure);

  bool get isSuccess => failure == null;
}
