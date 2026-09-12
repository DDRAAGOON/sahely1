import '../models/review.dart';
import '../repositories/review_repository.dart';

class GetPropertyReviewStatsUseCase {
  final ReviewRepository repository;

  GetPropertyReviewStatsUseCase(this.repository);

  Future<PropertyReviewStats> execute(String propertyId) async {
    final reviews = await repository.getPropertyReviews(propertyId);

    if (reviews.isEmpty) {
      return const PropertyReviewStats(
        averageRating: 0.0,
        totalReviews: 0,
        ratingDistribution: {1: 0, 2: 0, 3: 0, 4: 0, 5: 0},
      );
    }

    double sum = 0;
    final dist = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    for (var r in reviews) {
      sum += r.rating;
      final rounded = r.rating.toInt();
      if (dist.containsKey(rounded)) {
        dist[rounded] = dist[rounded]! + 1;
      }
    }

    return PropertyReviewStats(
      averageRating: sum / reviews.length,
      totalReviews: reviews.length,
      ratingDistribution: dist,
    );
  }
}
