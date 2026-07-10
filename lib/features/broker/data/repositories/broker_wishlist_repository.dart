import '../../domain/models/broker_wishlist_item.dart';

class BrokerWishlistRepository {
  final Map<String, BrokerWishlistItem> _wishlistItems = {
    '1': BrokerWishlistItem(
      propertyId: '1',
      propertyName: 'Azure Beach Villa',
      propertyImage: 'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=800',
      collectionIds: ['broker_saved', 'client_leads'],
      addedAt: DateTime.now(),
    ),
    '2': BrokerWishlistItem(
      propertyId: '2',
      propertyName: 'Lagoon Retreat',
      propertyImage: 'https://images.unsplash.com/photo-1707075108813-edefd7b3308d?w=800',
      collectionIds: ['broker_saved'],
      addedAt: DateTime.now(),
    ),
  };
  final List<BrokerWishlistCollection> _collections = [
    const BrokerWishlistCollection(
      id: 'broker_saved',
      name: 'My Broker Saves',
      itemCount: 2,
      coverImage: 'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=800',
    ),
    const BrokerWishlistCollection(
      id: 'client_leads',
      name: 'Client Recommendations',
      itemCount: 1,
      coverImage: 'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=800',
      isShared: true,
    ),
  ];

  Future<bool> isWishlisted(String propertyId) async {
    return _wishlistItems.containsKey(propertyId);
  }

  Future<void> addToWishlist({
    required String propertyId,
    required String propertyName,
    required String propertyImage,
    String? collectionId,
  }) async {
    final targetCollection = collectionId ?? 'broker_saved';
    
    final item = BrokerWishlistItem(
      propertyId: propertyId,
      propertyName: propertyName,
      propertyImage: propertyImage,
      collectionIds: [targetCollection],
      addedAt: DateTime.now(),
    );

    _wishlistItems[propertyId] = item;
    _updateCollectionCount(targetCollection, 1, coverImage: propertyImage);
  }

  Future<void> removeFromWishlist(String propertyId) async {
    final item = _wishlistItems[propertyId];
    if (item != null) {
      for (var colId in item.collectionIds) {
        _updateCollectionCount(colId, -1);
      }
      _wishlistItems.remove(propertyId);
    }
  }

  Future<bool> toggleWishlist({
    required String propertyId,
    required String propertyName,
    required String propertyImage,
  }) async {
    if (_wishlistItems.containsKey(propertyId)) {
      await removeFromWishlist(propertyId);
      return false;
    } else {
      await addToWishlist(propertyId: propertyId, propertyName: propertyName, propertyImage: propertyImage);
      return true;
    }
  }

  Future<void> addCollection(String name) async {
    final newCol = BrokerWishlistCollection(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      itemCount: 0,
    );
    _collections.add(newCol);
  }

  void _updateCollectionCount(String id, int delta, {String? coverImage}) {
    final index = _collections.indexWhere((c) => c.id == id);
    if (index != -1) {
      final c = _collections[index];
      _collections[index] = BrokerWishlistCollection(
        id: c.id,
        name: c.name,
        itemCount: (c.itemCount + delta).clamp(0, 999),
        coverImage: delta > 0 ? (coverImage ?? c.coverImage) : (c.itemCount + delta > 0 ? c.coverImage : null),
        isShared: c.isShared,
      );
    }
  }

  Future<List<BrokerWishlistCollection>> getCollections() async {
    return _collections;
  }

  Future<void> addToCollection({
    required String propertyId,
    required String collectionId,
  }) async {
    final item = _wishlistItems[propertyId];
    if (item != null) {
      final updatedCollections = List<String>.from(item.collectionIds);
      if (!updatedCollections.contains(collectionId)) {
        updatedCollections.add(collectionId);
        _wishlistItems[propertyId] = item.copyWith(collectionIds: updatedCollections);
        _updateCollectionCount(collectionId, 1, coverImage: item.propertyImage);
      }
    }
  }

  Future<List<BrokerWishlistItem>> getWishlistItems(String collectionId) async {
    return _wishlistItems.values.where((item) => item.collectionIds.contains(collectionId)).toList();
  }
}
