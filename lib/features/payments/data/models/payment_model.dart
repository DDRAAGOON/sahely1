import 'package:sahely/core/network/api_envelope.dart';
import '../../domain/entities/payment_entity.dart';

/// Payment model from API response
class PaymentModel {
  final String id;
  final String bookingId;
  final int amount;
  final PaymentMethod method;
  final PaymentStatus status;
  final String? transactionId;
  final DateTime createdAt;
  final DateTime? processedAt;
  final String? failureReason;
  final String currency;

  PaymentModel({
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

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id']?.toString() ?? '',
      bookingId: pick(json, 'booking_id')?.toString() ?? '',
      amount: (json['amount'] as num?)?.toInt() ?? 0,
      method: _parsePaymentMethod(json['method']),
      status: _parsePaymentStatus(json['status']),
      transactionId: pick(json, 'transaction_id'),
      createdAt: DateTime.parse(
          pick(json, 'created_at') ?? DateTime.now().toIso8601String()),
      processedAt: pick(json, 'processed_at') != null
          ? DateTime.tryParse(pick(json, 'processed_at'))
          : null,
      failureReason: pick(json, 'failure_reason'),
      currency: json['currency'] ?? 'EGP',
    );
  }

  static PaymentMethod _parsePaymentMethod(dynamic method) {
    if (method == null) return PaymentMethod.card;
    final methodStr = method.toString().toLowerCase();
    return switch (methodStr) {
      'card' => PaymentMethod.card,
      'wallet' => PaymentMethod.wallet,
      'cash' => PaymentMethod.cash,
      _ => PaymentMethod.card,
    };
  }

  static PaymentStatus _parsePaymentStatus(dynamic status) {
    if (status == null) return PaymentStatus.pending;
    final statusStr = status.toString().toLowerCase();
    return switch (statusStr) {
      'processing' => PaymentStatus.processing,
      'completed' => PaymentStatus.completed,
      'failed' => PaymentStatus.failed,
      'refunded' => PaymentStatus.refunded,
      'partially_refunded' => PaymentStatus.partiallyRefunded,
      _ => PaymentStatus.pending,
    };
  }

  /// Convert to domain entity
  PaymentEntity toEntity() {
    return PaymentEntity(
      id: id,
      bookingId: bookingId,
      amount: amount,
      method: method,
      status: status,
      transactionId: transactionId,
      createdAt: createdAt,
      processedAt: processedAt,
      failureReason: failureReason,
      currency: currency,
    );
  }
}

/// Payment card model
class PaymentCardModel {
  final String id;
  final String lastFourDigits;
  final String brand;
  final String? holderName;
  final DateTime? expiryDate;
  final bool isDefault;
  final bool isActive;

  PaymentCardModel({
    required this.id,
    required this.lastFourDigits,
    required this.brand,
    this.holderName,
    this.expiryDate,
    required this.isDefault,
    required this.isActive,
  });

  factory PaymentCardModel.fromJson(Map<String, dynamic> json) {
    return PaymentCardModel(
      id: json['id']?.toString() ?? '',
      lastFourDigits: pick(json, 'last_four_digits') ?? '',
      brand: json['brand'] ?? '',
      holderName: pick(json, 'holder_name'),
      expiryDate: pick(json, 'expiry_date') != null
          ? DateTime.tryParse(pick(json, 'expiry_date'))
          : null,
      isDefault: pick(json, 'is_default') as bool? ?? false,
      isActive: pick(json, 'is_active') as bool? ?? true,
    );
  }

  /// Convert to domain entity
  PaymentCardEntity toEntity() {
    return PaymentCardEntity(
      id: id,
      lastFourDigits: lastFourDigits,
      brand: brand,
      holderName: holderName,
      expiryDate: expiryDate,
      isDefault: isDefault,
      isActive: isActive,
    );
  }
}

/// Payment initiation result model
class PaymentInitiationResultModel {
  final String paymentId;
  final String? redirectUrl;
  final String? clientSecret;
  final PaymentStatus status;

  PaymentInitiationResultModel({
    required this.paymentId,
    this.redirectUrl,
    this.clientSecret,
    required this.status,
  });

  factory PaymentInitiationResultModel.fromJson(Map<String, dynamic> json) {
    return PaymentInitiationResultModel(
      paymentId: pick(json, 'payment_id')?.toString() ?? '',
      redirectUrl: pick(json, 'redirect_url'),
      clientSecret: pick(json, 'client_secret'),
      status: PaymentModel._parsePaymentStatus(json['status']),
    );
  }

  /// Convert to domain entity
  PaymentInitiationResult toEntity() {
    return PaymentInitiationResult(
      paymentId: paymentId,
      redirectUrl: redirectUrl,
      clientSecret: clientSecret,
      status: status,
    );
  }
}
