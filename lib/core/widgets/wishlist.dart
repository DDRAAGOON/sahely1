import 'package:flutter/material.dart';
import '../../data/models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/renter/presentation/screens/wishlist/presentation/bloc/wishlist_cubit.dart';
import '../theme/app_colors.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';


class SaveHeart extends StatelessWidget {
  const SaveHeart({super.key, required this.property, this.size = 32, this.padding = 0});
  final Property property;
  final double size;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WishlistCubit, WishlistState>(
      builder: (context, state) {
        // Find if property is in any collection
        final isSaved = state.toggledPropertyId == property.name 
            ? (state.isToggledStatus ?? false) 
            : state.items.any((item) => item.propertyId == property.name);

        return GestureDetector(
          onTap: () {
            context.read<WishlistCubit>().toggleWishlist(
              propertyId: property.name,
              propertyName: property.name,
              propertyImage: property.image,
            );
          },
          child: Container(
            width: size,
            height: size,
            alignment: Alignment.center,
            padding: EdgeInsets.all(padding),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.92), shape: BoxShape.circle),
            child: Icon(isSaved ? Icons.favorite : Icons.favorite_border,
                size: size * 0.6,
                color: isSaved ? AppColors.gold : AppColors.navy),
          ),
        );
      },
    );
  }
}
