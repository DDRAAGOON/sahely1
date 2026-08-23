import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahely/features/broker/domain/entities/broker_booking.dart';
import 'package:sahely/features/broker/domain/use_cases/get_broker_bookings_use_case.dart';
import 'package:sahely/features/broker/domain/use_cases/filter_broker_bookings_use_case.dart';

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
  final GetBrokerBookingsUseCase _getBrokerBookingsUseCase;

  BrokerBookingsCubit({
    required GetBrokerBookingsUseCase getBrokerBookingsUseCase,
    required FilterBrokerBookingsUseCase filterBrokerBookingsUseCase,
  })  : _getBrokerBookingsUseCase = getBrokerBookingsUseCase,
        super(BrokerBookingsState());

  Future<void> loadBookings() async {
    emit(state.copyWith(status: BrokerBookingsStatus.loading));
    try {
      final bookings = await _getBrokerBookingsUseCase.execute();
      emit(state.copyWith(
          bookings: bookings, status: BrokerBookingsStatus.loaded));
    } catch (e) {
      emit(state.copyWith(
          status: BrokerBookingsStatus.error,
          errorMessage: 'Failed to load bookings'));
    }
  }

  void filterBookings(String query) {
    // Implementation for filtering if needed
  }
}
