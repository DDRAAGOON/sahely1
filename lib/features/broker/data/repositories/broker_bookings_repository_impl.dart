import 'package:sahely/core/errors/exception_mapper.dart';
import 'package:sahely/features/broker/data/datasources/mock_broker_bookings_data_source.dart';
import 'package:sahely/features/broker/domain/entities/broker_booking.dart';
import 'package:sahely/features/broker/domain/repositories/broker_bookings_repository.dart';

class BrokerBookingsRepositoryImpl implements BrokerBookingsRepository {
  final MockBrokerBookingsDataSource dataSource;

  BrokerBookingsRepositoryImpl({required this.dataSource});

  @override
  Future<List<BrokerBooking>> getBookings() async {
    try {
      final dtos = await dataSource.fetchBookings();
      return dtos.map((dto) => dto.toEntity()).toList();
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }
}
