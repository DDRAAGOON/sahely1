import 'package:sahely/data/models.dart';
import 'package:sahely/features/renter/domain/models/wishlist_item.dart';

abstract class WishlistRepository {
  Future<bool> isWishlisted(String propertyId, Role role);
  Future<void> saveWishlistItem(
      WishlistItem item, Role role, String collectionId);
  Future<void> deleteWishlistItem(String propertyId, Role role);
  Future<void> syncItemCollections(
      WishlistItem item, Role role, List<String> collectionIds);
  Future<void> saveCollection(WishlistCollection collection, Role role);
  Future<List<WishlistCollection>> getCollections(Role role);
  Future<WishlistItem?> getWishlistItem(String propertyId, Role role);
  Future<List<WishlistItem>> getWishlistItemsByCollection(
      String collectionId, Role role);
  Future<List<WishlistItem>> getAllWishlistItems(Role role);
  Future<void> removeFromCollection(
      String propertyId, String collectionId, Role role);
  Future<void> renameCollection(String collectionId, String newName, Role role);
  Future<void> deleteCollection(String collectionId, Role role);
}
