import 'package:sahely/core/network/api_envelope.dart';
import '../../domain/entities/wallet_entity.dart';

/// Wallet model from API response
class WalletModel {
  final String id;
  final String userId;
  final int balance;
  final String currency;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  WalletModel({
    required this.id,
    required this.userId,
    required this.balance,
    required this.currency,
    required this.isActive,
    required this.createdAt,
    this.updatedAt,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json['id']?.toString() ?? '',
      userId: pick(json, 'user_id')?.toString() ?? '',
      balance: (json['balance'] as num?)?.toInt() ?? 0,
      currency: json['currency'] ?? 'EGP',
      isActive: pick(json, 'is_active') as bool? ?? true,
      createdAt: DateTime.parse(
          pick(json, 'created_at') ?? DateTime.now().toIso8601String()),
      updatedAt: pick(json, 'updated_at') != null
          ? DateTime.tryParse(pick(json, 'updated_at'))
          : null,
    );
  }

  /// Convert to domain entity
  WalletEntity toEntity() {
    return WalletEntity(
      id: id,
      userId: userId,
      balance: balance,
      currency: currency,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

/// Wallet transaction model
class WalletTransactionModel {
  final String id;
  final String walletId;
  final WalletTransactionType type;
  final int amount;
  final String? description;
  final WalletTransactionStatus status;
  final String? referenceId;
  final DateTime createdAt;
  final DateTime? processedAt;

  WalletTransactionModel({
    required this.id,
    required this.walletId,
    required this.type,
    required this.amount,
    this.description,
    required this.status,
    this.referenceId,
    required this.createdAt,
    this.processedAt,
  });

  factory WalletTransactionModel.fromJson(Map<String, dynamic> json) {
    return WalletTransactionModel(
      id: json['id']?.toString() ?? '',
      walletId: pick(json, 'wallet_id')?.toString() ?? '',
      type: _parseTransactionType(json['type']),
      amount: (json['amount'] as num?)?.toInt() ?? 0,
      description: json['description'],
      status: _parseTransactionStatus(json['status']),
      referenceId: pick(json, 'reference_id'),
      createdAt: DateTime.parse(
          pick(json, 'created_at') ?? DateTime.now().toIso8601String()),
      processedAt: pick(json, 'processed_at') != null
          ? DateTime.tryParse(pick(json, 'processed_at'))
          : null,
    );
  }

  static WalletTransactionType _parseTransactionType(dynamic type) {
    if (type == null) return WalletTransactionType.credit;
    final typeStr = type.toString().toLowerCase();
    return switch (typeStr) {
      'credit' => WalletTransactionType.credit,
      'debit' => WalletTransactionType.debit,
      'refund' => WalletTransactionType.refund,
      'withdrawal' => WalletTransactionType.withdrawal,
      'payment' => WalletTransactionType.payment,
      'cashback' => WalletTransactionType.cashback,
      'top_up' => WalletTransactionType.topUp,
      _ => WalletTransactionType.credit,
    };
  }

  static WalletTransactionStatus _parseTransactionStatus(dynamic status) {
    if (status == null) return WalletTransactionStatus.pending;
    final statusStr = status.toString().toLowerCase();
    return switch (statusStr) {
      'completed' => WalletTransactionStatus.completed,
      'failed' => WalletTransactionStatus.failed,
      'cancelled' => WalletTransactionStatus.cancelled,
      _ => WalletTransactionStatus.pending,
    };
  }

  /// Convert to domain entity
  WalletTransactionEntity toEntity() {
    return WalletTransactionEntity(
      id: id,
      walletId: walletId,
      type: type,
      amount: amount,
      description: description,
      status: status,
      referenceId: referenceId,
      createdAt: createdAt,
      processedAt: processedAt,
    );
  }
}

/// Withdrawal request model
class WithdrawalRequestModel {
  final String id;
  final String walletId;
  final int amount;
  final WithdrawalMethod method;
  final String? accountDetails;
  final WithdrawalStatus status;
  final String? rejectionReason;
  final DateTime createdAt;
  final DateTime? processedAt;

  WithdrawalRequestModel({
    required this.id,
    required this.walletId,
    required this.amount,
    required this.method,
    this.accountDetails,
    required this.status,
    this.rejectionReason,
    required this.createdAt,
    this.processedAt,
  });

  factory WithdrawalRequestModel.fromJson(Map<String, dynamic> json) {
    return WithdrawalRequestModel(
      id: json['id']?.toString() ?? '',
      walletId: pick(json, 'wallet_id')?.toString() ?? '',
      amount: (json['amount'] as num?)?.toInt() ?? 0,
      method: _parseWithdrawalMethod(json['method']),
      accountDetails: pick(json, 'account_details'),
      status: _parseWithdrawalStatus(json['status']),
      rejectionReason: pick(json, 'rejection_reason'),
      createdAt: DateTime.parse(
          pick(json, 'created_at') ?? DateTime.now().toIso8601String()),
      processedAt: pick(json, 'processed_at') != null
          ? DateTime.tryParse(pick(json, 'processed_at'))
          : null,
    );
  }

  static WithdrawalMethod _parseWithdrawalMethod(dynamic method) {
    if (method == null) return WithdrawalMethod.bankTransfer;
    final methodStr = method.toString().toLowerCase();
    return switch (methodStr) {
      'bank_transfer' => WithdrawalMethod.bankTransfer,
      'instant' => WithdrawalMethod.instant,
      _ => WithdrawalMethod.bankTransfer,
    };
  }

  static WithdrawalStatus _parseWithdrawalStatus(dynamic status) {
    if (status == null) return WithdrawalStatus.pending;
    final statusStr = status.toString().toLowerCase();
    return switch (statusStr) {
      'processing' => WithdrawalStatus.processing,
      'completed' => WithdrawalStatus.completed,
      'failed' => WithdrawalStatus.failed,
      'rejected' => WithdrawalStatus.rejected,
      _ => WithdrawalStatus.pending,
    };
  }

  /// Convert to domain entity
  WithdrawalRequestEntity toEntity() {
    return WithdrawalRequestEntity(
      id: id,
      walletId: walletId,
      amount: amount,
      method: method,
      accountDetails: accountDetails,
      status: status,
      rejectionReason: rejectionReason,
      createdAt: createdAt,
      processedAt: processedAt,
    );
  }
}
