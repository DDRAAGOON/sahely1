import 'package:sahely/data/models.dart';
import 'package:sahely/features/renter/domain/models/wishlist_item.dart';
import '../repositories/wishlist_repository.dart';

class GetWishlistItemsUseCase {
  final WishlistRepository repository;

  GetWishlistItemsUseCase(this.repository);

  Future<List<WishlistItem>> execute({required Role role, String? collectionId}) {
    if (collectionId != null) {
      return repository.getWishlistItemsByCollection(collectionId, role);
    }
    return repository.getAllWishlistItems(role);
  }
}
