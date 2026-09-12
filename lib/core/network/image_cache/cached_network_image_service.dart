import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'image_cache_service.dart';
import 'image_cache_policy.dart';

class CachedNetworkImageService implements ImageCacheService {
  final BaseCacheManager _serviceManager;

  CachedNetworkImageService({BaseCacheManager? cacheManager})
      : _serviceManager = cacheManager ??
            CacheManager(
              Config(
                'sahely_image_cache',
                stalePeriod: const Duration(days: 7),
                maxNrOfCacheObjects: 200,
              ),
            );

  @override
  ImageProvider getProvider(String url,
      {ImageCachePolicy policy = ImageCachePolicy.standard}) {
    return CachedNetworkImageProvider(
      url,
      cacheManager: _serviceManager,
    );
  }

  @override
  Future<void> prefetch(String url) async {
    await _serviceManager.downloadFile(url);
  }

  @override
  Future<void> clear(String url) async {
    await _serviceManager.removeFile(url);
  }

  @override
  Future<void> clearAll() async {
    await _serviceManager.emptyCache();
  }
}
