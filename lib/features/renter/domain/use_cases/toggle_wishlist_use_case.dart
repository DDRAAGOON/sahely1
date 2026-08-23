import 'package:sahely/data/models.dart';
import 'package:sahely/features/renter/domain/constants/wishlist_constants.dart';
import '../models/wishlist_item.dart';
import '../repositories/wishlist_repository.dart';

class ToggleWishlistUseCase {
  final WishlistRepository repository;

  ToggleWishlistUseCase({
    required this.repository,
  });

  Future<bool> execute({
    required String propertyId,
    required String propertyName,
    required String propertyImage,
    required Role role,
  }) async {
    final isWishlisted = await repository.isWishlisted(propertyId, role);
    if (isWishlisted) {
      await repository.deleteWishlistItem(propertyId, role);
      return false;
    } else {
      const effectiveCollectionId = WishlistConstants.allSavedCollectionId;
      final item = WishlistItem(
        propertyId: propertyId,
        propertyName: propertyName,
        propertyImage: propertyImage,
        collectionIds: const [effectiveCollectionId],
        addedAt: DateTime.now(),
      );
      await repository.saveWishlistItem(item, role, effectiveCollectionId);
      return true;
    }
  }
}
