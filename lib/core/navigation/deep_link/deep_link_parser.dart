import 'deep_link_route.dart';

class DeepLinkParser {
  final List<String> _registeredRoutes = [];

  void registerRoute(String pathPattern) {
    if (!_registeredRoutes.contains(pathPattern)) {
      _registeredRoutes.add(pathPattern);
    }
  }

  DeepLinkRoute? parse(Uri uri) {
    final path = uri.path;
    final queryParameters = uri.queryParameters;

    for (final pattern in _registeredRoutes) {
      final match = _matchPath(pattern, path);
      if (match != null) {
        return DeepLinkRoute(
          path: pattern,
          pathParameters: match,
          queryParameters: queryParameters,
        );
      }
    }
    return null;
  }

  Map<String, String>? _matchPath(String pattern, String path) {
    final patternSegments = pattern.split('/').where((s) => s.isNotEmpty).toList();
    final pathSegments = path.split('/').where((s) => s.isNotEmpty).toList();

    if (patternSegments.length != pathSegments.length) {
      return null;
    }

    final parameters = <String, String>{};

    for (int i = 0; i < patternSegments.length; i++) {
      final patternSegment = patternSegments[i];
      final pathSegment = pathSegments[i];

      if (patternSegment.startsWith(':')) {
        final key = patternSegment.substring(1);
        parameters[key] = pathSegment;
      } else if (patternSegment != pathSegment) {
        return null;
      }
    }

    return parameters;
  }
}
