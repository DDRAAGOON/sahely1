import 'package:sahely/data/models.dart';
import '../repositories/wishlist_repository.dart';

class AddToCollectionUseCase {
  final WishlistRepository repository;

  AddToCollectionUseCase(this.repository);

  Future<void> execute({
    required String propertyId,
    required String collectionId,
    required Role role,
  }) async {
    final item = await repository.getWishlistItem(propertyId, role);
    if (item != null) {
      final updatedCollections = List<String>.from(item.collectionIds);
      if (!updatedCollections.contains(collectionId)) {
        updatedCollections.add(collectionId);
        await repository.saveWishlistItem(
          item.copyWith(collectionIds: updatedCollections),
          role,
          collectionId,
        );
      }
    }
  }
}
