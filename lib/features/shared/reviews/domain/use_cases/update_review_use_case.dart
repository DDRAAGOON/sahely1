import '../models/review.dart';
import '../repositories/review_repository.dart';

class UpdateReviewUseCase {
  final ReviewRepository repository;

  UpdateReviewUseCase(this.repository);

  Future<void> execute(Review review) {
    return repository.updateReview(review);
  }
}
