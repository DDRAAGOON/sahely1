import 'package:sahely/core/errors/exception_mapper.dart';
import 'package:sahely/core/errors/failures.dart';
import 'package:sahely/core/network/api_client.dart';
import 'package:sahely/features/shared/reviews/data/datasources/reviews_api_data_source.dart';
import 'package:sahely/features/shared/reviews/domain/models/review.dart';
import 'package:sahely/features/shared/reviews/domain/repositories/review_repository.dart';
import 'package:sahely/features/shared/reviews/data/models/review_dto.dart';
import 'package:sahely/features/shared/violations/data/violations_api_data_source.dart';
import 'package:sahely/core/network/api_envelope.dart';

/// Reviews, backed by `/reviews`; abusive reviews are reported through the
/// violations module, the backend's single reporting channel.
class ReviewRepositoryImpl implements ReviewRepository {
  ReviewRepositoryImpl({
    ReviewsApiDataSource? api,
    ViolationsApiDataSource? violations,
    ApiClient? apiClient,
  })  : _api = api ?? ReviewsApiDataSource(apiClient ?? ApiClient()),
        _violations =
            violations ?? ViolationsApiDataSource(apiClient ?? ApiClient());

  final ReviewsApiDataSource _api;
  final ViolationsApiDataSource _violations;

  @override
  Future<List<Review>> getPropertyReviews(String propertyId) =>
      _guard(() async {
        final raw = await _api.fetchPropertyReviews(propertyId);
        return raw.map((j) => _fromApi(j).toEntity()).toList();
      });

  @override
  Future<List<Review>> getUserReviews(String userId) => _guard(() async {
        final raw = await _api.fetchUserReviews(userId);
        return raw.map((j) => _fromApi(j).toEntity()).toList();
      });

  /// The API has no lookup by booking. A second review for the same booking
  /// is rejected by the server when it is submitted, so there is nothing to
  /// pre-check on the device.
  @override
  Future<Review?> getReviewByBookingId(String bookingId) async => null;

  @override
  Future<void> addReview(Review review) {
    if (review.bookingId.isEmpty) {
      throw const ValidationFailure('This stay can no longer be reviewed.');
    }
    return _guard(() => _api.createReview(
          bookingId: review.bookingId,
          type: review.userRole.toLowerCase() == 'owner' ? 'guest' : 'property',
          rating: review.rating.round(),
          comment: review.comment,
        ));
  }

  /// Posted reviews cannot be edited through the mobile API.
  @override
  Future<void> updateReview(Review review) async {
    throw const ValidationFailure(
        'Reviews cannot be edited after they are posted.');
  }

  /// Only an admin can remove a review; the mobile API has no delete route.
  @override
  Future<void> deleteReview(String reviewId) async {
    throw const ValidationFailure(
        'Reviews cannot be deleted. Report it if it breaks the rules.');
  }

  /// "Helpful" votes are not part of the reviews API; the screen keeps the
  /// toggle as its own state.
  @override
  Future<void> likeReview(String reviewId, String userId) async {}

  @override
  Future<void> reportReview(
    String reviewId,
    String userId,
    String reason,
  ) =>
      _guard(() => _violations.report(
            type: 'abusive_review',
            description: reason,
          ));

  /// Owner response to a review (`POST /reviews/:id/response`).
  @override
  Future<void> replyToReview(String reviewId, ReviewReply reply) =>
      _guard(() => _api.respondToReview(reviewId, reply.comment));

  static Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call();
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  /// Backend review JSON → the DTO shape the UI already understands. Keys are
  /// read in snake_case or camelCase, like the rest of the API.
  static ReviewDto _fromApi(Map<String, dynamic> j) {
    final reviewer = asMap(pick(j, 'reviewer'));
    final response = asMap(pick(j, 'response'));
    final name = [pick(reviewer, 'first_name'), pick(reviewer, 'last_name')]
        .where((part) => part != null && '$part'.trim().isNotEmpty)
        .join(' ');
    return ReviewDto(
      id: '${j['id']}',
      propertyId: '${pick(j, 'property_id') ?? ''}',
      bookingId: '${pick(j, 'booking_id') ?? ''}',
      userId: '${pick(j, 'reviewer_id') ?? reviewer['id'] ?? ''}',
      userName: name.isEmpty ? 'Guest' : name,
      userRole: '${pick(j, 'reviewer_role') ?? 'renter'}',
      userAvatar: pick(reviewer, 'avatar_url') as String?,
      rating: (asNum(j['rating']) ?? 0).toDouble(),
      comment: '${j['comment'] ?? ''}',
      photos: const [],
      createdAt: '${pick(j, 'created_at') ?? ''}',
      likes: asNum(pick(j, 'helpful_count'))?.toInt() ?? 0,
      ownerResponse: response.isEmpty
          ? null
          : ReviewResponseTextDto(
              '${response['response'] ?? response['text'] ?? ''}'),
    );
  }
}

/// Adapter so the mapper can surface the backend's owner-response text.
class ReviewResponseTextDto extends ReviewReplyDto {
  // ignore: prefer_const_constructors_in_immutables
  ReviewResponseTextDto(String text)
      : super(
          id: 'resp',
          userId: 'owner',
          userName: 'Owner',
          comment: text,
          createdAt: '',
        );
}
