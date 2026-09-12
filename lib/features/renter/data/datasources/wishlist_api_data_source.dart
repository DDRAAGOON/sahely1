import 'package:sahely/core/network/api_client.dart';
import 'package:sahely/core/network/api_endpoints.dart';
import 'package:sahely/core/network/api_envelope.dart';

/// Remote data source for the `wishlist` module - collaborative collections,
/// their shared group chat, membership and share links.
class WishlistApiDataSource {
  final ApiClient apiClient;

  WishlistApiDataSource(this.apiClient);

  // -- Collections ------------------------------------------------------------

  Future<List<Map<String, dynamic>>> fetchCollections() async {
    final res = await apiClient.get(ApiEndpoints.wishlists);
    return asListOfMaps(unwrapData(res.data));
  }

  Future<Map<String, dynamic>> fetchCollection(String id) async {
    final res = await apiClient.get(ApiEndpoints.wishlist(id));
    return asMap(unwrapData(res.data));
  }

  Future<String> createCollection(String name) async {
    final res =
        await apiClient.post(ApiEndpoints.wishlists, data: {'name': name});
    return '${asMap(unwrapData(res.data))['id'] ?? ''}';
  }

  Future<void> renameCollection(String id, String name) =>
      apiClient.put(ApiEndpoints.wishlist(id), data: {'name': name});

  Future<void> deleteCollection(String id) =>
      apiClient.delete(ApiEndpoints.wishlist(id));

  /// Side-by-side comparison of every property in a collection.
  Future<Map<String, dynamic>> compare(String id) async {
    final res = await apiClient.get(ApiEndpoints.wishlistCompare(id));
    return asMap(unwrapData(res.data));
  }

  // -- Properties inside a collection ------------------------------------------

  Future<List<Map<String, dynamic>>> fetchItems(String collectionId) async {
    final collection = await fetchCollection(collectionId);
    return asListOfMaps(collection['properties'] ?? collection['items']);
  }

  Future<void> addProperty(String collectionId, String propertyId) =>
      apiClient.post(
        ApiEndpoints.wishlistProperties(collectionId),
        data: {'property_id': propertyId},
      );

  Future<void> removeProperty(String collectionId, String propertyId) =>
      apiClient.delete(
        ApiEndpoints.wishlistProperty(collectionId, propertyId),
      );

  // -- Group chat --------------------------------------------------------------

  /// Newest first, per the API contract.
  Future<List<Map<String, dynamic>>> fetchMessages(
    String collectionId, {
    int page = 1,
    int limit = ApiEndpoints.defaultPageSize,
  }) async {
    final res = await apiClient.get(
      ApiEndpoints.wishlistMessages(collectionId),
      queryParameters: pageQuery(page: page, limit: limit),
    );
    return asListOfMaps(unwrapData(res.data));
  }

  Future<void> sendMessage(String collectionId, String body) => apiClient.post(
        ApiEndpoints.wishlistMessages(collectionId),
        data: {'body': body},
      );

  Future<void> deleteMessage(String collectionId, String messageId) =>
      apiClient.delete(ApiEndpoints.wishlistMessage(collectionId, messageId));

  Future<void> markChatRead(String collectionId) =>
      apiClient.post(ApiEndpoints.wishlistMessagesRead(collectionId));

  Future<int> unreadCount(String collectionId) async {
    final res =
        await apiClient.get(ApiEndpoints.wishlistUnreadCount(collectionId));
    final data = unwrapData(res.data);
    if (data is num) return data.toInt();
    return asNum(asMap(data)['count'] ?? asMap(data)['unread'])?.toInt() ?? 0;
  }

  /// Report an abusive message or member in the group chat.
  Future<void> report(
    String collectionId, {
    required String reason,
    String? messageId,
    String? reportedUserId,
    String? details,
  }) =>
      apiClient.post(
        ApiEndpoints.wishlistReports(collectionId),
        data: {
          'reason': reason,
          if (messageId != null) 'message_id': messageId,
          if (reportedUserId != null) 'reported_user_id': reportedUserId,
          if (details != null) 'details': details,
        },
      );

  // -- Membership --------------------------------------------------------------

  Future<List<Map<String, dynamic>>> fetchMembers(String collectionId) async {
    final res = await apiClient.get(ApiEndpoints.wishlistMembers(collectionId));
    return asListOfMaps(unwrapData(res.data));
  }

  Future<void> leave(String collectionId) =>
      apiClient.post(ApiEndpoints.wishlistLeave(collectionId));

  /// Owner only.
  Future<void> removeMember(String collectionId, String userId) =>
      apiClient.delete(ApiEndpoints.wishlistMember(collectionId, userId));

  /// Owner only - lifts a previous removal.
  Future<void> reinstateMember(String collectionId, String userId) =>
      apiClient.post(
        ApiEndpoints.wishlistMemberReinstate(collectionId, userId),
      );

  // -- Sharing -----------------------------------------------------------------

  /// Creates the share link, or returns the existing one. Owner only.
  Future<String> createShareLink(String collectionId) async {
    final res =
        await apiClient.post(ApiEndpoints.wishlistShareLink(collectionId));
    final data = asMap(unwrapData(res.data));
    return '${data['share_url'] ?? data['url'] ?? data['link'] ?? ''}';
  }

  Future<Map<String, dynamic>> shareStatus(String collectionId) async {
    final res =
        await apiClient.get(ApiEndpoints.wishlistShareStatus(collectionId));
    return asMap(unwrapData(res.data));
  }

  Future<void> revokeShare(String collectionId) =>
      apiClient.post(ApiEndpoints.wishlistShareRevoke(collectionId));

  Future<void> rotateShare(String collectionId) =>
      apiClient.post(ApiEndpoints.wishlistShareRotate(collectionId));

  /// Redeems a share token received through a deep link.
  Future<Map<String, dynamic>> join(String token) async {
    final res =
        await apiClient.post(ApiEndpoints.wishlistJoin, data: {'token': token});
    return asMap(unwrapData(res.data));
  }
}
