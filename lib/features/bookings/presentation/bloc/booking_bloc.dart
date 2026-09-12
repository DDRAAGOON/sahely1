import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/booking_entity.dart';
import '../../domain/usecases/create_booking_usecase.dart';
import '../../domain/usecases/calculate_booking_usecase.dart';
import '../../domain/usecases/get_my_bookings_usecase.dart';
import '../../domain/usecases/cancel_booking_usecase.dart';

// Events
abstract class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object?> get props => [];
}

class CreateBookingEvent extends BookingEvent {
  final String propertyId;
  final DateTime checkIn;
  final DateTime checkOut;
  final int guests;
  final String? specialRequests;

  const CreateBookingEvent({
    required this.propertyId,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
    this.specialRequests,
  });

  @override
  List<Object?> get props =>
      [propertyId, checkIn, checkOut, guests, specialRequests];
}

class CalculateBookingEvent extends BookingEvent {
  final BookingCalculationRequest request;

  const CalculateBookingEvent(this.request);

  @override
  List<Object?> get props => [request];
}

class LoadMyBookingsEvent extends BookingEvent {
  final BookingStatus? status;
  final int page;
  final int limit;

  const LoadMyBookingsEvent({
    this.status,
    this.page = 1,
    this.limit = 20,
  });

  @override
  List<Object?> get props => [status, page, limit];
}

class CancelBookingEvent extends BookingEvent {
  final String bookingId;

  const CancelBookingEvent(this.bookingId);

  @override
  List<Object?> get props => [bookingId];
}

// States
abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object?> get props => [];
}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingCreated extends BookingState {
  final BookingEntity booking;

  const BookingCreated(this.booking);

  @override
  List<Object?> get props => [booking];
}

class BookingCalculated extends BookingState {
  final BookingCalculationResult result;

  const BookingCalculated(this.result);

  @override
  List<Object?> get props => [result];
}

class BookingsLoaded extends BookingState {
  final List<BookingEntity> bookings;
  final bool hasMore;

  const BookingsLoaded(this.bookings, {this.hasMore = true});

  @override
  List<Object?> get props => [bookings, hasMore];
}

class BookingCancelled extends BookingState {
  final BookingEntity booking;

  const BookingCancelled(this.booking);

  @override
  List<Object?> get props => [booking];
}

class BookingError extends BookingState {
  final String message;

  const BookingError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final CreateBookingUseCase createBookingUseCase;
  final CalculateBookingUseCase calculateBookingUseCase;
  final GetMyBookingsUseCase getMyBookingsUseCase;
  final CancelBookingUseCase cancelBookingUseCase;

  BookingBloc({
    required this.createBookingUseCase,
    required this.calculateBookingUseCase,
    required this.getMyBookingsUseCase,
    required this.cancelBookingUseCase,
  }) : super(BookingInitial()) {
    on<CreateBookingEvent>(_onCreateBooking);
    on<CalculateBookingEvent>(_onCalculateBooking);
    on<LoadMyBookingsEvent>(_onLoadMyBookings);
    on<CancelBookingEvent>(_onCancelBooking);
  }

  Future<void> _onCreateBooking(
    CreateBookingEvent event,
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading());
    final result = await createBookingUseCase(
      propertyId: event.propertyId,
      checkIn: event.checkIn,
      checkOut: event.checkOut,
      guests: event.guests,
      specialRequests: event.specialRequests,
    );

    result.fold(
      (failure) => emit(BookingError(failure.message)),
      (booking) => emit(BookingCreated(booking)),
    );
  }

  Future<void> _onCalculateBooking(
    CalculateBookingEvent event,
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading());
    final result = await calculateBookingUseCase(event.request);

    result.fold(
      (failure) => emit(BookingError(failure.message)),
      (calculation) => emit(BookingCalculated(calculation)),
    );
  }

  Future<void> _onLoadMyBookings(
    LoadMyBookingsEvent event,
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading());
    final result = await getMyBookingsUseCase(
      status: event.status,
      page: event.page,
      limit: event.limit,
    );

    result.fold(
      (failure) => emit(BookingError(failure.message)),
      (bookings) => emit(BookingsLoaded(
        bookings,
        hasMore: bookings.length >= event.limit,
      )),
    );
  }

  Future<void> _onCancelBooking(
    CancelBookingEvent event,
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading());
    final result = await cancelBookingUseCase(event.bookingId);

    result.fold(
      (failure) => emit(BookingError(failure.message)),
      (booking) => emit(BookingCancelled(booking)),
    );
  }
}
