import 'package:equatable/equatable.dart';

class InfiniteScrollRequest extends Equatable {
  final int page;
  final int pageSize;
  final Map<String, dynamic>? params;

  const InfiniteScrollRequest({
    required this.page,
    required this.pageSize,
    this.params,
  });

  @override
  List<Object?> get props => [page, pageSize, params];
}
