import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sahely/core/errors/failures.dart';
import '../../../bookings/domain/entities/booking.dart';
import '../../domain/models/review.dart';
import '../../domain/use_cases/get_property_reviews_use_case.dart';
import '../../domain/use_cases/get_user_reviews_use_case.dart';
import '../../domain/use_cases/add_review_use_case.dart';
import '../../domain/use_cases/update_review_use_case.dart';
import '../../domain/use_cases/delete_review_use_case.dart';
import '../../domain/use_cases/like_review_use_case.dart';
import '../../domain/use_cases/report_review_use_case.dart';
import '../../domain/use_cases/reply_to_review_use_case.dart';
import '../../domain/use_cases/get_property_review_stats_use_case.dart';
import 'package:sahely/core/bloc/safe_emit.dart';

enum ReviewStatus { initial, loading, loaded, success, error }

class ReviewState extends Equatable {
  final List<Review> reviews;
  final PropertyReviewStats? stats;
  final ReviewStatus status;
  final String? errorMessage;
  final int? starsEarned;

  const ReviewState({
    this.reviews = const [],
    this.stats,
    this.status = ReviewStatus.initial,
    this.errorMessage,
    this.starsEarned,
  });

  ReviewState copyWith({
    List<Review>? reviews,
    PropertyReviewStats? stats,
    ReviewStatus? status,
    String? errorMessage,
    int? starsEarned,
  }) {
    return ReviewState(
      reviews: reviews ?? this.reviews,
      stats: stats ?? this.stats,
      status: status ?? this.status,
      errorMessage: errorMessage,
      starsEarned: starsEarned,
    );
  }

  @override
  List<Object?> get props =>
      [reviews, stats, status, errorMessage, starsEarned];
}

class ReviewCubit extends Cubit<ReviewState> with SafeEmit<ReviewState> {
  final GetPropertyReviewsUseCase _getPropertyReviewsUseCase;
  final GetUserReviewsUseCase _getUserReviewsUseCase;
  final AddReviewUseCase _addReviewUseCase;
  final UpdateReviewUseCase _updateReviewUseCase;
  final DeleteReviewUseCase _deleteReviewUseCase;
  final LikeReviewUseCase _likeReviewUseCase;
  final ReplyToReviewUseCase _replyToReviewUseCase;
  final GetPropertyReviewStatsUseCase _getStatsUseCase;

  ReviewCubit({
    required GetPropertyReviewsUseCase getPropertyReviewsUseCase,
    required GetUserReviewsUseCase getUserReviewsUseCase,
    required AddReviewUseCase addReviewUseCase,
    required UpdateReviewUseCase updateReviewUseCase,
    required DeleteReviewUseCase deleteReviewUseCase,
    required LikeReviewUseCase likeReviewUseCase,
    required ReportReviewUseCase reportReviewUseCase,
    required ReplyToReviewUseCase replyToReviewUseCase,
    required GetPropertyReviewStatsUseCase getStatsUseCase,
  })  : _getPropertyReviewsUseCase = getPropertyReviewsUseCase,
        _getUserReviewsUseCase = getUserReviewsUseCase,
        _addReviewUseCase = addReviewUseCase,
        _updateReviewUseCase = updateReviewUseCase,
        _deleteReviewUseCase = deleteReviewUseCase,
        _likeReviewUseCase = likeReviewUseCase,
        _replyToReviewUseCase = replyToReviewUseCase,
        _getStatsUseCase = getStatsUseCase,
        super(const ReviewState());

  Future<void> loadPropertyReviews(String propertyId) async {
    emit(state.copyWith(status: ReviewStatus.loading));
    try {
      final reviews = await _getPropertyReviewsUseCase.execute(propertyId);
      final stats = await _getStatsUseCase.execute(propertyId);
      emit(state.copyWith(
          status: ReviewStatus.loaded, reviews: reviews, stats: stats));
    } catch (e) {
      final message = e is Failure ? e.message : e.toString();
      emit(state.copyWith(status: ReviewStatus.error, errorMessage: message));
    }
  }

  Future<void> loadUserReviews(String userId) async {
    emit(state.copyWith(status: ReviewStatus.loading));
    try {
      final reviews = await _getUserReviewsUseCase.execute(userId);
      emit(state.copyWith(status: ReviewStatus.loaded, reviews: reviews));
    } catch (e) {
      final message = e is Failure ? e.message : e.toString();
      emit(state.copyWith(status: ReviewStatus.error, errorMessage: message));
    }
  }

  Future<void> addReview({
    required Booking booking,
    required String userId,
    required String userName,
    required String userRole,
    String? userAvatar,
    required double rating,
    required String comment,
    List<String> photos = const [],
  }) async {
    emit(state.copyWith(status: ReviewStatus.loading));
    try {
      final stars = await _addReviewUseCase.execute(
        booking: booking,
        userId: userId,
        userName: userName,
        userRole: userRole,
        userAvatar: userAvatar,
        rating: rating,
        comment: comment,
        photos: photos,
      );
      emit(state.copyWith(status: ReviewStatus.success, starsEarned: stars));
    } catch (e) {
      final message = e is Failure ? e.message : e.toString();
      emit(state.copyWith(status: ReviewStatus.error, errorMessage: message));
    }
  }

  Future<void> replyToReview({
    required String reviewId,
    required String userId,
    required String userName,
    required String comment,
  }) async {
    emit(state.copyWith(status: ReviewStatus.loading));
    try {
      await _replyToReviewUseCase.execute(
        reviewId: reviewId,
        userId: userId,
        userName: userName,
        comment: comment,
      );
      emit(state.copyWith(status: ReviewStatus.success));
    } catch (e) {
      final message = e is Failure ? e.message : e.toString();
      emit(state.copyWith(status: ReviewStatus.error, errorMessage: message));
    }
  }

  Future<void> updateReview(Review review) async {
    emit(state.copyWith(status: ReviewStatus.loading));
    try {
      await _updateReviewUseCase.execute(review);
      final updatedReviews =
          state.reviews.map((r) => r.id == review.id ? review : r).toList();
      emit(state.copyWith(
          status: ReviewStatus.success, reviews: updatedReviews));
    } catch (e) {
      final message = e is Failure ? e.message : e.toString();
      emit(state.copyWith(status: ReviewStatus.error, errorMessage: message));
    }
  }

  Future<void> likeReview(String reviewId, String userId) async {
    try {
      await _likeReviewUseCase.execute(reviewId, userId);
      final updatedReviews = state.reviews.map((r) {
        if (r.id == reviewId) {
          return r.copyWith(
            likes: r.isLikedByMe ? r.likes - 1 : r.likes + 1,
            isLikedByMe: !r.isLikedByMe,
          );
        }
        return r;
      }).toList();
      emit(state.copyWith(reviews: updatedReviews));
    } catch (e) {
      // Silently fail or show error
    }
  }

  Future<void> deleteReview(String reviewId) async {
    try {
      await _deleteReviewUseCase.execute(reviewId);
      final updatedReviews =
          state.reviews.where((r) => r.id != reviewId).toList();
      emit(state.copyWith(reviews: updatedReviews));
    } catch (e) {
      final message = e is Failure ? e.message : e.toString();
      emit(state.copyWith(status: ReviewStatus.error, errorMessage: message));
    }
  }
}
