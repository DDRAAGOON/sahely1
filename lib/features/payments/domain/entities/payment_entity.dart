import 'package:equatable/equatable.dart';

/// Payment entity representing a payment transaction
class PaymentEntity extends Equatable {
  final String id;
  final String bookingId;
  final int amount; // in piastres (divide by 100 for display)
  final PaymentMethod method;
  final PaymentStatus status;
  final String? transactionId;
  final DateTime createdAt;
  final DateTime? processedAt;
  final String? failureReason;
  final String currency;

  const PaymentEntity({
    required this.id,
    required this.bookingId,
    required this.amount,
    required this.method,
    required this.status,
    this.transactionId,
    required this.createdAt,
    this.processedAt,
    this.failureReason,
    required this.currency,
  });

  /// Get amount in EGP (divide piastres by 100)
  double get amountInEgp => amount / 100;

  @override
  List<Object?> get props => [
        id,
        bookingId,
        amount,
        method,
        status,
        transactionId,
        createdAt,
        processedAt,
        failureReason,
        currency,
      ];
}

/// Payment method enum
enum PaymentMethod {
  card,
  wallet,
  cash,
}

extension PaymentMethodX on PaymentMethod {
  String get displayName => switch (this) {
        PaymentMethod.card => 'Credit/Debit Card',
        PaymentMethod.wallet => 'Sahely Wallet',
        PaymentMethod.cash => 'Cash',
      };
}

/// Payment status enum
enum PaymentStatus {
  pending,
  processing,
  completed,
  failed,
  refunded,
  partiallyRefunded,
}

extension PaymentStatusX on PaymentStatus {
  String get displayName => switch (this) {
        PaymentStatus.pending => 'Pending',
        PaymentStatus.processing => 'Processing',
        PaymentStatus.completed => 'Completed',
        PaymentStatus.failed => 'Failed',
        PaymentStatus.refunded => 'Refunded',
        PaymentStatus.partiallyRefunded => 'Partially Refunded',
      };

  bool get isSuccess => this == PaymentStatus.completed;
  bool get isFailed => this == PaymentStatus.failed;
  bool get isPending =>
      this == PaymentStatus.pending || this == PaymentStatus.processing;
}

/// Payment card entity
class PaymentCardEntity extends Equatable {
  final String id;
  final String lastFourDigits;
  final String brand; // visa, mastercard, etc.
  final String? holderName;
  final DateTime? expiryDate;
  final bool isDefault;
  final bool isActive;

  const PaymentCardEntity({
    required this.id,
    required this.lastFourDigits,
    required this.brand,
    this.holderName,
    this.expiryDate,
    required this.isDefault,
    required this.isActive,
  });

  String get maskedNumber => '**** **** **** $lastFourDigits';

  @override
  List<Object?> get props => [
        id,
        lastFourDigits,
        brand,
        holderName,
        expiryDate,
        isDefault,
        isActive,
      ];
}

/// Payment initiation request
class PaymentInitiationRequest extends Equatable {
  final String bookingId;
  final PaymentMethod method;
  final String? cardId;
  final int amount; // in piastres
  final String currency;

  const PaymentInitiationRequest({
    required this.bookingId,
    required this.method,
    this.cardId,
    required this.amount,
    required this.currency,
  });

  /// Get amount in EGP (divide piastres by 100)
  double get amountInEgp => amount / 100;

  @override
  List<Object?> get props => [bookingId, method, cardId, amount, currency];
}

/// Payment initiation result
class PaymentInitiationResult extends Equatable {
  final String paymentId;
  final String? redirectUrl;
  final String? clientSecret;
  final PaymentStatus status;

  const PaymentInitiationResult({
    required this.paymentId,
    this.redirectUrl,
    this.clientSecret,
    required this.status,
  });

  @override
  List<Object?> get props => [paymentId, redirectUrl, clientSecret, status];
}
