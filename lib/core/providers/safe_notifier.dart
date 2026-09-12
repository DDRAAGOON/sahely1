import 'package:flutter/foundation.dart';

/// Ignores [notifyListeners] once the notifier has been disposed.
///
/// Providers fetch data asynchronously; if the provider is disposed while a
/// request is still in flight, notifying afterwards throws "A ... was used
/// after being disposed".
mixin SafeNotifier on ChangeNotifier {
  bool _disposed = false;

  @override
  void notifyListeners() {
    if (_disposed) return;
    super.notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
