import 'package:sahely/features/owner/domain/entities/owner_dashboard.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';
import 'package:sahely/features/owner/domain/entities/owner_guest_booking.dart';
import 'package:sahely/features/owner/domain/entities/owner_booking_request.dart';

/// A new listing as captured by the Add Property wizard.
class NewPropertyDraft {
  final String title;
  final String? description;

  /// Nightly rate in EGP, as typed by the owner.
  final int pricePerNightEgp;
  final String? propertyType;
  final int? bedrooms;
  final int? bathrooms;
  final int? maxGuests;
  final int? areaSqm;
  final int? beachDistanceMeters;
  final String? addressLine1;
  final String? city;
  final String? governorate;
  final String? unitNumber;
  final String? floorNumber;

  /// Local file paths of the photos the owner picked.
  final List<String> imagePaths;

  const NewPropertyDraft({
    required this.title,
    required this.pricePerNightEgp,
    this.description,
    this.propertyType,
    this.bedrooms,
    this.bathrooms,
    this.maxGuests,
    this.areaSqm,
    this.beachDistanceMeters,
    this.addressLine1,
    this.city,
    this.governorate,
    this.unitNumber,
    this.floorNumber,
    this.imagePaths = const [],
  });
}

abstract class OwnerRepository {
  Future<OwnerDashboard> getOwnerDashboard();

  /// The owner's own listings (`GET /properties/mine`), every status included.
  Future<List<Property>> getMyProperties();

  /// Creates a listing, uploads its photos, and - when [submitForReview] is
  /// true - sends it to the Sahely review queue.
  ///
  /// The backend enforces the order create -> images -> submit, and rejects the
  /// call outright with a KYC error when the owner is not yet verified.
  /// Returns the new property id.
  Future<String> createProperty(
    NewPropertyDraft draft, {
    required bool submitForReview,
  });

  /// Soft-deletes a listing (`DELETE /properties/:id`).
  Future<void> deleteProperty(String propertyId);

  /// Guests with confirmed, in-house or finished stays on the owner's
  /// listings.
  Future<List<OwnerGuestBooking>> getGuestBookings();

  /// Booking requests on the owner's listings: waiting for an answer,
  /// approved, or declined / expired.
  Future<List<OwnerBookingRequest>> getBookingRequests();

  /// Accepts a pending request (`POST /bookings/:id/approve`).
  Future<void> approveRequest(String bookingId);

  /// Declines a pending request (`POST /bookings/:id/reject`).
  Future<void> declineRequest(String bookingId);
}
