import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/kit.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';

class OwnerRateGuestScreen extends StatefulWidget {
  final Property? property;

  const OwnerRateGuestScreen({super.key, this.property});

  @override
  State<OwnerRateGuestScreen> createState() => _OwnerRateGuestScreenState();
}

class _OwnerRateGuestScreenState extends State<OwnerRateGuestScreen> {
  int _selectedRating = 0;
  final TextEditingController _commentController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _onRatingChanged(int rating) {
    setState(() {
      _selectedRating = rating;
    });
  }

  Future<void> _submitRating() async {
    if (_selectedRating == 0) return;

    setState(() => _isSubmitting = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() => _isSubmitting = false);
      // Show success and pop
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Guest rated successfully! +5 Stars earned.'),
          backgroundColor: AppColors.success,
        ),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final prop = widget.property;

    return PhoneScaffold(
      child: Column(
        children: [
          const TopBar(title: 'Rate Guest', subtitle: 'Share your feedback'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  // Guest Info (Placeholder)
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Color(0xFFE0E0E0),
                    child: Icon(Icons.person, size: 40, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Omar K.',
                    style: AppTheme.dm(
                      size: 20,
                      weight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                  Text(
                    'Guest at ${prop?.name ?? "Azure Beach Villa"}',
                    style: AppTheme.dm(size: 14, color: AppColors.muted),
                  ),
                  const SizedBox(height: 40),

                  // Rating Card
                  WhiteCard(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Text(
                          'How was the guest?',
                          style: AppTheme.dm(
                            size: 18,
                            weight: FontWeight.w700,
                            color: AppColors.navy,
                          ),
                        ),
                        const SizedBox(height: 20),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(5, (index) {
                              final rating = index + 1;
                              return GestureDetector(
                                onTap: () => _onRatingChanged(rating),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  child: Icon(
                                    index < _selectedRating
                                        ? Icons.star
                                        : Icons.star_border,
                                    size: 40,
                                    color: index < _selectedRating
                                        ? AppColors.gold
                                        : const Color(0xFFE0E0E0),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Comment field
                  TextField(
                    controller: _commentController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText:
                          'Leave a private note about the guest (optional)...',
                      hintStyle: AppTheme.dm(color: AppColors.placeholder),
                      filled: true,
                      fillColor: AppColors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                    ),
                    style: AppTheme.dm(size: 14),
                  ),
                ],
              ),
            ),
          ),

          // Action Button
          Padding(
            padding: const EdgeInsets.all(20),
            child: NavyButton(
              label:
                  _isSubmitting ? 'Submitting...' : 'Submit Rating · earn +5 ★',
              enabled: _selectedRating > 0 && !_isSubmitting,
              onTap: _submitRating,
            ),
          ),
        ],
      ),
    );
  }
}
