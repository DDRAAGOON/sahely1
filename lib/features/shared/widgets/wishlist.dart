import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../data/models.dart';
import '../../../../data/wishlist_state.dart';
import '../../../../core/theme/app_colors.dart';

class SaveHeart extends StatelessWidget {
  const SaveHeart({super.key, required this.property, this.size = 32, this.padding = 0});
  final Property property;
  final double size;
  final double padding;

  @override
  Widget build(BuildContext context) {
    // Using WishlistState (ChangeNotifier) since WishlistCubit is missing
    return Consumer<WishlistState>(
      builder: (context, state, child) {
        final isSaved = state.isSaved(property);

        return GestureDetector(
          onTap: () {
            state.toggleSave(property);
          },
          child: Container(
            width: size,
            height: size,
            alignment: Alignment.center,
            padding: EdgeInsets.all(padding),
            decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.92),
          shape: BoxShape.circle,
            ),
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
