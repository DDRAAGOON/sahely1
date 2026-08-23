import 'package:equatable/equatable.dart';

class DeepLinkRoute extends Equatable {
  final String path;
  final Map<String, String> pathParameters;
  final Map<String, String> queryParameters;

  const DeepLinkRoute({
    required this.path,
    this.pathParameters = const {},
    this.queryParameters = const {},
  });

  @override
  List<Object?> get props => [path, pathParameters, queryParameters];
}
