import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/booking.dart';
import '../../domain/use_cases/get_upcoming_bookings_use_case.dart';
import '../../domain/use_cases/get_active_bookings_use_case.dart';
import '../../domain/use_cases/get_past_bookings_use_case.dart';
import '../../domain/use_cases/book_property_use_case.dart';
import '../../domain/use_cases/update_checklist_use_case.dart';
import 'package:sahely/core/bloc/safe_emit.dart';

enum BookingsStatus { initial, loading, loaded, error }

class BookingsState extends Equatable {
  final List<Booking> upcomingBookings;
  final List<Booking> activeBookings;
  final List<Booking> pastBookings;
  final BookingsStatus status;
  final String? errorMessage;

  const BookingsState({
    this.upcomingBookings = const [],
    this.activeBookings = const [],
    this.pastBookings = const [],
    this.status = BookingsStatus.initial,
    this.errorMessage,
  });

  BookingsState copyWith({
    List<Booking>? upcomingBookings,
    List<Booking>? activeBookings,
    List<Booking>? pastBookings,
    BookingsStatus? status,
    String? errorMessage,
  }) {
    return BookingsState(
      upcomingBookings: upcomingBookings ?? this.upcomingBookings,
      activeBookings: activeBookings ?? this.activeBookings,
      pastBookings: pastBookings ?? this.pastBookings,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [upcomingBookings, activeBookings, pastBookings, status, errorMessage];
}

class BookingsCubit extends Cubit<BookingsState> with SafeEmit<BookingsState> {
  final GetUpcomingBookingsUseCase _getUpcomingBookingsUseCase;
  final GetActiveBookingsUseCase _getActiveBookingsUseCase;
  final GetPastBookingsUseCase _getPastBookingsUseCase;
  final BookPropertyUseCase _bookPropertyUseCase;
  final UpdateChecklistUseCase _updateChecklistUseCase;

  BookingsCubit({
    required GetUpcomingBookingsUseCase getUpcomingBookingsUseCase,
    required GetActiveBookingsUseCase getActiveBookingsUseCase,
    required GetPastBookingsUseCase getPastBookingsUseCase,
    required BookPropertyUseCase bookPropertyUseCase,
    required UpdateChecklistUseCase updateChecklistUseCase,
  })  : _getUpcomingBookingsUseCase = getUpcomingBookingsUseCase,
        _getActiveBookingsUseCase = getActiveBookingsUseCase,
        _getPastBookingsUseCase = getPastBookingsUseCase,
        _bookPropertyUseCase = bookPropertyUseCase,
        _updateChecklistUseCase = updateChecklistUseCase,
        super(const BookingsState());

  Future<void> loadBookings() async {
    emit(state.copyWith(status: BookingsStatus.loading));
    try {
      final upcoming = await _getUpcomingBookingsUseCase.execute();
      final active = await _getActiveBookingsUseCase.execute();
      final past = await _getPastBookingsUseCase.execute();

      emit(state.copyWith(
        upcomingBookings: upcoming,
        activeBookings: active,
        pastBookings: past,
        status: BookingsStatus.loaded,
      ));
    } catch (e) {
      emit(state.copyWith(
          status: BookingsStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> addBooking(Booking booking) async {
    try {
      await _bookPropertyUseCase.execute(booking);
      await loadBookings();
    } catch (e) {
      emit(state.copyWith(
          status: BookingsStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> updateChecklist(
      String bookingId, List<Map<String, dynamic>> newChecklist) async {
    try {
      await _updateChecklistUseCase.execute(bookingId, newChecklist);
      await loadBookings();
    } catch (e) {
      emit(state.copyWith(
          status: BookingsStatus.error, errorMessage: e.toString()));
    }
  }
}
