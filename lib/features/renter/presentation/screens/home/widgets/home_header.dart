import 'package:flutter/material.dart';

import '../../../../../../core/theme/app_colors.dart';

class HomeHeader extends StatelessWidget {
  final VoidCallback onFilterTap;
  final VoidCallback onChatTap;
  final TextEditingController? searchController;
  final ValueChanged<String>? onSearchChanged;

  const HomeHeader({
    super.key,
    required this.onFilterTap,
    required this.onChatTap,
    this.searchController,
    this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        children: [
          // Back Button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(
                Icons.chevron_left,
                color: AppColors.navy,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Search Bar
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: TextField(
                controller: searchController,
                onChanged: onSearchChanged,
                style: const TextStyle(fontSize: 13, fontFamily: 'DM Sans'),
                decoration: const InputDecoration(
                  hintText: 'Search properties',
                  hintStyle:
                      TextStyle(color: AppColors.secondary, fontSize: 13),
                  prefixIcon:
                      Icon(Icons.search, size: 18, color: AppColors.secondary),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Filter Button
          GestureDetector(
            onTap: onFilterTap,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.navy,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.filter_list,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Chat Button
          GestureDetector(
            onTap: onChatTap,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.gold,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.chat_bubble_outline,
                color: AppColors.navy,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
