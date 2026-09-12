import 'package:equatable/equatable.dart';

/// Booking entity representing a property booking
class BookingEntity extends Equatable {
  final String id;
  final String propertyId;
  final String propertyTitle;
  final String propertyLocation;
  final String? propertyImage;
  final String userId;
  final String? userName;
  final DateTime checkIn;
  final DateTime checkOut;
  final int totalPrice; // in piastres (divide by 100 for display)
  final int guests;
  final BookingStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? specialRequests;
  final List<BookingChecklistEntity>? checklists;
  final PaymentStatus paymentStatus;
  final int? nights;

  const BookingEntity({
    required this.id,
    required this.propertyId,
    required this.propertyTitle,
    required this.propertyLocation,
    this.propertyImage,
    required this.userId,
    this.userName,
    required this.checkIn,
    required this.checkOut,
    required this.totalPrice,
    required this.guests,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.specialRequests,
    this.checklists,
    required this.paymentStatus,
    this.nights,
  });

  /// Get total price in EGP (divide piastres by 100)
  double get totalPriceInEgp => totalPrice / 100;

  /// Calculate number of nights if not provided
  int get calculatedNights {
    if (nights != null) return nights!;
    return checkOut.difference(checkIn).inDays;
  }

  @override
  List<Object?> get props => [
        id,
        propertyId,
        propertyTitle,
        propertyLocation,
        propertyImage,
        userId,
        userName,
        checkIn,
        checkOut,
        totalPrice,
        guests,
        status,
        createdAt,
        updatedAt,
        specialRequests,
        checklists,
        paymentStatus,
        nights,
      ];
}

/// Booking status enum
enum BookingStatus {
  pending,
  confirmed,
  checkedIn,
  checkedOut,
  cancelled,
  completed,
  disputed,
}

extension BookingStatusX on BookingStatus {
  String get displayName => switch (this) {
        BookingStatus.pending => 'Pending',
        BookingStatus.confirmed => 'Confirmed',
        BookingStatus.checkedIn => 'Checked In',
        BookingStatus.checkedOut => 'Checked Out',
        BookingStatus.cancelled => 'Cancelled',
        BookingStatus.completed => 'Completed',
        BookingStatus.disputed => 'Disputed',
      };

  bool get isActive =>
      this == BookingStatus.confirmed ||
      this == BookingStatus.checkedIn ||
      this == BookingStatus.pending;

  bool get isPast =>
      this == BookingStatus.completed ||
      this == BookingStatus.cancelled ||
      this == BookingStatus.checkedOut;

  bool get isUpcoming =>
      this == BookingStatus.pending || this == BookingStatus.confirmed;
}

/// Payment status enum
enum PaymentStatus {
  pending,
  paid,
  failed,
  refunded,
  partiallyRefunded,
}

extension PaymentStatusX on PaymentStatus {
  String get displayName => switch (this) {
        PaymentStatus.pending => 'Pending',
        PaymentStatus.paid => 'Paid',
        PaymentStatus.failed => 'Failed',
        PaymentStatus.refunded => 'Refunded',
        PaymentStatus.partiallyRefunded => 'Partially Refunded',
      };
}

/// Booking checklist entity
class BookingChecklistEntity extends Equatable {
  final String id;
  final String type; // arrival, departure
  final String role; // renter, owner
  final Map<String, bool> items;
  final bool isCompleted;
  final DateTime? completedAt;

  const BookingChecklistEntity({
    required this.id,
    required this.type,
    required this.role,
    required this.items,
    required this.isCompleted,
    this.completedAt,
  });

  @override
  List<Object?> get props => [id, type, role, items, isCompleted, completedAt];
}

/// Booking calculation request
class BookingCalculationRequest extends Equatable {
  final String propertyId;
  final DateTime checkIn;
  final DateTime checkOut;
  final int guests;

  const BookingCalculationRequest({
    required this.propertyId,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
  });

  @override
  List<Object?> get props => [propertyId, checkIn, checkOut, guests];
}

/// Booking calculation result
class BookingCalculationResult extends Equatable {
  final int basePrice; // in piastres
  final int cleaningFee; // in piastres
  final int serviceFee; // in piastres
  final int taxes; // in piastres
  final int totalPrice; // in piastres
  final int nights;
  final String currency;

  const BookingCalculationResult({
    required this.basePrice,
    required this.cleaningFee,
    required this.serviceFee,
    required this.taxes,
    required this.totalPrice,
    required this.nights,
    required this.currency,
  });

  /// Get prices in EGP (divide piastres by 100)
  double get basePriceInEgp => basePrice / 100;
  double get cleaningFeeInEgp => cleaningFee / 100;
  double get serviceFeeInEgp => serviceFee / 100;
  double get taxesInEgp => taxes / 100;
  double get totalPriceInEgp => totalPrice / 100;

  @override
  List<Object?> get props => [
        basePrice,
        cleaningFee,
        serviceFee,
        taxes,
        totalPrice,
        nights,
        currency,
      ];
}
