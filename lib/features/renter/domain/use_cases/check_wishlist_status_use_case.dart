import 'package:sahely/data/models.dart';
import '../repositories/wishlist_repository.dart';

class CheckWishlistStatusUseCase {
  final WishlistRepository repository;

  CheckWishlistStatusUseCase(this.repository);

  Future<bool> execute(String propertyId, Role role) {
    return repository.isWishlisted(propertyId, role);
  }
}
