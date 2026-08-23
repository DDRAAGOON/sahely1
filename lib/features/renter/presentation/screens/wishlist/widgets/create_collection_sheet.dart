import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';

class CreateCollectionSheet extends StatefulWidget {
  const CreateCollectionSheet({super.key});

  @override
  State<CreateCollectionSheet> createState() => _CreateCollectionSheetState();
}

class _CreateCollectionSheetState extends State<CreateCollectionSheet> {
  final _controller = TextEditingController();
  bool _isCreating = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _createCollection() {
    if (_controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a collection name'),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }

    setState(() => _isCreating = true);

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        Navigator.pop(context, _controller.text.trim());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom + 32;
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      padding: EdgeInsets.fromLTRB(24, 16, 24, bottomPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Title
          Text(
            'Create New Collection',
            style: AppTheme.dm(
              size: 20,
              weight: FontWeight.w700,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Give your collection a name to organize your saved properties',
            style: AppTheme.dm(
              size: 13,
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(height: 20),
          // Name Input
          TextField(
            controller: _controller,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'e.g., Summer 2026, Family Trip',
              hintStyle: AppTheme.dm(
                size: 14,
                color: AppColors.placeholder,
              ),
              filled: true,
              fillColor: AppColors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.gold, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
            ),
            style: AppTheme.dm(
              size: 14,
              color: AppColors.dark,
            ),
            onSubmitted: (_) => _createCollection(),
          ),
          const SizedBox(height: 20),
          // Create Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _isCreating ? null : _createCollection,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.navy,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: _isCreating
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.white,
                        ),
                      ),
                    )
                  : Text(
                      'Create Collection',
                      style: AppTheme.dm(
                        size: 15,
                        weight: FontWeight.w700,
                        color: AppColors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
