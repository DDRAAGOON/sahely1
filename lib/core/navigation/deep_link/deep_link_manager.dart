import 'dart:async';
import 'deep_link_parser.dart';
import 'deep_link_route.dart';

typedef DeepLinkHandler = FutureOr<void> Function(DeepLinkRoute route);

class DeepLinkManager {
  final DeepLinkParser _parser = DeepLinkParser();
  final Map<String, DeepLinkHandler> _handlers = {};

  void register({
    required String pathPattern,
    required DeepLinkHandler handler,
  }) {
    _parser.registerRoute(pathPattern);
    _handlers[pathPattern] = handler;
  }

  Future<void> handle(Uri uri) async {
    final route = _parser.parse(uri);
    if (route != null) {
      final handler = _handlers[route.path];
      if (handler != null) {
        await handler(route);
      }
    }
  }
}
