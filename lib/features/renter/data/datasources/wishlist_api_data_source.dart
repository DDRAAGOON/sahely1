import 'package:sahely/core/network/api_client.dart';
import 'package:sahely/core/network/api_envelope.dart';
import 'package:sahely/core/network/api_endpoints.dart';

/// Real remote data source for wishlist collections.
class WishlistApiDataSource {
  final ApiClient apiClient;

  WishlistApiDataSource(this.apiClient);

  Future<List<Map<String, dynamic>>> fetchCollections() async {
    final res = await apiClient.get(ApiEndpoints.wishlists);
    final data = unwrapData(res.data);
    final list = (data is List) ? data : ((data['collections'] ?? []) as List);
    return list
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  Future<String> createCollection(String name) async {
    final res = await apiClient.post(ApiEndpoints.wishlists,
        data: {'name': name});
    final data = unwrapData(res.data);
    return '${data['id']}';
  }

  Future<void> renameCollection(String id, String name) async {
    await apiClient.put(ApiEndpoints.wishlistDetail(id), data: {'name': name});
  }

  Future<void> deleteCollection(String id) async {
    await apiClient.delete(ApiEndpoints.wishlistDetail(id));
  }

  Future<void> addProperty(String collectionId, String propertyId) async {
    await apiClient.post(ApiEndpoints.wishlistItems(collectionId),
        data: {'property_id': propertyId});
  }

  Future<void> removeProperty(String collectionId, String propertyId) async {
    await apiClient
        .delete('${ApiEndpoints.wishlistItems(collectionId)}/$propertyId');
  }

  Future<List<dynamic>> fetchItems(String collectionId) async {
    final res = await apiClient.get(ApiEndpoints.wishlistDetail(collectionId));
    final data = unwrapData(res.data);
    return ((data['properties'] ?? []) as List);
  }
}
