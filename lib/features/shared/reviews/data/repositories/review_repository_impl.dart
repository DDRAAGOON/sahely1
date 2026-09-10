import 'package:sahely/core/config/app_config.dart';
import 'package:sahely/core/errors/exception_mapper.dart';
import 'package:sahely/core/network/api_client.dart';
import 'package:sahely/features/shared/reviews/data/datasources/mock_review_data_source.dart';
import 'package:sahely/features/shared/reviews/data/datasources/reviews_api_data_source.dart';
import 'package:sahely/features/shared/reviews/domain/models/review.dart';
import 'package:sahely/features/shared/reviews/domain/repositories/review_repository.dart';
import 'package:sahely/features/shared/reviews/data/models/review_dto.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final MockReviewDataSource dataSource;
  final ReviewsApiDataSource? apiDataSource;

  ReviewRepositoryImpl({required this.dataSource, ApiClient? apiClient})
      : apiDataSource =
            AppConfig.useRemoteApi ? ReviewsApiDataSource(apiClient ?? ApiClient()) : null;

  @override
  Future<List<Review>> getPropertyReviews(String propertyId) async {
    try {
      if (apiDataSource != null) {
        final raw = await apiDataSource!.fetchPropertyReviews(propertyId);
        return raw.map((j) => _fromApi(j).toEntity()).toList();
      }
      final dtos = await dataSource.getPropertyReviews(propertyId);
      return dtos.map((dto) => dto.toEntity()).toList();
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  @override
  Future<List<Review>> getUserReviews(String userId) async {
    try {
      final dtos = await dataSource.getUserReviews(userId);
      return dtos.map((dto) => dto.toEntity()).toList();
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  @override
  Future<Review?> getReviewByBookingId(String bookingId) async {
    try {
      final dtos = await dataSource.getReviewByBookingId(bookingId);
      return dtos?.toEntity();
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  @override
  Future<void> addReview(Review review) async {
    try {
      if (apiDataSource != null && review.bookingId.isNotEmpty) {
        await apiDataSource!.createReview(
          bookingId: review.bookingId,
          type: review.userRole.toLowerCase() == 'owner'
              ? 'guest'
              : 'property',
          rating: review.rating.round(),
          comment: review.comment,
        );
        return;
      }
      await dataSource.addReview(ReviewDto.fromEntity(review));
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  @override
  Future<void> updateReview(Review review) async {
    try {
      await dataSource.updateReview(ReviewDto.fromEntity(review));
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  @override
  Future<void> deleteReview(String reviewId) async {
    try {
      if (apiDataSource != null) {
        await apiDataSource!.deleteReview(reviewId);
        return;
      }
      await dataSource.deleteReview(reviewId);
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  @override
  Future<void> likeReview(String reviewId, String userId) async {
    try {
      if (apiDataSource != null) {
        await apiDataSource!.likeReview(reviewId);
        return;
      }
      await dataSource.likeReview(reviewId, userId);
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  @override
  Future<void> reportReview(String reviewId, String userId, String reason) async {
    try {
      if (apiDataSource != null) {
        await apiDataSource!.reportReview(reviewId, reason);
        return;
      }
      await dataSource.reportReview(reviewId, userId, reason);
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  @override
  Future<void> replyToReview(String reviewId, ReviewReply reply) async {
    // Owner responses are posted from the owner web portal; local no-op here.
  }

  /// Backend review JSON → the DTO shape the UI already understands.
  static ReviewDto _fromApi(Map<String, dynamic> j) {
    final reviewer = (j['reviewer'] as Map?) ?? const {};
    final response = (j['response'] as Map?) ?? const {};
    return ReviewDto(
      id: '${j['id']}',
      propertyId: '${j['property_id'] ?? ''}',
      bookingId: '${j['booking_id'] ?? ''}',
      userId: '${j['reviewer_id'] ?? ''}',
      userName: '${reviewer['first_name'] ?? 'Guest'} ${reviewer['last_name'] ?? ''}'.trim(),
      userRole: '${j['reviewer_role'] ?? 'renter'}',
      userAvatar: reviewer['avatar_url'] as String?,
      rating: (j['rating'] as num? ?? 0).toDouble(),
      comment: '${j['comment'] ?? ''}',
      photos: const [],
      createdAt: '${j['created_at'] ?? ''}',
      likes: j['helpful_count'] as int? ?? 0,
      ownerResponse: response.isEmpty
          ? null
          : ReviewResponseTextDto('${response['response'] ?? ''}'),
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
