import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/features/renter/presentation/screens/wishlist/domain/models/wishlist_item.dart';
import 'package:sahely/features/renter/presentation/screens/wishlist/widgets/create_collection_sheet.dart';
import 'package:sahely/features/renter/presentation/screens/wishlist/presentation/bloc/wishlist_cubit.dart';

class AddToCollectionSheet extends StatefulWidget {
  final String propertyId;
  final String propertyName;
  final String propertyImage;

  const AddToCollectionSheet({
    super.key,
    required this.propertyId,
    required this.propertyName,
    required this.propertyImage,
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
    context.read<WishlistCubit>().loadCollections();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WishlistCubit, WishlistState>(
      listener: (context, state) {
        if (state is CollectionsLoaded) {
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
              const Text('Add to collection',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                      fontFamily: 'DM Sans')),
              const SizedBox(height: 16),
              if (state is WishlistLoading && _collections.isEmpty)
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
                            border: Border.all(
                                color: isSelected
                                    ? AppColors.gold
                                    : AppColors.border,
                                width: isSelected ? 2 : 1),
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
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.navy,
                                            fontFamily: 'DM Sans')),
                                    Text('${collection.itemCount} places',
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColors.secondary,
                                            fontFamily: 'DM Sans')),
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
                              );
                          Navigator.pop(context);
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.navy,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Save to Collection',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'DM Sans')),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: () {
                    _showCreateSheet(context);
                  },
                  child: const Text('+ New Collection',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.gold,
                          fontFamily: 'DM Sans')),
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
      context.read<WishlistCubit>().createCollection(result);
    }
  }
}
