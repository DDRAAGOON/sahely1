import 'package:sahely/core/network/api_envelope.dart';
import '../../domain/entities/booking_entity.dart';

/// Booking model from API response
class BookingModel {
  final String id;
  final String propertyId;
  final String propertyTitle;
  final String propertyLocation;
  final String? propertyImage;
  final String userId;
  final String? userName;
  final DateTime checkIn;
  final DateTime checkOut;
  final int totalPrice;
  final int guests;
  final BookingStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? specialRequests;
  final List<BookingChecklistModel>? checklists;
  final PaymentStatus paymentStatus;
  final int? nights;

  BookingModel({
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

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id']?.toString() ?? '',
      propertyId: pick(json, 'property_id')?.toString() ?? '',
      propertyTitle: pick(json, 'property_title') ?? '',
      propertyLocation: pick(json, 'property_location') ?? '',
      propertyImage: pick(json, 'property_image'),
      userId: pick(json, 'user_id')?.toString() ?? '',
      userName: pick(json, 'user_name'),
      checkIn: DateTime.parse(
          pick(json, 'check_in') ?? DateTime.now().toIso8601String()),
      checkOut: DateTime.parse(
          pick(json, 'check_out') ?? DateTime.now().toIso8601String()),
      totalPrice: (pick(json, 'total_price') as num?)?.toInt() ?? 0,
      guests: json['guests'] as int? ?? 0,
      status: _parseBookingStatus(json['status']),
      createdAt: DateTime.parse(
          pick(json, 'created_at') ?? DateTime.now().toIso8601String()),
      updatedAt: pick(json, 'updated_at') != null
          ? DateTime.tryParse(pick(json, 'updated_at'))
          : null,
      specialRequests: pick(json, 'special_requests'),
      checklists: (json['checklists'] as List<dynamic>?)
          ?.map(
              (e) => BookingChecklistModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      paymentStatus: _parsePaymentStatus(pick(json, 'payment_status')),
      nights: json['nights'] as int?,
    );
  }

  static BookingStatus _parseBookingStatus(dynamic status) {
    if (status == null) return BookingStatus.pending;
    final statusStr = status.toString().toLowerCase();
    return switch (statusStr) {
      'confirmed' => BookingStatus.confirmed,
      'checked_in' => BookingStatus.checkedIn,
      'checked_out' => BookingStatus.checkedOut,
      'cancelled' => BookingStatus.cancelled,
      'completed' => BookingStatus.completed,
      'disputed' => BookingStatus.disputed,
      _ => BookingStatus.pending,
    };
  }

  static PaymentStatus _parsePaymentStatus(dynamic status) {
    if (status == null) return PaymentStatus.pending;
    final statusStr = status.toString().toLowerCase();
    return switch (statusStr) {
      'paid' => PaymentStatus.paid,
      'failed' => PaymentStatus.failed,
      'refunded' => PaymentStatus.refunded,
      'partially_refunded' => PaymentStatus.partiallyRefunded,
      _ => PaymentStatus.pending,
    };
  }

  /// Convert to domain entity
  BookingEntity toEntity() {
    return BookingEntity(
      id: id,
      propertyId: propertyId,
      propertyTitle: propertyTitle,
      propertyLocation: propertyLocation,
      propertyImage: propertyImage,
      userId: userId,
      userName: userName,
      checkIn: checkIn,
      checkOut: checkOut,
      totalPrice: totalPrice,
      guests: guests,
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
      specialRequests: specialRequests,
      checklists: checklists?.map((e) => e.toEntity()).toList(),
      paymentStatus: paymentStatus,
      nights: nights,
    );
  }
}

/// Booking checklist model
class BookingChecklistModel {
  final String id;
  final String type;
  final String role;
  final Map<String, bool> items;
  final bool isCompleted;
  final DateTime? completedAt;

  BookingChecklistModel({
    required this.id,
    required this.type,
    required this.role,
    required this.items,
    required this.isCompleted,
    this.completedAt,
  });

  factory BookingChecklistModel.fromJson(Map<String, dynamic> json) {
    return BookingChecklistModel(
      id: json['id']?.toString() ?? '',
      type: json['type'] ?? '',
      role: json['role'] ?? '',
      items: (json['items'] as Map<String, dynamic>?)
              ?.map((key, value) => MapEntry(key, value as bool)) ??
          {},
      isCompleted: pick(json, 'is_completed') as bool? ?? false,
      completedAt: pick(json, 'completed_at') != null
          ? DateTime.tryParse(pick(json, 'completed_at'))
          : null,
    );
  }

  /// Convert to domain entity
  BookingChecklistEntity toEntity() {
    return BookingChecklistEntity(
      id: id,
      type: type,
      role: role,
      items: items,
      isCompleted: isCompleted,
      completedAt: completedAt,
    );
  }
}

/// Booking calculation result model
class BookingCalculationResultModel {
  final int basePrice;
  final int cleaningFee;
  final int serviceFee;
  final int taxes;
  final int totalPrice;
  final int nights;
  final String currency;

  BookingCalculationResultModel({
    required this.basePrice,
    required this.cleaningFee,
    required this.serviceFee,
    required this.taxes,
    required this.totalPrice,
    required this.nights,
    required this.currency,
  });

  factory BookingCalculationResultModel.fromJson(Map<String, dynamic> json) {
    return BookingCalculationResultModel(
      basePrice: (pick(json, 'base_price') as num?)?.toInt() ?? 0,
      cleaningFee: (pick(json, 'cleaning_fee') as num?)?.toInt() ?? 0,
      serviceFee: (pick(json, 'service_fee') as num?)?.toInt() ?? 0,
      taxes: (json['taxes'] as num?)?.toInt() ?? 0,
      totalPrice: (pick(json, 'total_price') as num?)?.toInt() ?? 0,
      nights: json['nights'] as int? ?? 0,
      currency: json['currency'] ?? 'EGP',
    );
  }

  /// Convert to domain entity
  BookingCalculationResult toEntity() {
    return BookingCalculationResult(
      basePrice: basePrice,
      cleaningFee: cleaningFee,
      serviceFee: serviceFee,
      taxes: taxes,
      totalPrice: totalPrice,
      nights: nights,
      currency: currency,
    );
  }
}
