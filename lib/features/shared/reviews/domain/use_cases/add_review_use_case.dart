import 'package:sahely/core/errors/failures.dart';
import 'package:sahely/core/validation/common_validators.dart';
import 'package:sahely/features/shared/bookings/domain/entities/booking.dart';
import '../models/review.dart';
import '../repositories/review_repository.dart';

class AddReviewUseCase {
  final ReviewRepository repository;
  AddReviewUseCase(this.repository);

  Future<int> execute({
    required Booking booking,
    required String userId,
    required String userName,
    required String userRole,
    String? userAvatar,
    required double rating,
    required String comment,
    List<String> photos = const [],
  }) async {
    // 1. Domain Validation
    if (booking.status != BookingStatus.past) {
      throw const ValidationFailure('You can only review completed stays.');
    }

    final existing = await repository.getReviewByBookingId(booking.id);
    if (existing != null) {
      throw const ValidationFailure('You have already reviewed this booking.');
    }

    // 2. Input Validation using Global Validators
    final ratingResult =
        RangeValidator(min: 1, max: 5).validate(rating, fieldName: 'Rating');
    if (!ratingResult.isValid) throw ratingResult.toFailure();

    final commentResult =
        RequiredValidator(customMessage: 'Review comment cannot be empty.')
            .validate(comment, fieldName: 'Comment');
    if (!commentResult.isValid) throw commentResult.toFailure();

    // 4. Create review
    final review = Review(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      propertyId: booking.propertyName,
      bookingId: booking.id,
      userId: userId,
      userName: userName,
      userRole: userRole,
      userAvatar: userAvatar,
      rating: rating,
      comment: comment,
      photos: photos,
      createdAt: DateTime.now(),
    );

    await repository.addReview(review);

    // 5. Stars to show the user. The server awards them when the review is
    //    created (5 for a review, +5 with photos) and notifies the owner.
    int starsEarned = 5;
    if (photos.isNotEmpty) {
      starsEarned += 5;
    }

    return starsEarned;
  }
}
