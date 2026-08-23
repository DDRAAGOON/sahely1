import '../models/review.dart';
import '../repositories/review_repository.dart';

class ReplyToReviewUseCase {
  final ReviewRepository repository;

  ReplyToReviewUseCase(this.repository);

  Future<void> execute({
    required String reviewId,
    required String userId,
    required String userName,
    required String comment,
  }) {
    final reply = ReviewReply(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      userName: userName,
      comment: comment,
      createdAt: DateTime.now(),
    );
    return repository.replyToReview(reviewId, reply);
  }
}
