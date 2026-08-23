import '../models/review.dart';
import '../repositories/review_repository.dart';

class GetUserReviewsUseCase {
  final ReviewRepository repository;

  GetUserReviewsUseCase(this.repository);

  Future<List<Review>> execute(String userId) {
    return repository.getUserReviews(userId);
  }
}
