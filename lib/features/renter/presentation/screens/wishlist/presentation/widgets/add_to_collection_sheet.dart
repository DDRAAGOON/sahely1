import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/data/models.dart';
import 'package:sahely/features/renter/domain/models/wishlist_item.dart';
import 'package:sahely/features/renter/presentation/screens/wishlist/widgets/create_collection_sheet.dart';
import 'package:sahely/features/renter/presentation/screens/wishlist/presentation/bloc/wishlist_cubit.dart';

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
  List<WishlistCollection> _collections = [];
  String? _selectedCollectionId;

  @override
  void initState() {
    super.initState();
    context.read<WishlistCubit>().loadCollections(widget.role);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WishlistCubit, WishlistState>(
      listener: (context, state) {
        if (state.status == WishlistStatus.loaded) {
          setState(() {
            _collections = state.collections;
            if (_selectedCollectionId == null && _collections.isNotEmpty) {
              _selectedCollectionId = _collections.first.id;
            }
          });
        }
      },
      builder: (context, state) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.cream,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
              Text('Add to collection',
                  style: AppTheme.dm(
                      size: 20,
                      weight: FontWeight.w700,
                      color: AppColors.navy)),
              const SizedBox(height: 16),
              if (state.status == WishlistStatus.loading && _collections.isEmpty)
                const Center(
                    child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child:
                            CircularProgressIndicator(color: AppColors.gold))),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: _collections.map((collection) {
                      final isSelected = _selectedCollectionId == collection.id;
                      return GestureDetector(
                        onTap: () => setState(
                            () => _selectedCollectionId = collection.id),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.white
                                : AppColors.white.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(12),
                            border : null,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                    color:
                                        AppColors.gold.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Icon(Icons.folder,
                                    color: AppColors.gold, size: 20),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(collection.name,
                                        style: AppTheme.dm(
                                            size: 14,
                                            weight: FontWeight.w600,
                                            color: AppColors.navy)),
                                    Text('${collection.itemCount} places',
                                        style: AppTheme.dm(
                                            size: 12,
                                            color: AppColors.secondary)),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                const Icon(Icons.check_circle,
                                    color: AppColors.gold, size: 22),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _selectedCollectionId != null
                      ? () {
                          context
                              .read<WishlistCubit>()
                              .saveToSpecificCollection(
                                propertyId: widget.propertyId,
                                propertyName: widget.propertyName,
                                propertyImage: widget.propertyImage,
                                collectionId: _selectedCollectionId!,
                                role: widget.role,
                              );
                          Navigator.pop(context);
                        } : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.navy,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('Save to Collection',
                      style: AppTheme.dm(
                          size: 15,
                          color: AppColors.white,
                          weight: FontWeight.w700)),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: () {
                    _showCreateSheet(context);
                  },
                  child: Text('+ New Collection',
                      style: AppTheme.dm(
                          size: 14,
                          weight: FontWeight.w600,
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

    if (result != null && result.isNotEmpty && mounted) {
      context.read<WishlistCubit>().createCollection(result, widget.role);
    }
  }
}
