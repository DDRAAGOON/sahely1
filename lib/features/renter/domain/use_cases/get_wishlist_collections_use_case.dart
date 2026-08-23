import 'package:sahely/data/models.dart';
import 'package:sahely/features/renter/domain/models/wishlist_item.dart';
import '../repositories/wishlist_repository.dart';

class GetWishlistCollectionsUseCase {
  final WishlistRepository repository;

  GetWishlistCollectionsUseCase(this.repository);

  Future<List<WishlistCollection>> execute(Role role) {
    return repository.getCollections(role);
  }
}
