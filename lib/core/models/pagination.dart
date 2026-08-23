import 'package:equatable/equatable.dart';

class Pagination<T> extends Equatable {
  final List<T> items;
  final int page;
  final int pageSize;
  final int totalItems;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;
  final bool isFirstPage;
  final bool isLastPage;

  const Pagination({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.totalItems,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
    required this.isFirstPage,
    required this.isLastPage,
  });

  @override
  List<Object?> get props => [
        items,
        page,
        pageSize,
        totalItems,
        totalPages,
        hasNext,
        hasPrevious,
        isFirstPage,
        isLastPage,
      ];
}
