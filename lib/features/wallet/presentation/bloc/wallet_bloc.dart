import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/wallet_entity.dart';
import '../../domain/usecases/get_wallet_usecase.dart';
import '../../domain/usecases/get_wallet_transactions_usecase.dart';

// Events
abstract class WalletEvent extends Equatable {
  const WalletEvent();

  @override
  List<Object?> get props => [];
}

class LoadWalletEvent extends WalletEvent {
  const LoadWalletEvent();
}

class LoadWalletTransactionsEvent extends WalletEvent {
  final int page;
  final int limit;
  final WalletTransactionType? type;

  const LoadWalletTransactionsEvent({
    this.page = 1,
    this.limit = 20,
    this.type,
  });

  @override
  List<Object?> get props => [page, limit, type];
}

class RequestWithdrawalEvent extends WalletEvent {
  final int amount;
  final WithdrawalMethod method;
  final String? accountDetails;

  const RequestWithdrawalEvent({
    required this.amount,
    required this.method,
    this.accountDetails,
  });

  @override
  List<Object?> get props => [amount, method, accountDetails];
}

// States
abstract class WalletState extends Equatable {
  const WalletState();

  @override
  List<Object?> get props => [];
}

class WalletInitial extends WalletState {}

class WalletLoading extends WalletState {}

class WalletLoaded extends WalletState {
  final WalletEntity wallet;

  const WalletLoaded(this.wallet);

  @override
  List<Object?> get props => [wallet];
}

class WalletTransactionsLoaded extends WalletState {
  final List<WalletTransactionEntity> transactions;
  final bool hasMore;

  const WalletTransactionsLoaded(this.transactions, {this.hasMore = true});

  @override
  List<Object?> get props => [transactions, hasMore];
}

class WithdrawalRequested extends WalletState {
  final WithdrawalRequestEntity withdrawal;

  const WithdrawalRequested(this.withdrawal);

  @override
  List<Object?> get props => [withdrawal];
}

class WalletError extends WalletState {
  final String message;

  const WalletError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final GetWalletUseCase getWalletUseCase;
  final GetWalletTransactionsUseCase getWalletTransactionsUseCase;

  WalletBloc({
    required this.getWalletUseCase,
    required this.getWalletTransactionsUseCase,
  }) : super(WalletInitial()) {
    on<LoadWalletEvent>(_onLoadWallet);
    on<LoadWalletTransactionsEvent>(_onLoadWalletTransactions);
    on<RequestWithdrawalEvent>(_onRequestWithdrawal);
  }

  Future<void> _onLoadWallet(
    LoadWalletEvent event,
    Emitter<WalletState> emit,
  ) async {
    emit(WalletLoading());
    final result = await getWalletUseCase();

    result.fold(
      (failure) => emit(WalletError(failure.message)),
      (wallet) => emit(WalletLoaded(wallet)),
    );
  }

  Future<void> _onLoadWalletTransactions(
    LoadWalletTransactionsEvent event,
    Emitter<WalletState> emit,
  ) async {
    emit(WalletLoading());
    final result = await getWalletTransactionsUseCase(
      page: event.page,
      limit: event.limit,
      type: event.type,
    );

    result.fold(
      (failure) => emit(WalletError(failure.message)),
      (transactions) => emit(WalletTransactionsLoaded(
        transactions,
        hasMore: transactions.length >= event.limit,
      )),
    );
  }

  Future<void> _onRequestWithdrawal(
    RequestWithdrawalEvent event,
    Emitter<WalletState> emit,
  ) async {
    emit(WalletLoading());
    // This would need a use case for requesting withdrawals
    // For now, just reload the wallet
    final result = await getWalletUseCase();

    result.fold(
      (failure) => emit(WalletError(failure.message)),
      (wallet) => emit(WalletLoaded(wallet)),
    );
  }
}
