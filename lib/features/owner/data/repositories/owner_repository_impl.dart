import 'package:sahely/core/errors/exception_mapper.dart';
import 'package:sahely/core/network/api_client.dart';
import 'package:sahely/core/network/api_endpoints.dart';
import 'package:sahely/core/network/api_envelope.dart';
import 'package:sahely/core/network/upload/file_upload_api.dart';
import 'package:sahely/features/owner/domain/entities/owner_dashboard.dart';
import 'package:sahely/features/owner/domain/repositories/owner_repository.dart';
import 'package:sahely/features/shared/properties/data/property_api_mapper.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';
import 'package:sahely/features/owner/domain/entities/owner_guest_booking.dart';
import 'package:sahely/features/owner/domain/entities/owner_booking_request.dart';

/// Owner repository backed by the live portfolio endpoints.
///
/// The dashboard is assembled from two calls because no single endpoint has
/// everything the header needs:
///  * `GET /properties/mine/portfolio/dashboard` - analytics only, shaped as
///    `{revenueAnalytics, occupancy, seasonality, bestPerformingProperties,
///     portfolioKPIs, operational}`. It carries no owner name and no counts.
///  * `GET /properties/mine` - the owner's listings (a bare array), which is
///    where the property count and the featured rail come from.
class OwnerRepositoryImpl implements OwnerRepository {
  final ApiClient apiClient;
  final FileUploadApi _uploads;

  OwnerRepositoryImpl({ApiClient? apiClient})
      : this._(apiClient ?? ApiClient());

  OwnerRepositoryImpl._(this.apiClient) : _uploads = FileUploadApi(apiClient);

