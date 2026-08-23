import 'package:sahely/data/models.dart';
import 'package:sahely/features/renter/domain/constants/wishlist_constants.dart';
import 'package:sahely/features/renter/domain/models/wishlist_item.dart';
import '../repositories/wishlist_repository.dart';

class AddToWishlistUseCase {
  final WishlistRepository repository;

  AddToWishlistUseCase(this.repository);

  Future<void> execute({
    required String propertyId,
    required String propertyName,
    required String propertyImage,
    required Role role,
    String? collectionId,
  }) async {
    final effectiveCollectionId = collectionId ?? WishlistConstants.allSavedCollectionId;
    final item = WishlistItem(
      propertyId: propertyId,
      propertyName: propertyName,
      propertyImage: propertyImage,
      collectionIds: [effectiveCollectionId],
      addedAt: DateTime.now(),
    );
    await repository.saveWishlistItem(item, role, effectiveCollectionId);
  }
}
