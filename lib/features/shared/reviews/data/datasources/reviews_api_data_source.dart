import 'package:sahely/core/network/api_client.dart';
import 'package:sahely/core/network/api_endpoints.dart';
import 'package:sahely/core/network/api_envelope.dart';

/// Remote data source for the `reviews` module.
///
/// The mobile API exposes six routes; there is intentionally **no**
/// like/report/update/delete endpoint for reviews, so those actions are not
/// available here (see [likeReview] / [reportReview]).
class ReviewsApiDataSource {
  final ApiClient apiClient;

  ReviewsApiDataSource(this.apiClient);

  /// `GET /reviews/?propertyId=` - reviews for one property.
  Future<List<Map<String, dynamic>>> fetchPropertyReviews(
    String propertyId, {
    int page = 1,
    int limit = ApiEndpoints.defaultPageSize,
  }) async {
    final res = await apiClient.get(
      ApiEndpoints.reviews,
      queryParameters: pageQuery(
        page: page,
        limit: limit,
        extra: {'propertyId': propertyId},
      ),
    );
    return asListOfMaps(unwrapData(res.data));
  }

  /// `GET /reviews/?userId=` - reviews written by (or about) a user.
  Future<List<Map<String, dynamic>>> fetchUserReviews(
    String userId, {
    int page = 1,
    int limit = ApiEndpoints.defaultPageSize,
  }) async {
    final res = await apiClient.get(
      ApiEndpoints.reviews,
      queryParameters: pageQuery(
        page: page,
        limit: limit,
        extra: {'userId': userId},
      ),
    );
    return asListOfMaps(unwrapData(res.data));
  }

  Future<Map<String, dynamic>> fetchReview(String reviewId) async {
    final res = await apiClient.get(ApiEndpoints.review(reviewId));
    return asMap(unwrapData(res.data));
  }

  /// Stays the signed-in user still has to review.
  Future<List<Map<String, dynamic>>> fetchPendingReviews() async {
    final res = await apiClient.get(ApiEndpoints.pendingReviews);
    return asListOfMaps(unwrapData(res.data));
  }

  /// Aggregate rating breakdown for a property.
  Future<Map<String, dynamic>> fetchSummary(String propertyId) async {
    final res = await apiClient.get(
      ApiEndpoints.reviewSummary,
      queryParameters: {'propertyId': propertyId},
    );
    return asMap(unwrapData(res.data));
  }

  /// `type` is `property` (renter reviewing a stay) or `guest` (owner
  /// reviewing a renter).
  Future<Map<String, dynamic>> createReview({
    required String bookingId,
    required String type,
    required int rating,
    required String comment,
  }) async {
    final res = await apiClient.post(
      ApiEndpoints.reviews,
      data: {
        'booking_id': bookingId,
        'type': type,
        'rating': rating,
        'comment': comment,
      },
    );
    return asMap(unwrapData(res.data));
  }

  /// Owner replies publicly to a review.
  Future<void> respondToReview(String reviewId, String response) =>
      apiClient.post(
        ApiEndpoints.reviewResponse(reviewId),
        data: {'response': response},
      );
}
