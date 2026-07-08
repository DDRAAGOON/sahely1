import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/repositories/broker_bookings_repository.dart';

class BrokerBookingsCubit extends Cubit<void> {
  final BrokerBookingsRepository _repository;
  BrokerBookingsCubit(this._repository) : super(null);
}
