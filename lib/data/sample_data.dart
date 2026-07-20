import 'package:flutter/material.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';

import 'models.dart';

/// Static sample content lifted from the design board. Unsplash URLs are kept
/// verbatim per the handoff decision.
class Sample {
  Sample._();

  static const azure = Property(
    name: 'Azure Beach Villa',
    area: 'North Coast',
    image:
        'https://images.unsplash.com/photo-1776762893024-890728937eab?w=1200&q=72&auto=format&fit=crop',
    price: 4500,
    rating: 4.8,
    reviews: 124,
    type: 'Villa',
    beds: 4,
    guests: 8,
    tags: ['Beachfront', 'Pool', 'WiFi', 'AC', 'Sea View'],
    petsOk: true,
    guestFavourite: true,
    saved: true,
  );

  static const lagoon = Property(
    name: 'Lagoon Retreat',
    area: 'Marassi',
    image:
        'https://images.unsplash.com/photo-1707075108813-edefd7b3308d?w=1200&q=72&auto=format&fit=crop',
    price: 6200,
    rating: 4.9,
    reviews: 86,
    beds: 3,
    guests: 6,
    type: 'Villa',
    tags: ['Beachfront', 'Pool', 'WiFi', 'Smart Lock', 'Parking'],
    petsOk: true,
    minutesToBeach: 3,
    guestFavourite: true,
  );

  static const dunes = Property(
    name: 'Golden Dunes',
    area: 'Hacienda Bay',
    image:
        'https://images.unsplash.com/photo-1776619316276-b1b461af9f15?w=1200&q=72&auto=format&fit=crop',
    price: 3800,
    rating: 4.7,
    reviews: 53,
    beds: 2,
    guests: 4,
    type: 'Chalet',
    tags: ['Beach', 'Pool', 'BBQ', 'Garden'],
    petsOk: false,
    minutesToBeach: 7,
  );

  static const telal = Property(
    name: 'Telal Chalet',
    area: 'Telal',
    image:
        'https://images.unsplash.com/photo-1729808641871-8d8b5ade6bbe?w=1200&q=72&auto=format&fit=crop',
    price: 3200,
    rating: 4.6,
    beds: 3,
    guests: 5,
    reviews: 41,
    type: 'Chalet',
    tags: ['WiFi', 'AC', 'Parking'],
    petsOk: true,
  );

  static const trending = [azure, lagoon, dunes, telal];

  // Expanded list for "See All" with 50 items to make filtering feel real
  static final List<Property> allTrending = List.generate(50, (index) {
    final base = trending[index % trending.length];
    final types = ['Villa', 'Chalet', 'Apartment'];
    final areas = [
      'Marassi',
      'Hacienda Bay',
      'Telal',
      'Seashell',
      'Hacienda Red'
    ];

    return Property(
      name: '${base.name.split(' ')[0]} ${index + 1}',
      area: areas[index % areas.length],
      image: base.image,
      price: 1500 + (index * 250),
      rating: 4.0 + (index % 10) / 10,
      reviews: 10 + index,
      type: types[index % types.length],
      beds: (index % 4) + 1,
      guests: (index % 6) + 2,
      tags: base.tags,
      // Keep base tags for now
      petsOk: index % 2 == 0,
      guestFavourite: index % 5 == 0,
      saved: index % 8 == 0,
    );
  });

  static const searchResults = [lagoon, dunes, azure, telal];

  static const services = [
    ServiceItem('Private Chef', 'From EGP 1,200',
        [Color(0xFFB9543E), Color(0xFF7D2F23)]),
    ServiceItem('Airport Transfer', 'From EGP 800',
        [Color(0xFF3A6EA5), Color(0xFF1F3F63)]),
    ServiceItem(
        'Beach Setup', 'From EGP 400', [Color(0xFF3A9B8E), Color(0xFF1F5D4A)]),
  ];

  static const destinations = [
    (
      'Marassi',
      'https://images.unsplash.com/photo-1707075108813-edefd7b3308d?w=400&q=70&auto=format&fit=crop'
    ),
    (
      'Hacienda Bay',
      'https://images.unsplash.com/photo-1776619316276-b1b461af9f15?w=400&q=70&auto=format&fit=crop'
    ),
    (
      'Telal',
      'https://images.unsplash.com/photo-1729808641871-8d8b5ade6bbe?w=400&q=70&auto=format&fit=crop'
    ),
  ];

  // AL MAWSEM renter tiers — exact thresholds from the Programs spec.
  static const tiers = <(String, int, String)>[
    ('Beach Walker', 0, '🚶'),
    ('Wave Rider', 15, '🌊'),
    ('Coastal Regular', 40, '🏖️'),
    ('Sahel Insider', 80, '🌴'),
    ('Marina Elite', 140, '⚓'),
    ('Coastal Royalty', 220, '👑'),
    ('Sahely Ambassador', 500, '⭐'),
  ];
}
