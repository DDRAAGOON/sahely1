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
    final bool isTargetingAllSaved =
        collectionId == null || collectionId == WishlistConstants.allSavedCollectionId;

    // We always want the item to be in 'all_saved'
    final Set<String> targetCollectionIds = {
      WishlistConstants.allSavedCollectionId,
      if (collectionId != null) collectionId,
    };

    // Check if item already exists in wishlist
    final existingItem = await repository.getWishlistItem(propertyId, role);

    if (existingItem != null) {
      // If it exists, merge the new collection IDs with existing ones
      final mergedIds = Set<String>.from(existingItem.collectionIds)
        ..addAll(targetCollectionIds);

      await repository.saveWishlistItem(
        existingItem.copyWith(collectionIds: mergedIds.toList()),
        role,
        isTargetingAllSaved ? WishlistConstants.allSavedCollectionId : collectionId!,
      );
    } else {
      // New item
      final item = WishlistItem(
        propertyId: propertyId,
        propertyName: propertyName,
        propertyImage: propertyImage,
        collectionIds: targetCollectionIds.toList(),
        addedAt: DateTime.now(),
      );
      await repository.saveWishlistItem(
          item, role, isTargetingAllSaved ? WishlistConstants.allSavedCollectionId : collectionId!);
    }
  }
}
