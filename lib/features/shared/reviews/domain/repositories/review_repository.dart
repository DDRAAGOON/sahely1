import '../models/review.dart';

abstract class ReviewRepository {
  Future<List<Review>> getPropertyReviews(String propertyId);
  Future<List<Review>> getUserReviews(String userId);
  Future<Review?> getReviewByBookingId(String bookingId);
  Future<void> addReview(Review review);
  Future<void> updateReview(Review review);
  Future<void> deleteReview(String reviewId);
  Future<void> likeReview(String reviewId, String userId);
  Future<void> reportReview(String reviewId, String userId, String reason);
  Future<void> replyToReview(String reviewId, ReviewReply reply);
}
