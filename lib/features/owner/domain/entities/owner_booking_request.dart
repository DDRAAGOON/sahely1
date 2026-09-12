import 'package:sahely/features/shared/properties/domain/entities/property.dart';

/// Where a booking request stands from the owner's point of view.
enum RequestState { pending, approved, declined }

/// A booking request on one of the owner's listings
/// (`GET /bookings/owner/requests`, joined with `GET /properties/mine`).
class OwnerBookingRequest {
  const OwnerBookingRequest({
    required this.id,
    required this.reference,
    required this.guestName,
    required this.property,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
    required this.nights,
    required this.payoutEgp,
    required this.state,
    required this.checkedIn,
    required this.completed,
    this.reason,
  });

  final String id;
  final String reference;
  final String guestName;

  /// The listing, from the owner's own properties; null when it was removed.
  final Property? property;
  final DateTime checkIn;
  final DateTime checkOut;
  final int guests;
  final int nights;

  /// What the owner receives for the stay, in EGP.
  final double payoutEgp;
  final RequestState state;
  final bool checkedIn;
  final bool completed;

  /// Why a declined request did not go ahead.
  final String? reason;

  /// Whether an approved stay has already ended.
  bool get isPast => completed || DateTime.now().isAfter(checkOut);
}
