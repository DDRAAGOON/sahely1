import 'package:flutter/painting.dart';
import 'image_cache_policy.dart';

abstract class ImageCacheService {
  /// Gets an [ImageProvider] for the given URL.
  ImageProvider getProvider(String url, {ImageCachePolicy policy = ImageCachePolicy.standard});

  /// Prefetches the image from the given URL.
  Future<void> prefetch(String url);

  /// Clears the cache for a specific URL.
  Future<void> clear(String url);

  /// Clears all cached images.
  Future<void> clearAll();
}
