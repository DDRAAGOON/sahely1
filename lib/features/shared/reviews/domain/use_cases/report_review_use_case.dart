import '../repositories/review_repository.dart';

class ReportReviewUseCase {
  final ReviewRepository repository;

  ReportReviewUseCase(this.repository);

  Future<void> execute(String reviewId, String userId, String reason) {
    return repository.reportReview(reviewId, userId, reason);
  }
}
