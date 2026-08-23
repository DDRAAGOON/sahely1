import 'package:sahely/data/models.dart';
import '../repositories/wishlist_repository.dart';

class RemoveFromCollectionUseCase {
  final WishlistRepository repository;

  RemoveFromCollectionUseCase(this.repository);

  Future<void> execute({
    required String propertyId,
    required String collectionId,
    required Role role,
  }) async {
    await repository.removeFromCollection(propertyId, collectionId, role);
  }
}
