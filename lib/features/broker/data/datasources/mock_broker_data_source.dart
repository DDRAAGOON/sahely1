import 'package:flutter/material.dart';
import 'package:sahely/features/broker/domain/entities/broker_dashboard.dart';

class MockBrokerDataSource {
  Future<BrokerDashboard> fetchBrokerDashboard() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    return const BrokerDashboard(
      name: 'Karim Adel',
      role: 'Broker',
      level: 'Wave Rider',
      levelIcon: Icons.waves,
      currentStars: 47,
      starsToNextLevel: 33,
      nextLevelName: 'Coastal Regular',
      thisMonthEarnings: '18.2k',
      liveProps: 51,
      needHelp: 2,
      upcomingCheckins: [
        {
          'id': '1',
          'name': 'Palm Chalet',
          'client': 'Nour A.',
          'date': 'Jun 19',
          'profit': '+EGP 320 profit',
          'imageUrl': 'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=200',
          'status': 'Soon',
        },
        {
          'id': '2',
          'name': 'Dune House',
          'client': 'Sara M.',
          'date': 'Jun 22',
          'profit': '+EGP 260 profit',
          'imageUrl': 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=200',
          'status': 'Soon',
        },
      ],
      trendingProperties: [
        {
          'id': '1',
          'name': 'Azure Beach Villa',
          'location': 'North Coast',
          'rating': 4.8,
          'reviews': 124,
          'beds': 3,
          'type': 'Villa',
          'pricePerNight': 450000,
          'imageUrl': 'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=800',
          'isWishlisted': true,
        },
        {
          'id': '2',
          'name': 'Lagoon Retreat',
          'location': 'Marassi',
          'rating': 4.9,
          'reviews': 86,
          'beds': 4,
          'type': 'Chalet',
          'pricePerNight': 620000,
          'imageUrl': 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=800',
          'isWishlisted': false,
        },
        {
          'id': '3',
          'name': 'Skyline Penthouse',
          'location': 'Hacienda Red',
          'rating': 4.7,
          'reviews': 42,
          'beds': 2,
          'type': 'Penthouse',
          'pricePerNight': 380000,
          'imageUrl': 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=800',
          'isWishlisted': false,
        },
      ],
    );
  }
}
