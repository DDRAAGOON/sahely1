import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/data/models.dart';
import 'package:sahely/data/role_state.dart';
import 'package:sahely/features/renter/presentation/screens/wishlist/presentation/bloc/wishlist_cubit.dart';
import 'package:sahely/features/renter/domain/constants/wishlist_constants.dart';
import 'package:sahely/features/renter/presentation/screens/wishlist/presentation/widgets/add_to_collection_sheet.dart';

class HeartButton extends StatefulWidget {
  final String propertyId;
  final String propertyName;
  final String propertyImage;
  final double size;

  const HeartButton({
    super.key,
    required this.propertyId,
    required this.propertyName,
    required this.propertyImage,
    this.size = 32,
  });

  @override
  State<HeartButton> createState() => _HeartButtonState();
}

class _HeartButtonState extends State<HeartButton> {
  Role get _currentRole => RoleState().currentRole;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final cubit = context.read<WishlistCubit>();
        cubit.checkStatus(widget.propertyId, _currentRole);
        cubit.loadCollections(_currentRole);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WishlistCubit, WishlistState>(
      builder: (context, state) {
        final isWishlisted =
            state.items.any((item) => item.propertyId == widget.propertyId);

        return GestureDetector(
          onTap: () async {
            HapticFeedback.lightImpact();

            if (!isWishlisted) {
              final hasCustomCollections = state.collections.any(
                  (c) => c.id != WishlistConstants.allSavedCollectionId);

              if (!hasCustomCollections) {
                // No custom collections → save to default directly
                context.read<WishlistCubit>().toggleWishlist(
                      propertyId: widget.propertyId,
                      propertyName: widget.propertyName,
                      propertyImage: widget.propertyImage,
                      role: _currentRole,
                    );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Saved to All Saved'),
                    duration: Duration(seconds: 2),
                    backgroundColor: AppColors.navy,
                  ),
                );
              } else {
                // Has custom collections → ask where to save
                _showAddToCollectionSheet(context);
              }
            } else {
              context.read<WishlistCubit>().toggleWishlist(
                    propertyId: widget.propertyId,
                    propertyName: widget.propertyName,
                    propertyImage: widget.propertyImage,
                    role: _currentRole,
                  );
            }
          },
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Container(
              key: ValueKey(isWishlisted),
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                isWishlisted ? Icons.favorite : Icons.favorite_border,
                color: isWishlisted ? AppColors.gold : AppColors.navy,
                size: widget.size * 0.56,
              ),
            ),
          ),
        );
      },
    );
  }

  void _showAddToCollectionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => AddToCollectionSheet(
        propertyId: widget.propertyId,
        propertyName: widget.propertyName,
        propertyImage: widget.propertyImage,
        role: _currentRole,
      ),
    );
  }
}
