import 'package:sahely/features/owner/domain/entities/owner_dashboard.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';

class MockOwnerDataSource {
  Future<OwnerDashboard> fetchOwnerDashboard() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    return const OwnerDashboard(
      ownerName: 'Layla Mansour',
      propertiesCount: 3,
      bookingsCount: 7,
      monthlyEarnings: '68k',
      trendingProperties: [
        Property(
          id: '1',
          name: 'Azure Beach Villa',
          area: 'North Coast',
          image: 'https://images.unsplash.com/photo-1776762893024-890728937eab?w=1200&q=72&auto=format&fit=crop',
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
        ),
        Property(
          id: '2',
          name: 'Lagoon Retreat',
          area: 'Marassi',
          image: 'https://images.unsplash.com/photo-1707075108813-edefd7b3308d?w=1200&q=72&auto=format&fit=crop',
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
        ),
        Property(
          id: '3',
          name: 'Golden Dunes',
          area: 'Hacienda Bay',
          image: 'https://images.unsplash.com/photo-1776619316276-b1b461af9f15?w=1200&q=72&auto=format&fit=crop',
          price: 3800,
          rating: 4.7,
          reviews: 53,
          beds: 2,
          guests: 4,
          type: 'Chalet',
          tags: ['Beach', 'Pool', 'BBQ', 'Garden'],
          petsOk: false,
          minutesToBeach: 7,
        ),
      ],
    );
  }
}
