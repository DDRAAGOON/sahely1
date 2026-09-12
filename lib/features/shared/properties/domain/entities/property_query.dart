/// What the search screen asks the backend for.
///
/// Only the criteria `GET /search/properties` really accepts are modelled —
/// the server rejects an unknown parameter outright, and filtering on the
/// device cannot work for fields the listing JSON does not carry.
class PropertyQuery {
  const PropertyQuery({
    this.keyword = '',
    this.type,
    this.minBedrooms,
    this.guests,
    this.minPriceEgp,
    this.maxPriceEgp,
    this.amenities = const [],
    this.checkIn,
    this.checkOut,
    this.smartLock = false,
    this.nearBeach = false,
    this.governorate,
    this.minRating,
  });

  /// Free text, matched against the listing title.
  final String keyword;

  /// One of the backend's types: apartment, villa, studio, chalet,
  /// townhouse, penthouse.
  final String? type;

  /// The backend reads bedrooms and guests as "at least this many".
  final int? minBedrooms;
  final int? guests;

  final int? minPriceEgp;
  final int? maxPriceEgp;

  final List<String> amenities;

  final DateTime? checkIn;
  final DateTime? checkOut;

  /// Listings with a smart lock fitted.
  final bool smartLock;

  /// Listings within a kilometre of the beach.
  final bool nearBeach;

  final String? governorate;
  final double? minRating;

  bool get isEmpty =>
      keyword.isEmpty &&
      type == null &&
      minBedrooms == null &&
      guests == null &&
      minPriceEgp == null &&
      maxPriceEgp == null &&
      amenities.isEmpty &&
      checkIn == null &&
      checkOut == null &&
      !smartLock &&
      !nearBeach &&
      governorate == null &&
      minRating == null;

  PropertyQuery copyWith({String? keyword}) => PropertyQuery(
        keyword: keyword ?? this.keyword,
        type: type,
        minBedrooms: minBedrooms,
        guests: guests,
        minPriceEgp: minPriceEgp,
        maxPriceEgp: maxPriceEgp,
        amenities: amenities,
        checkIn: checkIn,
        checkOut: checkOut,
        smartLock: smartLock,
        nearBeach: nearBeach,
        governorate: governorate,
        minRating: minRating,
      );

  /// The map the filters sheet hands back, as a query the backend understands.
  ///
  /// Three of the sheet's amenity chips match a real listing field and become
  /// their own criterion; the rest are sent as amenities. The house-rule
  /// toggles (pets, parties, mixed groups) have no counterpart in the
  /// listing data, so they cannot narrow the search.
  factory PropertyQuery.fromFilters(
    Map<String, dynamic>? filters, {
    String keyword = '',
  }) {
    if (filters == null) return PropertyQuery(keyword: keyword);

    final type = '${filters['propertyType'] ?? filters['type'] ?? 'All'}';
    final bedrooms = '${filters['bedrooms'] ?? filters['beds'] ?? 'Any'}';
    final guests = ((filters['adults'] as int?) ?? 0) +
        ((filters['children'] as int?) ?? 0);
    final minPrice = (filters['minPrice'] as num?)?.round() ?? 0;
    final maxPrice = (filters['maxPrice'] as num?)?.round() ?? 0;

    final chips = <String>[
      ...(filters['amenities'] as List?)?.map((a) => '$a') ?? const [],
    ];
    const mapped = {'Smart Lock', 'Beach'};

    return PropertyQuery(
      keyword: keyword,
      type: type == 'All' ? null : type.toLowerCase(),
      minBedrooms:
          bedrooms == 'Any' ? null : int.tryParse(bedrooms.replaceAll('+', '')),
      guests: guests > 0 ? guests : null,
      minPriceEgp: minPrice > 0 ? minPrice : null,
      maxPriceEgp: maxPrice > 0 && maxPrice < _openEndedPrice ? maxPrice : null,
      amenities: [
        for (final chip in chips)
          if (!mapped.contains(chip)) chip.toLowerCase().replaceAll(' ', '_'),
      ],
      checkIn: filters['checkIn'] as DateTime?,
      checkOut: filters['checkOut'] as DateTime?,
      smartLock: chips.contains('Smart Lock'),
      nearBeach: chips.contains('Beach'),
    );
  }

  /// One of the home screen's category chips as a search.
  ///
  /// The types are listing types the backend knows; "Beachfront" is a
  /// distance to the sea and "Pool" an amenity, so each becomes the
  /// criterion that actually describes it.
  factory PropertyQuery.category(String category) => switch (category) {
        'All' => const PropertyQuery(),
        'Beachfront' => const PropertyQuery(nearBeach: true),
        'Pool' => const PropertyQuery(amenities: ['pool']),
        _ => PropertyQuery(type: category.toLowerCase()),
      };

  /// The top of the price slider: anything at or above it means "no maximum".
  static const _openEndedPrice = 100000;
}
