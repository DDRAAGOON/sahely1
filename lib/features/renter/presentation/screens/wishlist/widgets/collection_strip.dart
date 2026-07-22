import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';

class CollectionStrip extends StatelessWidget {
  final String collectionName;
  final List<String> propertyThumbnails;

  const CollectionStrip({
    super.key,
    required this.collectionName,
    required this.propertyThumbnails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(
          top: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: Row(
        children: [
          const Text(
            'Add from collection:',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.secondary,
              fontFamily: 'DM Sans',
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: propertyThumbnails.length,
                separatorBuilder: (context, index) => const SizedBox(width: 6),
                itemBuilder: (context, index) {
                  return Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.border, width: 1),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        propertyThumbnails[index],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppColors.border,
                            child: const Icon(
                              Icons.add,
                              color: AppColors.secondary,
                              size: 16,
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
