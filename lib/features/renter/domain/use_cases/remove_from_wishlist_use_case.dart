import 'package:sahely/data/models.dart';
import '../repositories/wishlist_repository.dart';

class RemoveFromWishlistUseCase {
  final WishlistRepository repository;

  RemoveFromWishlistUseCase(this.repository);

  Future<void> execute(String propertyId, Role role) async {
    await repository.deleteWishlistItem(propertyId, role);
  }
}
