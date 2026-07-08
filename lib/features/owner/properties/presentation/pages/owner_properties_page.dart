import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../shared/properties/widgets/property_card.dart';
import '../../../../shared/properties/domain/entities/property.dart';

class OwnerPropertiesPage extends StatelessWidget {
  const OwnerPropertiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: Text('My Properties', style: AppTheme.dm(size: 20, weight: FontWeight.w700)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
        itemCount: 3,
        itemBuilder: (context, index) {
          return PropertyCard(
            property: Property(
              id: index.toString(),
              name: 'Azure Beach Villa $index',
              area: 'Hacienda Bay',
              imageUrl: 'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=800',
              pricePerNight: 4500,
              rating: 4.8,
              reviewCount: 124,
            ),
            onTap: () {},
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.navy,
        child: const Icon(Icons.add, color: AppColors.gold),
      ),
    );
  }
}
