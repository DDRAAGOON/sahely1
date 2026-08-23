import 'package:equatable/equatable.dart';
import '../../models/pagination.dart';

class InfiniteScrollResult<T> extends Equatable {
  final List<T> items;
  final int page;
  final int totalItems;
  final int totalPages;
  final bool hasNext;

  const InfiniteScrollResult({
    required this.items,
    required this.page,
    required this.totalItems,
    required this.totalPages,
    required this.hasNext,
  });

  factory InfiniteScrollResult.fromPagination(Pagination<T> pagination) {
    return InfiniteScrollResult(
      items: pagination.items,
      page: pagination.page,
      totalItems: pagination.totalItems,
      totalPages: pagination.totalPages,
      hasNext: pagination.hasNext,
    );
  }

  @override
  List<Object?> get props => [items, page, totalItems, totalPages, hasNext];
}
