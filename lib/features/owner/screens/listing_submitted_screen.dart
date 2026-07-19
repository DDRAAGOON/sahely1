import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/kit.dart';
import '../../../core/widgets/ui.dart';

class ListingSubmittedScreen extends StatelessWidget {
  final String? propertyName;
  const ListingSubmittedScreen({super.key, this.propertyName});
  
  @override
  Widget build(BuildContext context) {
    final name = propertyName ?? 'Your property';
    
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.6), 
            radius: 1.2, 
            colors: [Color(0xFF243358), Color(0xFF11182C)]
          )
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, 
                    children: [
                      const SuccessCheck(gold: true, size: 110),
                      const SizedBox(height: 32),
                      Text('Listing Submitted 🥳', style: AppTheme.dm(size: 28, weight: FontWeight.w700, color: Colors.white)),
                      const SizedBox(height: 12),
                      RichText(
                        textAlign: TextAlign.center, 
                        text: TextSpan(
                          style: AppTheme.dm(size: 15, color: Colors.white.withValues(alpha: 0.8), height: 1.5), 
                          children: [
                            const TextSpan(text: 'Thank you! '), 
                            TextSpan(text: name, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.goldBright)),
                            const TextSpan(text: ' is now with our team for review.'),
                          ]
                        )
                      ),
                      const SizedBox(height: 32),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.06), 
                          border: Border.all(color: Colors.white.withValues(alpha: 0.12)), 
                          borderRadius: BorderRadius.circular(16)
                        ),
                        child: Row(children: [
                          const Icon(Icons.schedule, color: AppColors.gold, size: 22),
                          const SizedBox(width: 14),
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text('Reviewed within 1–24 hours', style: AppTheme.dm(size: 14, weight: FontWeight.w700, color: Colors.white)),
                            const SizedBox(height: 2),
                            Text("We'll notify you the moment it's decided", style: AppTheme.dm(size: 12, color: Colors.white.withValues(alpha: 0.5))),
                          ])),
                        ]),
                      ),
                      const SizedBox(height: 32),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('What may happen next', style: AppTheme.dm(size: 14, weight: FontWeight.w700, color: AppColors.gold)),
                      ),
                      const SizedBox(height: 16),
                      const _NextStepRow(icon: Icons.check_circle, color: Color(0xFF1B6B3A), text: 'Approved & published — goes live to guests'),
                      const _NextStepRow(icon: Icons.monetization_on, color: AppColors.gold, text: 'Price recommendation to match the market'),
                      const _NextStepRow(icon: Icons.photo_library, color: Colors.orange, text: 'Request for more / better photos'),
                      const _NextStepRow(icon: Icons.cancel, color: Color(0xFFB22222), text: 'Asked to fix details, or declined with reasons', last: true),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: GoldButton(
                  label: 'Back to Manage', 
                  onTap: () => context.go('/owner/manage')
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NextStepRow extends StatelessWidget {
  const _NextStepRow({required this.icon, required this.color, required this.text, this.last = false});
  final IconData icon;
  final Color color;
  final String text;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: AppTheme.dm(size: 13, color: Colors.white.withValues(alpha: 0.85))),
          ),
        ],
      ),
    );
  }
}
