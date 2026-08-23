import '../models/review.dart';
import '../repositories/review_repository.dart';

class GetPropertyReviewsUseCase {
  final ReviewRepository repository;

  GetPropertyReviewsUseCase(this.repository);

  Future<List<Review>> execute(String propertyId) {
    return repository.getPropertyReviews(propertyId);
  }
}
