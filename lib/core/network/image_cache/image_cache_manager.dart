import 'package:flutter/painting.dart';
import 'image_cache_service.dart';
import 'image_cache_policy.dart';

class ImageCacheManager {
  final ImageCacheService _service;

  ImageCacheManager(this._service);

  ImageProvider getProvider(String url, {ImageCachePolicy policy = ImageCachePolicy.standard}) {
    return _service.getProvider(url, policy: policy);
  }

  Future<void> prefetch(String url) => _service.prefetch(url);

  Future<void> clear(String url) => _service.clear(url);

  Future<void> clearAll() => _service.clearAll();
}
