import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/payment_entity.dart';
import '../../domain/usecases/initiate_payment_usecase.dart';
import '../../domain/usecases/get_payment_cards_usecase.dart';

// Events
abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

class InitiatePaymentEvent extends PaymentEvent {
  final PaymentInitiationRequest request;

  const InitiatePaymentEvent(this.request);

  @override
  List<Object?> get props => [request];
}

class LoadPaymentCardsEvent extends PaymentEvent {
  const LoadPaymentCardsEvent();
}

class AddPaymentCardEvent extends PaymentEvent {
  final String token;
  final String lastFourDigits;
  final String brand;
  final String? holderName;
  final DateTime? expiryDate;

  const AddPaymentCardEvent({
    required this.token,
    required this.lastFourDigits,
    required this.brand,
    this.holderName,
    this.expiryDate,
  });

  @override
  List<Object?> get props =>
      [token, lastFourDigits, brand, holderName, expiryDate];
}

class DeletePaymentCardEvent extends PaymentEvent {
  final String cardId;

  const DeletePaymentCardEvent(this.cardId);

  @override
  List<Object?> get props => [cardId];
}

class SetDefaultCardEvent extends PaymentEvent {
  final String cardId;

  const SetDefaultCardEvent(this.cardId);

  @override
  List<Object?> get props => [cardId];
}

// States
abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object?> get props => [];
}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentInitiated extends PaymentState {
  final PaymentInitiationResult result;

  const PaymentInitiated(this.result);

  @override
  List<Object?> get props => [result];
}

class PaymentCardsLoaded extends PaymentState {
  final List<PaymentCardEntity> cards;

  const PaymentCardsLoaded(this.cards);

  @override
  List<Object?> get props => [cards];
}

class PaymentCardAdded extends PaymentState {
  final PaymentCardEntity card;

  const PaymentCardAdded(this.card);

  @override
  List<Object?> get props => [card];
}

class PaymentCardDeleted extends PaymentState {
  final String cardId;

  const PaymentCardDeleted(this.cardId);

  @override
  List<Object?> get props => [cardId];
}

class DefaultCardSet extends PaymentState {
  final PaymentCardEntity card;

  const DefaultCardSet(this.card);

  @override
  List<Object?> get props => [card];
}

class PaymentError extends PaymentState {
  final String message;

  const PaymentError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final InitiatePaymentUseCase initiatePaymentUseCase;
  final GetPaymentCardsUseCase getPaymentCardsUseCase;

  PaymentBloc({
    required this.initiatePaymentUseCase,
    required this.getPaymentCardsUseCase,
  }) : super(PaymentInitial()) {
    on<InitiatePaymentEvent>(_onInitiatePayment);
    on<LoadPaymentCardsEvent>(_onLoadPaymentCards);
    on<AddPaymentCardEvent>(_onAddPaymentCard);
    on<DeletePaymentCardEvent>(_onDeletePaymentCard);
    on<SetDefaultCardEvent>(_onSetDefaultCard);
  }

  Future<void> _onInitiatePayment(
    InitiatePaymentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());
    final result = await initiatePaymentUseCase(event.request);

    result.fold(
      (failure) => emit(PaymentError(failure.message)),
      (initiationResult) => emit(PaymentInitiated(initiationResult)),
    );
  }

  Future<void> _onLoadPaymentCards(
    LoadPaymentCardsEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());
    final result = await getPaymentCardsUseCase();

    result.fold(
      (failure) => emit(PaymentError(failure.message)),
      (cards) => emit(PaymentCardsLoaded(cards)),
    );
  }

  Future<void> _onAddPaymentCard(
    AddPaymentCardEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());
    // This would need a use case for adding cards
    // For now, just reload the cards
    final result = await getPaymentCardsUseCase();

    result.fold(
      (failure) => emit(PaymentError(failure.message)),
      (cards) => emit(PaymentCardsLoaded(cards)),
    );
  }

  Future<void> _onDeletePaymentCard(
    DeletePaymentCardEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());
    // This would need a use case for deleting cards
    // For now, just reload the cards
    final result = await getPaymentCardsUseCase();

    result.fold(
      (failure) => emit(PaymentError(failure.message)),
      (cards) => emit(PaymentCardsLoaded(cards)),
    );
  }

  Future<void> _onSetDefaultCard(
    SetDefaultCardEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());
    // This would need a use case for setting default card
    // For now, just reload the cards
    final result = await getPaymentCardsUseCase();

    result.fold(
      (failure) => emit(PaymentError(failure.message)),
      (cards) => emit(PaymentCardsLoaded(cards)),
    );
  }
}
