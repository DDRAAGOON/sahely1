import 'package:equatable/equatable.dart';
import '../../domain/models/review.dart';

class ReviewDto extends Equatable {
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
  final String createdAt;
  final int likes;
  final bool isLikedByMe;
  final ReviewReplyDto? ownerResponse;

  const ReviewDto({
    required this.id,
    required this.propertyId,
    required this.bookingId,
    required this.userId,
    required this.userName,
    required this.userRole,
    this.userAvatar,
    required this.rating,
    required this.comment,
    required this.photos,
    required this.createdAt,
    this.likes = 0,
    this.isLikedByMe = false,
    this.ownerResponse,
  });

  factory ReviewDto.fromJson(Map<String, dynamic> json) {
    return ReviewDto(
      id: json['id'] as String,
      propertyId: json['propertyId'] as String,
      bookingId: json['bookingId'] as String? ?? '',
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userRole: json['userRole'] as String,
      userAvatar: json['userAvatar'] as String?,
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] as String,
      photos: List<String>.from(json['photos'] ?? []),
      createdAt: json['createdAt'] as String,
      likes: json['likes'] as int? ?? 0,
      isLikedByMe: json['isLikedByMe'] as bool? ?? false,
      ownerResponse: json['ownerResponse'] != null
          ? ReviewReplyDto.fromJson(
              json['ownerResponse'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'propertyId': propertyId,
      'bookingId': bookingId,
      'userId': userId,
      'userName': userName,
      'userRole': userRole,
      'userAvatar': userAvatar,
      'rating': rating,
      'comment': comment,
      'photos': photos,
      'createdAt': createdAt,
      'likes': likes,
      'isLikedByMe': isLikedByMe,
      'ownerResponse': ownerResponse?.toJson(),
    };
  }

  Review toEntity() {
    return Review(
      id: id,
      propertyId: propertyId,
      bookingId: bookingId,
      userId: userId,
      userName: userName,
      userRole: userRole,
      userAvatar: userAvatar,
      rating: rating,
      comment: comment,
      photos: photos,
      createdAt: DateTime.tryParse(createdAt) ??
          DateTime.fromMillisecondsSinceEpoch(0),
      likes: likes,
      isLikedByMe: isLikedByMe,
      ownerResponse: ownerResponse?.toEntity(),
    );
  }

  factory ReviewDto.fromEntity(Review entity) {
    return ReviewDto(
      id: entity.id,
      propertyId: entity.propertyId,
      bookingId: entity.bookingId,
      userId: entity.userId,
      userName: entity.userName,
      userRole: entity.userRole,
      userAvatar: entity.userAvatar,
      rating: entity.rating,
      comment: entity.comment,
      photos: entity.photos,
      createdAt: entity.createdAt.toIso8601String(),
      likes: entity.likes,
      isLikedByMe: entity.isLikedByMe,
      ownerResponse: entity.ownerResponse != null
          ? ReviewReplyDto.fromEntity(entity.ownerResponse!)
          : null,
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

class ReviewReplyDto extends Equatable {
  final String id;
  final String userId;
  final String userName;
  final String comment;
  final String createdAt;

  const ReviewReplyDto({
    required this.id,
    required this.userId,
    required this.userName,
    required this.comment,
    required this.createdAt,
  });

  factory ReviewReplyDto.fromJson(Map<String, dynamic> json) {
    return ReviewReplyDto(
      id: json['id'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      comment: json['comment'] as String,
      createdAt: json['createdAt'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'comment': comment,
      'createdAt': createdAt,
    };
  }

  ReviewReply toEntity() {
    return ReviewReply(
      id: id,
      userId: userId,
      userName: userName,
      comment: comment,
      createdAt: DateTime.tryParse(createdAt) ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  factory ReviewReplyDto.fromEntity(ReviewReply entity) {
    return ReviewReplyDto(
      id: entity.id,
      userId: entity.userId,
      userName: entity.userName,
      comment: entity.comment,
      createdAt: entity.createdAt.toIso8601String(),
    );
  }

  @override
  List<Object?> get props => [id, userId, userName, comment, createdAt];
}
