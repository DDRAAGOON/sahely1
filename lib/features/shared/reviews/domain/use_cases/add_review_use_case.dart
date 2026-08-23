import 'package:sahely/core/errors/failures.dart';
import 'package:sahely/core/validation/common_validators.dart';
import 'package:sahely/features/shared/bookings/domain/entities/booking.dart';
import 'package:sahely/features/shared/notifications/domain/services/notification_service.dart';
import 'package:sahely/features/shared/rewards/domain/services/reward_service.dart';
import '../models/review.dart';
import '../repositories/review_repository.dart';

class AddReviewUseCase {
  final ReviewRepository repository;
  final NotificationService? notificationService;
  final RewardService? rewardService;

  AddReviewUseCase(this.repository, {this.notificationService, this.rewardService});

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
    final ratingResult = RangeValidator(min: 1, max: 5).validate(rating, fieldName: 'Rating');
    if (!ratingResult.isValid) throw ratingResult.toFailure();

    final commentResult = RequiredValidator(customMessage: 'Review comment cannot be empty.').validate(comment, fieldName: 'Comment');
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

    // 5. Award Sahel Stars (Business Rules: 5 stars for review, +5 for photos)
    int starsEarned = 5;
    if (photos.isNotEmpty) {
      starsEarned += 5;
    }

    if (rewardService != null) {
      await rewardService!.awardStars(
        userId: userId,
        amount: starsEarned,
        reason: 'Review for ${booking.propertyName}',
      );
    }

    // 6. Trigger Notification to Owner
    await notificationService?.notifyOwnerNewReview(
      ownerId: 'owner_id',
      propertyName: booking.propertyName,
      bookingId: booking.id,
      rating: rating,
    );

    return starsEarned;
  }
}
