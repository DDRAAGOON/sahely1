import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/data/models.dart';
import 'package:sahely/features/renter/presentation/screens/wishlist/widgets/create_collection_sheet.dart';
import 'package:sahely/features/renter/domain/constants/wishlist_constants.dart';

import '../../../../../../../core/widgets/buttons.dart';
import '../bloc/wishlist_cubit.dart';

class AddToCollectionSheet extends StatefulWidget {
  final String propertyId;
  final String propertyName;
  final String propertyImage;
  final Role role;

  const AddToCollectionSheet({
    super.key,
    required this.propertyId,
    required this.propertyName,
    required this.propertyImage,
    this.role = Role.renter,
  });

  @override
  State<AddToCollectionSheet> createState() => _AddToCollectionSheetState();
}

class _AddToCollectionSheetState extends State<AddToCollectionSheet> {
  final Set<String> _selectedIds = {};
  final Set<String> _initialIds = {};
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    context.read<WishlistCubit>().loadCollections(widget.role);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WishlistCubit, WishlistState>(
      listener: (context, state) {
        if (state.status == WishlistStatus.loaded && !_initialized) {
          final existingItem = state.items
              .where((i) => i.propertyId == widget.propertyId)
              .firstOrNull;
          setState(() {
            if (existingItem != null) {
              _selectedIds.addAll(existingItem.collectionIds);
              _initialIds.addAll(existingItem.collectionIds);
            } else {
              // Instagram logic: default to All Saved if new
              _selectedIds.add(WishlistConstants.allSavedCollectionId);
              // Note: If toggle was called just before this, initialIds might already have it
              // depending on when state updated. We assume selected reflects current visual.
            }
            _initialized = true;
          });
        }
      },
      builder: (context, state) {
        final collections = state.collections;

        return Container(
          decoration: const BoxDecoration(
            color: AppColors.cream,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.fromLTRB(
              24, 12, 24, MediaQuery.of(context).viewInsets.bottom + 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                          color: AppColors.border,
                          borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 24),
              Text('Save to...',
                  style: AppTheme.dm(
                      size: 20,
                      weight: FontWeight.w800,
                      color: AppColors.navy)),
              const SizedBox(height: 16),
              if (state.status == WishlistStatus.loading && collections.isEmpty)
                const Center(
                    child: Padding(
                        padding: EdgeInsets.all(40.0),
                        child:
                            CircularProgressIndicator(color: AppColors.gold))),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: collections.map((collection) {
                      final isSelected = _selectedIds.contains(collection.id);
                      final wasInitial = _initialIds.contains(collection.id);

                      // Calculate dynamic count feedback
                      int displayCount = collection.itemCount;
                      if (isSelected && !wasInitial) displayCount++;
                      if (!isSelected && wasInitial) displayCount--;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _selectedIds.remove(collection.id);
                            } else {
                              _selectedIds.add(collection.id);
                            }
                          });
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.white
                                : AppColors.white.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(16),
                            border: isSelected
                                ? Border.all(color: AppColors.gold, width: 1.5)
                                : Border.all(color: Colors.transparent),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.gold.withValues(alpha: 0.15)
                                        : AppColors.faint,
                                    borderRadius: BorderRadius.circular(12)),
                                child: Icon(
                                  Icons.folder_rounded,
                                  color: isSelected
                                      ? AppColors.gold
                                      : AppColors.muted,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(collection.name,
                                        style: AppTheme.dm(
                                            size: 15,
                                            weight: isSelected
                                                ? FontWeight.w700
                                                : FontWeight.w600,
                                            color: AppColors.navy)),
                                    Text('$displayCount places',
                                        style: AppTheme.dm(
                                            size: 12, color: AppColors.muted)),
                                  ],
                                ),
                              ),
                              Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isSelected
                                      ? AppColors.gold
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.gold
                                        : AppColors.border,
                                    width: 2,
                                  ),
                                ),
                                child: isSelected
                                    ? const Icon(Icons.check,
                                        size: 14, color: Colors.white)
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              NavyButton(
                label: 'Done',
                onTap: () {
                  context.read<WishlistCubit>().updatePropertyCollections(
                        propertyId: widget.propertyId,
                        propertyName: widget.propertyName,
                        propertyImage: widget.propertyImage,
                        collectionIds: _selectedIds.toList(),
                        role: widget.role,
                      );
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: () {
                    _showCreateSheet(context);
                  },
                  child: Text('+ Create New Collection',
                      style: AppTheme.dm(
                          size: 14,
                          weight: FontWeight.w700,
                          color: AppColors.gold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showCreateSheet(BuildContext context) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const CreateCollectionSheet(),
    );

    if (result != null && result.isNotEmpty && context.mounted) {
      context.read<WishlistCubit>().createCollection(result, widget.role);
    }
  }
}
