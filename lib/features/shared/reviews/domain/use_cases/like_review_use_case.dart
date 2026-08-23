import '../repositories/review_repository.dart';

class LikeReviewUseCase {
  final ReviewRepository repository;

  LikeReviewUseCase(this.repository);

  Future<void> execute(String reviewId, String userId) {
    return repository.likeReview(reviewId, userId);
  }
}
