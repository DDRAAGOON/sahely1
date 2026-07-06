import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/repositories/broker_bookings_repository.dart';

enum BrokerBookingsStatus { initial, loading, loaded, error }

class BrokerBookingsState {
  final List<BrokerBooking> bookings;
  final BrokerBookingsStatus status;
  final String? errorMessage;

  BrokerBookingsState({
    this.bookings = const [],
    this.status = BrokerBookingsStatus.initial,
    this.errorMessage,
  });

  BrokerBookingsState copyWith({
    List<BrokerBooking>? bookings,
    BrokerBookingsStatus? status,
    String? errorMessage,
  }) {
    return BrokerBookingsState(
      bookings: bookings ?? this.bookings,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}

class BrokerBookingsCubit extends Cubit<BrokerBookingsState> {
  final BrokerBookingsRepository _repository;

  BrokerBookingsCubit(this._repository) : super(BrokerBookingsState());

  Future<void> loadBookings() async {
    emit(state.copyWith(status: BrokerBookingsStatus.loading));
    try {
      final bookings = await _repository.getBookings();
      emit(state.copyWith(bookings: bookings, status: BrokerBookingsStatus.loaded));
    } catch (e) {
      emit(state.copyWith(status: BrokerBookingsStatus.error, errorMessage: 'Failed to load bookings'));
    }
  }
}
