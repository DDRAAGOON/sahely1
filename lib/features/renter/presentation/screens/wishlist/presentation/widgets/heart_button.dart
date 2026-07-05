import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../bloc/wishlist_cubit.dart';
import 'add_to_collection_sheet.dart';

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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<WishlistCubit>().checkStatus(widget.propertyId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WishlistCubit, WishlistState>(
      buildWhen: (previous, current) {
        if (current is WishlistStatusLoaded) return current.propertyId == widget.propertyId;
        if (current is WishlistToggled) return current.propertyId == widget.propertyId;
        return false;
      },
      builder: (context, state) {
        bool isWishlisted = false;

        if (state is WishlistStatusLoaded && state.propertyId == widget.propertyId) {
          isWishlisted = state.isWishlisted;
        } else if (state is WishlistToggled && state.propertyId == widget.propertyId) {
          isWishlisted = state.isWishlisted;
        }

        return GestureDetector(
          onTap: () async {
            HapticFeedback.lightImpact();

            // Toggle logic directly without dialog
            context.read<WishlistCubit>().toggleWishlist(
              propertyId: widget.propertyId,
              propertyName: widget.propertyName,
              propertyImage: widget.propertyImage,
            );
            
            // Show sheet only when it was NOT wishlisted (adding scenario)
            if (!isWishlisted) {
              await Future.delayed(const Duration(milliseconds: 200));
              if (context.mounted) {
                _showAddToCollectionSheet(context);
              }
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
                    color: Colors.black.withOpacity(0.1),
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
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => AddToCollectionSheet(
        propertyId: widget.propertyId,
      ),
    );
  }
}
