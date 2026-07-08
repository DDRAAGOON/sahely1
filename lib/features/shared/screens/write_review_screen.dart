import 'package:flutter/material.dart';
import '../../../data/models.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../widgets/buttons.dart';
import '../widgets/cream_background.dart';
import '../widgets/top_bar.dart';


class WriteReviewScreen extends StatefulWidget {
  const WriteReviewScreen({super.key});

  @override
  State<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends State<WriteReviewScreen> {
  int _rating = 0;
  final TextEditingController _comment = TextEditingController();

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final property = ModalRoute.of(context)?.settings.arguments as Property?;
    final name = property?.name ?? 'Lagoon Retreat';

    return PhoneScaffold(
      child: Column(children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
            children: [
              TopBar(title: 'Write a Review', subtitle: name),
              const SizedBox(height: 24),
              Center(child: Text('How was your stay?', style: AppTheme.dm(size: 20, weight: FontWeight.w700, color: AppColors.navy))),
              const SizedBox(height: 16),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                for (var i = 1; i <= 5; i++)
                  GestureDetector(
                    onTap: () => setState(() => _rating = i),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(i <= _rating ? Icons.star : Icons.star_border, size: 44, color: AppColors.gold),
                    ),
                  ),
              ]),
              const SizedBox(height: 32),
              Text('Share your experience', style: AppTheme.dm(size: 15, weight: FontWeight.w700, color: AppColors.navy)),
              const SizedBox(height: 10),
              TextField(
                controller: _comment,
                maxLines: 6,
                decoration: InputDecoration(
                  hintText: 'What did you love? Anything we could improve?',
                  hintStyle: AppTheme.dm(size: 14, color: AppColors.faint),
                  filled: true,
                  fillColor: AppColors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.border)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.border)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.gold)),
                ),
                style: AppTheme.dm(size: 14),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: const Color(0xFFFDF9F4), borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE7D9A8))),
                child: Row(children: [
                  const Icon(Icons.stars, color: AppColors.gold, size: 24),
                  const SizedBox(width: 12),
                  Expanded(child: Text('Earn 5 Sahel Stars for your first review of this property!', style: AppTheme.dm(size: 13, weight: FontWeight.w600, color: const Color(0xFF9A7A22)))),
                ]),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: NavyButton(
            label: 'Submit Review', 
            enabled: _rating > 0,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Thank you for your review!'), backgroundColor: AppColors.success));
              Navigator.pop(context);
            }
          ),
        ),
      ]),
    );
  }
}
