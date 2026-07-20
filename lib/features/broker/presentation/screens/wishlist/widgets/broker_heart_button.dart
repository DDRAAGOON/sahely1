import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/theme/app_colors.dart';
import '../bloc/broker_wishlist_cubit.dart';
import 'broker_add_to_collection_sheet.dart';

class BrokerHeartButton extends StatefulWidget {
  final String propertyId;
  final String propertyName;
  final String propertyImage;
  final double size;

  const BrokerHeartButton({
    super.key,
    required this.propertyId,
    required this.propertyName,
    required this.propertyImage,
    this.size = 32,
  });

  @override
  State<BrokerHeartButton> createState() => _BrokerHeartButtonState();
}

class _BrokerHeartButtonState extends State<BrokerHeartButton> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<BrokerWishlistCubit>().checkStatus(widget.propertyId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BrokerWishlistCubit, BrokerWishlistState>(
      buildWhen: (previous, current) {
        if (current is BrokerWishlistStatusLoaded)
          return current.propertyId == widget.propertyId;
        if (current is BrokerWishlistToggled)
          return current.propertyId == widget.propertyId;
        return false;
      },
      builder: (context, state) {
        bool isWishlisted = false;

        if (state is BrokerWishlistStatusLoaded &&
            state.propertyId == widget.propertyId) {
          isWishlisted = state.isWishlisted;
        } else if (state is BrokerWishlistToggled &&
            state.propertyId == widget.propertyId) {
          isWishlisted = state.isWishlisted;
        }

        return GestureDetector(
          onTap: () async {
            HapticFeedback.lightImpact();

            // Toggle logic
            context.read<BrokerWishlistCubit>().toggleWishlist(
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
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => BrokerAddToCollectionSheet(
        propertyId: widget.propertyId,
      ),
    );
  }
}
