import 'package:sahely/core/network/api_envelope.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';

/// Maps a backend property row onto the shared [Property] entity used by the
/// owner, broker and renter screens.
///
/// Kept in one place because three repositories need the identical mapping and
/// the backend has two quirks that are easy to get wrong:
///  * it serialises entities camelCase while documenting snake_case, so every
///    lookup goes through [pick];
///  * it reports the nightly price twice - `basePricePerNight` in **piastres**
///    (375000) and `nightlyRate` as an EGP string ("3750.00"). Reading the
///    piastre field as EGP shows prices 100x too high.
class PropertyApiMapper {
  PropertyApiMapper._();

  static Property fromJson(Map<String, dynamic> json) {
    final images = asListOfMaps(json['images']);
    return Property(
      id: '${json['id'] ?? ''}',
      name: '${json['title'] ?? ''}',
      area: '${json['governorate'] ?? json['city'] ?? ''}',
      image: images.isEmpty ? '' : '${images.first['url'] ?? ''}',
      price: priceEgp(json).round(),
      rating: asNum(pick(json, 'average_rating'))?.toDouble() ?? 0,
      reviews: asNum(pick(json, 'total_reviews'))?.toInt() ?? 0,
      type: _titleCase('${pick(json, 'property_type') ?? 'Villa'}'),
      beds: asNum(json['bedrooms'])?.toInt() ?? 0,
      guests: asNum(pick(json, 'max_guests'))?.toInt() ?? 0,
      minutesToBeach: _walkingMinutes(pick(json, 'beach_distance_meters')),
      status: status('${json['status'] ?? ''}'),
    );
  }

  static List<Property> fromList(dynamic payload) =>
      asListOfMaps(payload).map(fromJson).toList();

  /// Nightly price in EGP.
  static double priceEgp(Map<String, dynamic> json) {
    final egp = asNum(pick(json, 'nightly_rate'))?.toDouble();
    if (egp != null) return egp;
    return (asNum(pick(json, 'base_price_per_night'))?.toDouble() ?? 0) / 100;
  }

  /// Backend listing status -> the four states the UI renders.
  static PropertyStatus status(String raw) {
    return switch (raw.toLowerCase()) {
      'active' || 'published' || 'listed' => PropertyStatus.active,
      'pending' ||
      'pending_review' ||
      'under_review' ||
      'submitted' =>
        PropertyStatus.underReview,
      'draft' || 'incomplete' => PropertyStatus.draft,
      _ => PropertyStatus.paused,
    };
  }

  /// Beach distance in metres -> an approximate walk in minutes at 80 m/min.
  /// Returns null when the backend has no distance, so the UI keeps hiding the
  /// chip rather than showing a fabricated "0 min".
  static int? _walkingMinutes(dynamic metres) {
    final value = asNum(metres)?.toDouble();
    if (value == null || value <= 0) return null;
    final minutes = (value / 80).round();
    return minutes < 1 ? 1 : minutes;
  }

  static String _titleCase(String value) => value.isEmpty
      ? value
      : value[0].toUpperCase() + value.substring(1).toLowerCase();
}
