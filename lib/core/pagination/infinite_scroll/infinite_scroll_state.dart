import 'package:equatable/equatable.dart';
import 'infinite_scroll_status.dart';

class InfiniteScrollState<T> extends Equatable {
  final InfiniteScrollStatus status;
  final List<T> items;
  final int currentPage;
  final int totalItems;
  final int totalPages;
  final bool hasNext;
  final String? errorMessage;

  const InfiniteScrollState({
    this.status = InfiniteScrollStatus.idle,
    this.items = const [],
    this.currentPage = 0,
    this.totalItems = 0,
    this.totalPages = 0,
    this.hasNext = false,
    this.errorMessage,
  });

  InfiniteScrollState<T> copyWith({
    InfiniteScrollStatus? status,
    List<T>? items,
    int? currentPage,
    int? totalItems,
    int? totalPages,
    bool? hasNext,
    String? errorMessage,
  }) {
    return InfiniteScrollState<T>(
      status: status ?? this.status,
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      totalItems: totalItems ?? this.totalItems,
      totalPages: totalPages ?? this.totalPages,
      hasNext: hasNext ?? this.hasNext,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        items,
        currentPage,
        totalItems,
        totalPages,
        hasNext,
        errorMessage,
      ];
}
