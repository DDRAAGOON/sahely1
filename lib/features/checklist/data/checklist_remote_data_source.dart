import 'package:dartz/dartz.dart';

import 'package:sahely/core/errors/exception_mapper.dart';
import 'package:sahely/core/errors/failures.dart';
import 'package:sahely/core/network/api_client.dart';
import 'package:sahely/core/network/api_endpoints.dart';
import 'package:sahely/core/network/api_envelope.dart';

/// Which side of the stay a checklist belongs to.
enum ChecklistStage { arrival, departure }

/// Who is filling the checklist in.
enum ChecklistRole { renter, owner }

/// A single checklist line as the backend expects it (`ChecklistItemDto`).
class ChecklistItem {
  final String key;
  final bool checked;
  final String? notes;
  final List<String> photoUrls;

  const ChecklistItem({
    required this.key,
    required this.checked,
    this.notes,
    this.photoUrls = const [],
  });

  Map<String, dynamic> toJson() => {
        'key': key,
        'checked': checked,
        if (notes != null && notes!.isNotEmpty) 'notes': notes,
        if (photoUrls.isNotEmpty) 'photo_urls': photoUrls,
      };
}

/// Remote data source for the `checklists` module.
///
/// Every arrival/departure route is nested under its booking:
/// `/bookings/:bookingId/checklist/{arrival|departure}/{renter|owner}`.
/// (The written API guide shows top-level `/arrival/renter` style routes -
/// those 404 on the live server.)
class ChecklistRemoteDataSource {
  final ApiClient _apiClient;

  ChecklistRemoteDataSource(this._apiClient);

  /// `POST /arrival/{renter|owner}` and `POST /departure/{renter|owner}`.
  Future<Either<Failure, void>> submit({
    required String bookingId,
    required ChecklistStage stage,
    required ChecklistRole role,
    required List<ChecklistItem> items,
  }) async {
    try {
      await _apiClient.post(
        _path(stage, role, bookingId),
        data: {'items': items.map((item) => item.toJson()).toList()},
      );
      return const Right(null);
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  /// The renter's arrival checklist for a booking.
  Future<Either<Failure, Map<String, dynamic>>> getRenterArrival(
    String bookingId,
  ) =>
      _get(ApiEndpoints.arrivalRenter(bookingId));

  /// The owner's departure checklist for a booking.
  Future<Either<Failure, Map<String, dynamic>>> getOwnerDeparture(
    String bookingId,
  ) =>
      _get(ApiEndpoints.departureOwner(bookingId));

  /// `POST /properties/:id/checklist/pre-listing` - owner readiness check.
  Future<Either<Failure, void>> submitPreListing({
    required String propertyId,
    required List<ChecklistItem> items,
  }) async {
    try {
      await _apiClient.post(
        ApiEndpoints.preListingChecklist(propertyId),
        data: {'items': items.map((item) => item.toJson()).toList()},
      );
      return const Right(null);
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  Future<Either<Failure, Map<String, dynamic>>> getPreListing(
    String propertyId,
  ) async {
    try {
      final response =
          await _apiClient.get(ApiEndpoints.preListingChecklist(propertyId));
      return Right(asMap(unwrapData(response.data)));
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  Future<Either<Failure, Map<String, dynamic>>> _get(String path) async {
    try {
      final response = await _apiClient.get(path);
      return Right(asMap(unwrapData(response.data)));
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  static String _path(
    ChecklistStage stage,
    ChecklistRole role,
    String bookingId,
  ) {
    return switch ((stage, role)) {
      (ChecklistStage.arrival, ChecklistRole.renter) =>
        ApiEndpoints.arrivalRenter(bookingId),
      (ChecklistStage.arrival, ChecklistRole.owner) =>
        ApiEndpoints.arrivalOwner(bookingId),
      (ChecklistStage.departure, ChecklistRole.renter) =>
        ApiEndpoints.departureRenter(bookingId),
      (ChecklistStage.departure, ChecklistRole.owner) =>
        ApiEndpoints.departureOwner(bookingId),
    };
  }
}
