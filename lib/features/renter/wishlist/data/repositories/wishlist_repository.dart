class WishlistRepository {
  Future<bool> isWishlisted(String propertyId) async {
    return false;
  }

  Future<bool> toggleWishlist({
    required String propertyId,
    required String propertyName,
    required String propertyImage,
  }) async {
    return true;
  }
}
