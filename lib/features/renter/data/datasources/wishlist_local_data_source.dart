import 'package:sahely/data/models.dart';
import 'package:sahely/features/renter/data/models/wishlist_dto.dart';
import 'package:sahely/features/renter/domain/constants/wishlist_constants.dart';

/// In-memory store of the signed-in user's saved properties and the
/// per-collection bookkeeping (counts, cover image) the wishlist screens
/// render. Collections themselves live on the backend (`/wishlists`).
class WishlistLocalDataSource {
  final Map<Role, Map<String, WishlistItemDto>> _wishlistItemsByRole = {
    Role.renter: {},
    Role.owner: {},
    Role.broker: {},
  };

  final Map<Role, Map<String, WishlistCollectionDto>> _collectionsByRole = {
    Role.renter: {
      WishlistConstants.allSavedCollectionId: const WishlistCollectionDto(
        id: WishlistConstants.allSavedCollectionId,
        name: WishlistConstants.allSavedCollectionName,
        itemCount: 0,
      ),
    },
    Role.owner: {
      WishlistConstants.allSavedCollectionId: const WishlistCollectionDto(
        id: WishlistConstants.allSavedCollectionId,
        name: WishlistConstants.allSavedCollectionName,
        itemCount: 0,
      ),
    },
    Role.broker: {
      WishlistConstants.allSavedCollectionId: const WishlistCollectionDto(
        id: WishlistConstants.allSavedCollectionId,
        name: WishlistConstants.allSavedCollectionName,
        itemCount: 0,
      ),
    },
  };

  Future<WishlistItemDto?> getItem(String propertyId, Role role) async {
    return _wishlistItemsByRole[role]?[propertyId];
  }

  Future<List<WishlistItemDto>> getAllItems(Role role) async {
    return _wishlistItemsByRole[role]?.values.toList() ?? [];
  }

  Future<void> saveItem(WishlistItemDto item, Role role) async {
    _wishlistItemsByRole[role]![item.propertyId] = item;
  }

  Future<void> deleteItem(String propertyId, Role role) async {
    _wishlistItemsByRole[role]?.remove(propertyId);
  }

  Future<List<WishlistCollectionDto>> getCollections(Role role) async {
    return _collectionsByRole[role]?.values.toList() ?? [];
  }

  Future<void> saveCollection(
      WishlistCollectionDto collection, Role role) async {
    _collectionsByRole[role]![collection.id] = collection;
  }

  Future<void> deleteCollection(String id, Role role) async {
    _collectionsByRole[role]?.remove(id);
  }
}
