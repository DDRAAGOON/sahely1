import 'package:sahely/features/shared/properties/domain/entities/property.dart';

/// Where a guest's stay stands relative to today.
enum GuestStayPhase { upcoming, active, past }

/// A confirmed guest booking on one of the owner's listings
/// (`GET /bookings/owner/bookings`, joined with `GET /properties/mine`).
class OwnerGuestBooking {
  const OwnerGuestBooking({
    required this.id,
    required this.reference,
    required this.guestName,
    required this.property,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
    required this.nights,
    required this.payoutEgp,
    required this.checkedIn,
    required this.completed,
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
  final bool checkedIn;
  final bool completed;

  /// Same rule as the renter's bookings: upcoming before the check-in day,
  /// past once check-out has passed, active in between.
  GuestStayPhase get phase {
    if (completed) return GuestStayPhase.past;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final checkInDay = DateTime(checkIn.year, checkIn.month, checkIn.day);
    if (today.isBefore(checkInDay)) return GuestStayPhase.upcoming;
    if (now.isAfter(checkOut)) return GuestStayPhase.past;
    return GuestStayPhase.active;
  }
}
