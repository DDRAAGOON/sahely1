import 'package:flutter/material.dart';
import 'package:sahely/core/di/service_locator.dart';
import 'image_cache_manager.dart';
import 'image_cache_policy.dart';

class CachedImageProvider extends ImageProvider<CachedImageProvider> {
  final String url;
  final ImageCachePolicy policy;

  CachedImageProvider(this.url, {this.policy = ImageCachePolicy.standard});

  @override
  ImageStreamCompleter loadImage(CachedImageProvider key, ImageDecoderCallback decode) {
    final manager = sl<ImageCacheManager>();
    final provider = manager.getProvider(url, policy: policy);
    return provider.loadImage(provider as dynamic, decode);
  }

  @override
  Future<CachedImageProvider> obtainKey(ImageConfiguration configuration) {
    return Future.value(this);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CachedImageProvider && other.url == url && other.policy == policy;
  }

  @override
  int get hashCode => Object.hash(url, policy);
}