  @override
  Future<OwnerDashboard> getOwnerDashboard() async {
    final api = apiClient;

    try {
      final dashboard = await _getMap(api, ApiEndpoints.myPortfolioDashboard);
      final properties = await getMyProperties();

      final revenue = asMap(dashboard['revenueAnalytics']);
      final operational = asMap(dashboard['operational']);

      // The analytics block reports money twice: `thisMonth` in piastres and
      // `thisMonthEgp` as a decimal string. Prefer the EGP string so no
      // conversion can go wrong, and fall back to the piastre integer.
      final earningsEgp = asNum(revenue['thisMonthEgp'])?.toDouble() ??
          asNum(revenue['thisSeasonEgp'])?.toDouble() ??
          ((asNum(revenue['thisMonth']) ?? asNum(revenue['thisSeason']))
                      ?.toDouble() ??
                  0) /
              100;

      final best = asListOfMaps(dashboard['bestPerformingProperties'])
          .map(PropertyApiMapper.fromJson)
          .toList();

      return OwnerDashboard(
        // The dashboard has no owner name; the greeting is filled in from the
        // profile provider, which already holds the signed-in user.
        ownerName: '',
        propertiesCount: properties.length,
        activePropertiesCount:
            properties.where((p) => p.status == PropertyStatus.active).length,
        bookingsCount: asNum(operational['totalBookings'])?.toInt() ??
            asNum(operational['upcomingCheckIns'])?.toInt() ??
            0,
        monthlyEarnings: _formatEgp(earningsEgp),
        trendingProperties: best.isNotEmpty ? best : properties,
      );
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  @override
  Future<List<Property>> getMyProperties() async {
    final api = apiClient;

    try {
      final response = await api.get(ApiEndpoints.myProperties);
      return PropertyApiMapper.fromList(unwrapData(response.data));
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  @override
  Future<String> createProperty(
    NewPropertyDraft draft, {
    required bool submitForReview,
  }) async {
    final api = apiClient;

    try {
      // 1. Create the listing. base_price_per_night is a decimal EGP string.
      final created = await api.post(
        ApiEndpoints.propertyCreate,
        data: {
          'title': draft.title,
          'base_price_per_night': draft.pricePerNightEgp.toStringAsFixed(2),
          if (draft.description != null && draft.description!.isNotEmpty)
            'description': draft.description,
          if (draft.propertyType != null && draft.propertyType!.isNotEmpty)
            'property_type': draft.propertyType!.toLowerCase(),
          if (draft.bedrooms != null) 'bedrooms': draft.bedrooms,
          if (draft.bathrooms != null) 'bathrooms': draft.bathrooms,
          if (draft.maxGuests != null) 'max_guests': draft.maxGuests,
          if (draft.areaSqm != null) 'area_sqm': draft.areaSqm,
          if (draft.beachDistanceMeters != null)
            'beach_distance_meters': draft.beachDistanceMeters,
          if (draft.addressLine1 != null && draft.addressLine1!.isNotEmpty)
            'address_line1': draft.addressLine1,
          if (draft.city != null && draft.city!.isNotEmpty) 'city': draft.city,
          if (draft.governorate != null && draft.governorate!.isNotEmpty)
            'governorate': draft.governorate,
          if (draft.unitNumber != null && draft.unitNumber!.isNotEmpty)
            'unit_number': draft.unitNumber,
          if (draft.floorNumber != null && draft.floorNumber!.isNotEmpty)
            'floor_number': draft.floorNumber,
        },
      );

      final propertyId = '${asMap(unwrapData(created.data))['id'] ?? ''}';
      if (propertyId.isEmpty) {
        throw const FormatException('The server did not return a property id.');
      }

      // 2. Upload the photos straight to S3 and confirm each object key.
      for (final path in draft.imagePaths) {
        await _uploads.uploadFile(
          filePath: path,
          uploadType: UploadTypes.propertyImage,
          propertyId: propertyId,
        );
      }

      // 3. Submit for review. A draft stays unsubmitted until the owner
      //    finishes it, which is exactly what "Save as draft" means.
      if (submitForReview) {
        await api.post(ApiEndpoints.propertySubmit(propertyId));
      }

      return propertyId;
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  @override
  Future<void> deleteProperty(String propertyId) async {
    final api = apiClient;

    try {
      await api.delete(ApiEndpoints.property(propertyId));
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  /// `GET /bookings/owner/bookings` returns each booking with its renter
  /// (`renter.firstName/lastName`) but only a `propertyId`, so the rows are
  /// joined with the owner's own listings for the title and photo. Requests
  /// still awaiting approval belong to the Requests screen, and cancelled,
  /// rejected or expired bookings are not guests, so both are left out.
  @override
  Future<List<OwnerGuestBooking>> getGuestBookings() async {
    try {
      final properties = {for (final p in await getMyProperties()) p.id: p};
      final response = await apiClient.get(ApiEndpoints.ownerBookings);
      return asListOfMaps(unwrapData(response.data))
          .where((row) => !_notAGuest('${row['status'] ?? ''}'))
          .map((row) => _toGuestBooking(row, properties))
          .whereType<OwnerGuestBooking>()
          .toList();
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  /// `GET /bookings/owner/requests` lists every request on the owner's
  /// listings with its renter but, like the bookings list, only a
  /// `propertyId` - so it is joined with the owner's listings too. A request
  /// the renter cancelled is not the owner's decision and is left out.
  @override
  Future<List<OwnerBookingRequest>> getBookingRequests() async {
    try {
      final properties = {for (final p in await getMyProperties()) p.id: p};
      final response = await apiClient.get(ApiEndpoints.ownerRequests);
      return asListOfMaps(unwrapData(response.data))
          .map((row) => _toRequest(row, properties))
          .whereType<OwnerBookingRequest>()
          .toList();
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  @override
  Future<void> approveRequest(String bookingId) async {
    try {
      await apiClient.post(ApiEndpoints.bookingApprove(bookingId));
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  @override
  Future<void> declineRequest(String bookingId) async {
    try {
      await apiClient.post(ApiEndpoints.bookingReject(bookingId));
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  static RequestState? _requestState(String status) {
    final s = status.toUpperCase();
    if (s.contains('CANCEL')) return null;
    if (s.contains('PENDING') || s.contains('AWAITING') || s == 'REQUESTED') {
      return RequestState.pending;
    }
    if (s.contains('REJECT') || s.contains('DECLINE') || s.contains('EXPIRE')) {
      return RequestState.declined;
    }
    return RequestState.approved;
  }

  static OwnerBookingRequest? _toRequest(
      Map<String, dynamic> row, Map<String, Property> properties) {
    final status = '${row['status'] ?? ''}'.toUpperCase();
    final state = _requestState(status);
    final checkIn = asDate(pick(row, 'check_in'));
    final checkOut = asDate(pick(row, 'check_out'));
    if (state == null || checkIn == null || checkOut == null) return null;

    final renter = asMap(row['renter']);
    final name = [pick(renter, 'first_name'), pick(renter, 'last_name')]
        .where((part) => part != null && '$part'.trim().isNotEmpty)
        .join(' ');
    final payout = asNum(pick(row, 'owner_payout')) ??
        asNum(pick(row, 'total_charged')) ??
        0;
    final cancellationReason = '${pick(row, 'cancellation_reason') ?? ''}';

    return OwnerBookingRequest(
      id: '${row['id'] ?? ''}',
      reference: '${row['reference'] ?? ''}',
      guestName: name.isEmpty ? 'Guest' : name,
      property: properties['${pick(row, 'property_id') ?? ''}'],
      checkIn: checkIn,
      checkOut: checkOut,
      guests: asNum(pick(row, 'number_of_guests'))?.toInt() ?? 0,
      nights: asNum(pick(row, 'number_of_nights'))?.toInt() ??
          checkOut.difference(checkIn).inDays,
      payoutEgp: payout / 100,
      state: state,
      checkedIn: status == 'CHECKED_IN' || pick(row, 'checked_in_at') != null,
      completed: status == 'COMPLETED' ||
          status == 'CHECKED_OUT' ||
          pick(row, 'completed_at') != null,
      reason: state != RequestState.declined
          ? null
          : status.contains('EXPIRE')
              ? 'The request expired before it was answered.'
              : cancellationReason.isNotEmpty
                  ? cancellationReason
                  : 'Declined.',
    );
  }

  static bool _notAGuest(String status) {
    final s = status.toUpperCase();
    return s.contains('PENDING') ||
        s.contains('CANCEL') ||
        s.contains('REJECT') ||
        s.contains('EXPIRE');
  }

  static OwnerGuestBooking? _toGuestBooking(
      Map<String, dynamic> row, Map<String, Property> properties) {
    final checkIn = asDate(pick(row, 'check_in'));
    final checkOut = asDate(pick(row, 'check_out'));
    if (checkIn == null || checkOut == null) return null;

    final renter = asMap(row['renter']);
    final name = [pick(renter, 'first_name'), pick(renter, 'last_name')]
        .where((part) => part != null && '$part'.trim().isNotEmpty)
        .join(' ');
    final status = '${row['status'] ?? ''}'.toUpperCase();
    // Money is in piastres; the owner's share first, the total as fallback.
    final payout = asNum(pick(row, 'owner_payout')) ??
        asNum(pick(row, 'total_charged')) ??
        0;

    return OwnerGuestBooking(
      id: '${row['id'] ?? ''}',
      reference: '${row['reference'] ?? ''}',
      guestName: name.isEmpty ? 'Guest' : name,
      property: properties['${pick(row, 'property_id') ?? ''}'],
      checkIn: checkIn,
      checkOut: checkOut,
      guests: asNum(pick(row, 'number_of_guests'))?.toInt() ?? 0,
      nights: asNum(pick(row, 'number_of_nights'))?.toInt() ??
          checkOut.difference(checkIn).inDays,
      payoutEgp: payout / 100,
      checkedIn: status == 'CHECKED_IN' || pick(row, 'checked_in_at') != null,
      completed: status == 'COMPLETED' ||
          status == 'CHECKED_OUT' ||
          pick(row, 'completed_at') != null,
    );
  }

  Future<Map<String, dynamic>> _getMap(ApiClient api, String path) async {
    final response = await api.get(path);
    return asMap(unwrapData(response.data));
  }

  /// `118490.0` -> `"118.5k"`, matching the dashboard compact style.
  static String _formatEgp(double egp) {
    if (egp >= 1000) return '${(egp / 1000).toStringAsFixed(1)}k';
    return egp.round().toString();
  }
}
