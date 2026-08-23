import '../repositories/review_repository.dart';

class DeleteReviewUseCase {
  final ReviewRepository repository;

  DeleteReviewUseCase(this.repository);

  Future<void> execute(String reviewId) {
    return repository.deleteReview(reviewId);
  }
}
