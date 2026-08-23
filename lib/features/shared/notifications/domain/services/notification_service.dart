abstract class NotificationService {
  Future<void> notifyOwnerNewReview({
    required String ownerId,
    required String propertyName,
    required String bookingId,
    required double rating,
  });
}
