import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';

import '../../features/renter/presentation/screens/wishlist/presentation/bloc/wishlist_cubit.dart';
import '../../features/renter/presentation/screens/wishlist/presentation/widgets/add_to_collection_sheet.dart';
import '../theme/app_colors.dart';

class SaveHeart extends StatelessWidget {
  const SaveHeart(
      {super.key, required this.property, this.size = 32, this.padding = 0});

  final Property property;
  final double size;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WishlistCubit, WishlistState>(
      builder: (context, state) {
        // Rely ONLY on state.items — always up to date after toggle/load
        final isSaved =
            state.items.any((item) => item.propertyId == property.name);

        return GestureDetector(
          onTap: () {
            if (isSaved) {
              // Already saved → remove directly
              context.read<WishlistCubit>().toggleWishlist(
                    propertyId: property.name,
                    propertyName: property.name,
                    propertyImage: property.image,
                  );
            } else {
              // Not saved → always show sheet to choose collection
              showModalBottomSheet(
                context: context,
                useRootNavigator: true,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                builder: (_) => BlocProvider.value(
                  value: context.read<WishlistCubit>(),
                  child: AddToCollectionSheet(
                    propertyId: property.name,
                    propertyName: property.name,
                    propertyImage: property.image,
                  ),
                ),
              );
            }
          },
          child: Container(
            width: size,
            height: size,
            alignment: Alignment.center,
            padding: EdgeInsets.all(padding),
            decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.92),
                shape: BoxShape.circle),
            child: Icon(
              isSaved ? Icons.favorite : Icons.favorite_border,
              size: size * 0.6,
              color: isSaved ? AppColors.gold : AppColors.navy,
            ),
          ),
        );
      },
    );
  }
}
