import '../models/review_dto.dart';

class MockReviewDataSource {
  final List<ReviewDto> _reviews = [
    ReviewDto(
      id: '1',
      propertyId: 'Azure Beach Villa',
      bookingId: 'b1',
      userId: 'u1',
      userName: 'Nour A.',
      userRole: 'Renter',
      rating: 5,
      comment: 'Absolutely stunning. The pool and sea views were unreal, and check-in via the smart lock was seamless. Highly recommend for families.',
      photos: const [],
      createdAt: DateTime.now().subtract(const Duration(days: 30)).toIso8601String(),
    ),
    ReviewDto(
      id: '2',
      propertyId: 'Azure Beach Villa',
      bookingId: 'b2',
      userId: 'u2',
      userName: 'Omar K.',
      userRole: 'Renter',
      rating: 5,
      comment: 'Spotless, exactly as pictured. Host was responsive and the location is unbeatable. Will book again next season.',
      photos: const [],
      createdAt: DateTime.now().subtract(const Duration(days: 60)).toIso8601String(),
      ownerResponse: ReviewReplyDto(
        id: 'r1',
        userId: 'host1',
        userName: 'Host',
        comment: 'Thank you Omar! It was a pleasure having you.',
        createdAt: DateTime.now().subtract(const Duration(days: 59)).toIso8601String(),
      ),
    ),
  ];

  Future<List<ReviewDto>> getPropertyReviews(String propertyId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _reviews.where((r) => r.propertyId == propertyId).toList();
  }

  Future<List<ReviewDto>> getUserReviews(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _reviews.where((r) => r.userId == userId).toList();
  }

  Future<ReviewDto?> getReviewByBookingId(String bookingId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _reviews.firstWhere((r) => r.bookingId == bookingId);
    } catch (_) {
      return null;
    }
  }

  Future<void> addReview(ReviewDto review) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _reviews.add(review);
  }

  Future<void> updateReview(ReviewDto review) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _reviews.indexWhere((r) => r.id == review.id);
    if (index != -1) {
      _reviews[index] = review;
    }
  }

  Future<void> deleteReview(String reviewId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _reviews.removeWhere((r) => r.id == reviewId);
  }

  Future<void> likeReview(String reviewId, String userId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _reviews.indexWhere((r) => r.id == reviewId);
    if (index != -1) {
      final r = _reviews[index];
      _reviews[index] = ReviewDto(
        id: r.id,
        propertyId: r.propertyId,
        bookingId: r.bookingId,
        userId: r.userId,
        userName: r.userName,
        userRole: r.userRole,
        userAvatar: r.userAvatar,
        rating: r.rating,
        comment: r.comment,
        photos: r.photos,
        createdAt: r.createdAt,
        likes: r.isLikedByMe ? r.likes - 1 : r.likes + 1,
        isLikedByMe: !r.isLikedByMe,
        ownerResponse: r.ownerResponse,
      );
    }
  }

  Future<void> reportReview(String reviewId, String userId, String reason) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
