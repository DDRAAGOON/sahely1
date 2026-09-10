import 'package:sahely/core/network/api_client.dart';
import 'package:sahely/core/network/api_envelope.dart';
import 'package:sahely/core/network/api_endpoints.dart';

/// Real remote data source for reviews.
class ReviewsApiDataSource {
  final ApiClient apiClient;

  ReviewsApiDataSource(this.apiClient);

  Future<List<Map<String, dynamic>>> fetchPropertyReviews(
      String propertyId) async {
    final res = await apiClient.get(ApiEndpoints.reviews,
        queryParameters: {'property_id': propertyId});
    final data = unwrapData(res.data);
    final list = (data is List) ? data : ((data['reviews'] ?? []) as List);
    return list
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  Future<void> createReview({
    required String bookingId,
    required String type,
    required int rating,
    required String comment,
  }) async {
    await apiClient.post(ApiEndpoints.reviews, data: {
      'booking_id': bookingId,
      'type': type,
      'rating': rating,
      'comment': comment,
    });
  }

  Future<void> deleteReview(String reviewId) =>
      apiClient.delete(ApiEndpoints.reviewDelete(reviewId));

  Future<void> likeReview(String reviewId) =>
      apiClient.post(ApiEndpoints.reviewLike(reviewId));

  Future<void> reportReview(String reviewId, String reason) =>
      apiClient.post(ApiEndpoints.reviewReport(reviewId),
          data: {'reason': reason});
}
