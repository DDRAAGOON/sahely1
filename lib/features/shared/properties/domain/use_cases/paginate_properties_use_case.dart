import 'package:sahely/core/models/pagination.dart';
import '../entities/property.dart';

class PaginatePropertiesUseCase {
  Pagination<Property> execute(List<Property> properties, int page, int pageSize) {
    final int totalItems = properties.length;
    final int totalPages = (totalItems / pageSize).ceil();
    final int start = (page - 1) * pageSize;
    final int end = start + pageSize;
    
    if (start >= totalItems) {
      return Pagination<Property>(
        items: const [],
        page: page,
        pageSize: pageSize,
        totalItems: totalItems,
        totalPages: totalPages,
        hasNext: false,
        hasPrevious: page > 1,
        isFirstPage: page == 1,
        isLastPage: page >= totalPages,
      );
    }
    
    final paginated = properties.sublist(
      start, 
      end > totalItems ? totalItems : end
    );

    return Pagination<Property>(
      items: paginated,
      page: page,
      pageSize: pageSize,
      totalItems: totalItems,
      totalPages: totalPages,
      hasNext: end < totalItems,
      hasPrevious: page > 1,
      isFirstPage: page == 1,
      isLastPage: page >= totalPages,
    );
  }
}
