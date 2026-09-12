import 'package:flutter_bloc/flutter_bloc.dart';

/// Drops states emitted after the cubit was closed.
///
/// Cubits load their data asynchronously. When the screen that owns one is
/// closed - or the whole bloc tree is rebuilt on a role switch - before the
/// response arrives, a plain `emit` throws "Cannot emit new states after
/// calling close" as an uncaught error.
mixin SafeEmit<S> on Cubit<S> {
  @override
  void emit(S state) {
    if (isClosed) return;
    super.emit(state);
  }
}
