import 'package:equatable/equatable.dart';

class BrokerWallet extends Equatable {
  final double availableBalance;
  final double pendingBalance;
  final String tierName;
  final double commissionRate;
  final String avgPerBooking;
  final int toNextTier;
  final List<BrokerCommission> commissions;

  const BrokerWallet({
    required this.availableBalance,
    required this.pendingBalance,
    required this.tierName,
    required this.commissionRate,
    required this.avgPerBooking,
    required this.toNextTier,
    required this.commissions,
  });

  @override
  List<Object?> get props => [
        availableBalance,
        pendingBalance,
        tierName,
        commissionRate,
        avgPerBooking,
        toNextTier,
        commissions,
      ];
}

class BrokerCommission extends Equatable {
  final String propertyName;
  final DateTime date;
  final String amount;
  final String status;

  const BrokerCommission({
    required this.propertyName,
    required this.date,
    required this.amount,
    required this.status,
  });

  @override
  List<Object?> get props => [propertyName, date, amount, status];
}
