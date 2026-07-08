import 'package:flutter/material.dart';
import '../data/models.dart';
import '../data/wishlist_state.dart';
import '../theme/app_colors.dart';

class SaveHeart extends StatefulWidget {
  const SaveHeart({super.key, required this.property, this.size = 32, this.padding = 0});
  final Property property;
  final double size;
  final double padding;

  @override
  State<SaveHeart> createState() => _SaveHeartState();
}

class _SaveHeartState extends State<SaveHeart> {
  @override
  Widget build(BuildContext context) {
    final wishlist = WishlistState();
    final saved = wishlist.isSaved(widget.property);

    return GestureDetector(
      onTap: () {
        setState(() {
          wishlist.toggleSave(widget.property);
        });
      },
      child: Container(
        width: widget.size,
        height: widget.size,
        alignment: Alignment.center,
        padding: EdgeInsets.all(widget.padding),
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.92), shape: BoxShape.circle),
        child: Icon(saved ? Icons.favorite : Icons.favorite_border,
            size: widget.size * 0.6,
            color: saved ? AppColors.gold : AppColors.navy),
      ),
    );
  }
}
