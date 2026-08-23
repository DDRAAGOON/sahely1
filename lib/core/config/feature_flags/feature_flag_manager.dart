import 'dart:async';
import 'feature_flag.dart';
import 'feature_flag_policy.dart';

abstract class FeatureFlagProvider {
  bool? isEnabled(String key);
  Future<void> init();
}

class FeatureFlagManager {
  final Map<String, bool> _localOverrides = {};
  final List<FeatureFlagProvider> _providers = [];
  FeatureFlagPolicy _policy = FeatureFlagPolicy.localFirst;

  final _updateController = StreamController<String>.broadcast();

  Stream<String> get updates => _updateController.stream;

  void setPolicy(FeatureFlagPolicy policy) {
    _policy = policy;
  }

  void addProvider(FeatureFlagProvider provider) {
    _providers.add(provider);
  }

  void setOverride(String key, bool isEnabled) {
    _localOverrides[key] = isEnabled;
    _updateController.add(key);
  }

  void clearOverride(String key) {
    _localOverrides.remove(key);
    _updateController.add(key);
  }

  bool isEnabled(FeatureFlag flag) {
    switch (_policy) {
      case FeatureFlagPolicy.localOnly:
        return _localOverrides[flag.key] ?? flag.defaultValue;
      
      case FeatureFlagPolicy.remoteOnly:
        return _getFromProviders(flag.key) ?? flag.defaultValue;

      case FeatureFlagPolicy.localFirst:
        return _localOverrides[flag.key] ?? _getFromProviders(flag.key) ?? flag.defaultValue;

      case FeatureFlagPolicy.remoteFirst:
        return _getFromProviders(flag.key) ?? _localOverrides[flag.key] ?? flag.defaultValue;
    }
  }

  bool? _getFromProviders(String key) {
    for (final provider in _providers) {
      final value = provider.isEnabled(key);
      if (value != null) return value;
    }
    return null;
  }

  void dispose() {
    _updateController.close();
  }
}
