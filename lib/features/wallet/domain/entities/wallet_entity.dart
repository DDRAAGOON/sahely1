import 'package:equatable/equatable.dart';

/// Wallet entity representing user's wallet
class WalletEntity extends Equatable {
  final String id;
  final String userId;
  final int balance; // in piastres (divide by 100 for display)
  final String currency;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const WalletEntity({
    required this.id,
    required this.userId,
    required this.balance,
    required this.currency,
    required this.isActive,
    required this.createdAt,
    this.updatedAt,
  });

  /// Get balance in EGP (divide piastres by 100)
  double get balanceInEgp => balance / 100;

  @override
  List<Object?> get props => [
        id,
        userId,
        balance,
        currency,
        isActive,
        createdAt,
        updatedAt,
      ];
}

/// Wallet transaction entity
class WalletTransactionEntity extends Equatable {
  final String id;
  final String walletId;
  final WalletTransactionType type;
  final int amount; // in piastres (divide by 100 for display)
  final String? description;
  final WalletTransactionStatus status;
  final String? referenceId; // booking ID, payment ID, etc.
  final DateTime createdAt;
  final DateTime? processedAt;

  const WalletTransactionEntity({
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

  /// Get amount in EGP (divide piastres by 100)
  double get amountInEgp => amount / 100;

  /// Check if transaction is a credit (incoming money)
  bool get isCredit =>
      type == WalletTransactionType.credit ||
      type == WalletTransactionType.refund ||
      type == WalletTransactionType.cashback;

  /// Check if transaction is a debit (outgoing money)
  bool get isDebit =>
      type == WalletTransactionType.debit ||
      type == WalletTransactionType.withdrawal ||
      type == WalletTransactionType.payment;

  @override
  List<Object?> get props => [
        id,
        walletId,
        type,
        amount,
        description,
        status,
        referenceId,
        createdAt,
        processedAt,
      ];
}

/// Wallet transaction type enum
enum WalletTransactionType {
  credit,
  debit,
  refund,
  withdrawal,
  payment,
  cashback,
  topUp,
}

extension WalletTransactionTypeX on WalletTransactionType {
  String get displayName => switch (this) {
        WalletTransactionType.credit => 'Credit',
        WalletTransactionType.debit => 'Debit',
        WalletTransactionType.refund => 'Refund',
        WalletTransactionType.withdrawal => 'Withdrawal',
        WalletTransactionType.payment => 'Payment',
        WalletTransactionType.cashback => 'Cashback',
        WalletTransactionType.topUp => 'Top Up',
      };
}

/// Wallet transaction status enum
enum WalletTransactionStatus {
  pending,
  completed,
  failed,
  cancelled,
}

extension WalletTransactionStatusX on WalletTransactionStatus {
  String get displayName => switch (this) {
        WalletTransactionStatus.pending => 'Pending',
        WalletTransactionStatus.completed => 'Completed',
        WalletTransactionStatus.failed => 'Failed',
        WalletTransactionStatus.cancelled => 'Cancelled',
      };
}

/// Withdrawal request entity
class WithdrawalRequestEntity extends Equatable {
  final String id;
  final String walletId;
  final int amount; // in piastres
  final WithdrawalMethod method;
  final String? accountDetails;
  final WithdrawalStatus status;
  final String? rejectionReason;
  final DateTime createdAt;
  final DateTime? processedAt;

  const WithdrawalRequestEntity({
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

  /// Get amount in EGP (divide piastres by 100)
  double get amountInEgp => amount / 100;

  @override
  List<Object?> get props => [
        id,
        walletId,
        amount,
        method,
        accountDetails,
        status,
        rejectionReason,
        createdAt,
        processedAt,
      ];
}

/// Withdrawal method enum
enum WithdrawalMethod {
  bankTransfer,
  instant,
}

extension WithdrawalMethodX on WithdrawalMethod {
  String get displayName => switch (this) {
        WithdrawalMethod.bankTransfer => 'Bank Transfer',
        WithdrawalMethod.instant => 'Instant Withdrawal',
      };
}

/// Withdrawal status enum
enum WithdrawalStatus {
  pending,
  processing,
  completed,
  failed,
  rejected,
}

extension WithdrawalStatusX on WithdrawalStatus {
  String get displayName => switch (this) {
        WithdrawalStatus.pending => 'Pending',
        WithdrawalStatus.processing => 'Processing',
        WithdrawalStatus.completed => 'Completed',
        WithdrawalStatus.failed => 'Failed',
        WithdrawalStatus.rejected => 'Rejected',
      };
}
