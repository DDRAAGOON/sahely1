import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';

class DescriptionSection extends StatefulWidget {
  const DescriptionSection({super.key});

  @override
  State<DescriptionSection> createState() => _DescriptionSectionState();
}

class _DescriptionSectionState extends State<DescriptionSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'A stunning beachfront villa with private pool, panoramic sea views, and direct beach access. Perfect for families or groups looking for a luxurious getaway. The property features modern amenities and a dedicated concierge service.',
              maxLines: _isExpanded ? null : 3,
              overflow:
                  _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.dark,
                fontFamily: 'DM Sans',
                height: 1.55,
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  _isExpanded ? 'Show Less' : 'Show More',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.gold,
                    fontFamily: 'DM Sans',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
