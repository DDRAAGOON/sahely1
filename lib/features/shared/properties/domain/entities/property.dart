class Property {
  const Property({
    this.id = '1',
    required this.name,
    required this.area,
    required this.image,
    required this.price,
    required this.rating,
    required this.reviews,
    this.type = 'Villa',
    this.beds = 3,
    this.guests = 6,
    this.tags = const [],
    this.petsOk = true,
    this.minutesToBeach,
    this.guestFavourite = false,
    this.saved = false,
  });

  final String id;
  final String name;
  final String area; // compound / location
  final String image;
  final int price; // EGP per night
  final double rating;
  final int reviews;
  final String type;
  final int beds;
  final int guests;
  final List<String> tags;
  final bool petsOk;
  final int? minutesToBeach;
  final bool guestFavourite;
  final bool saved;
}
