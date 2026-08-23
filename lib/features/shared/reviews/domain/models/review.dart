import 'package:equatable/equatable.dart';

class Review extends Equatable {
  final String id;
  final String propertyId;
  final String bookingId;
  final String userId;
  final String userName;
  final String userRole;
  final String? userAvatar;
  final double rating;
  final String comment;
  final List<String> photos;
  final DateTime createdAt;
  final int likes;
  final bool isLikedByMe;
  final ReviewReply? ownerResponse;

  const Review({
    required this.id,
    required this.propertyId,
    required this.bookingId,
    required this.userId,
    required this.userName,
    required this.userRole,
    this.userAvatar,
    required this.rating,
    required this.comment,
    this.photos = const [],
    required this.createdAt,
    this.likes = 0,
    this.isLikedByMe = false,
    this.ownerResponse,
  });

  Review copyWith({
    String? id,
    String? propertyId,
    String? bookingId,
    String? userId,
    String? userName,
    String? userRole,
    String? userAvatar,
    double? rating,
    String? comment,
    List<String>? photos,
    DateTime? createdAt,
    int? likes,
    bool? isLikedByMe,
    ReviewReply? ownerResponse,
  }) {
    return Review(
      id: id ?? this.id,
      propertyId: propertyId ?? this.propertyId,
      bookingId: bookingId ?? this.bookingId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userRole: userRole ?? this.userRole,
      userAvatar: userAvatar ?? this.userAvatar,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      photos: photos ?? this.photos,
      createdAt: createdAt ?? this.createdAt,
      likes: likes ?? this.likes,
      isLikedByMe: isLikedByMe ?? this.isLikedByMe,
      ownerResponse: ownerResponse ?? this.ownerResponse,
    );
  }

  @override
  List<Object?> get props => [
        id,
        propertyId,
        bookingId,
        userId,
        userName,
        userRole,
        userAvatar,
        rating,
        comment,
        photos,
        createdAt,
        likes,
        isLikedByMe,
        ownerResponse,
      ];
}

class ReviewReply extends Equatable {
  final String id;
  final String userId;
  final String userName;
  final String comment;
  final DateTime createdAt;

  const ReviewReply({
    required this.id,
    required this.userId,
    required this.userName,
    required this.comment,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, userId, userName, comment, createdAt];
}

class PropertyReviewStats extends Equatable {
  final double averageRating;
  final int totalReviews;
  final Map<int, int> ratingDistribution; // 1-5 to count

  const PropertyReviewStats({
    required this.averageRating,
    required this.totalReviews,
    required this.ratingDistribution,
  });

  @override
  List<Object?> get props => [averageRating, totalReviews, ratingDistribution];
}
