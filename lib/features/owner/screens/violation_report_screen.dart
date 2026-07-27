import 'package:flutter/material.dart';
import 'package:sahely/core/navigation/app_navigation.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/kit.dart';
import 'package:sahely/core/widgets/ui.dart';

class ViolationReportScreen extends StatelessWidget {
  const ViolationReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PhoneScaffold(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              children: [
                const TopBar(title: 'Violation Report'),
                const SizedBox(height: 16),
                WhiteCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text('Property damage — not reported',
                                style: AppTheme.dm(
                                    size: 16,
                                    weight: FontWeight.w700,
                                    color: AppColors.navy)),
                          ),
                          const StatusBadge('Open', kind: BadgeKind.red),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text('Azure Beach Villa · SHLY-8842',
                          style: AppTheme.dm(size: 13, color: AppColors.muted)),
                      const SizedBox(height: 20),
                      Text('Description',
                          style: AppTheme.dm(
                              size: 14, weight: FontWeight.w700, color: AppColors.navy)),
                      const SizedBox(height: 8),
                      Text(
                          'Broken glass table found after checkout and not declared in the post check-out report within 24h. This violates the owner maintenance agreement (Section 4.2).',
                          style: AppTheme.dm(size: 13, color: AppColors.ink, height: 1.5)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                WhiteCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Financial Impact',
                          style: AppTheme.dm(
                              size: 14, weight: FontWeight.w700, color: AppColors.navy)),
                      const SizedBox(height: 12),
                      const KeyValueRow('Deduction Amount', '− EGP 1,500',
                          valueColor: Color(0xFFB22222)),
                      const KeyValueRow('Date Reported', 'Jun 18, 2026'),
                      const KeyValueRow('Applied to Payout', 'Pending'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text('Evidence Provided by Team',
                    style: AppTheme.dm(
                        size: 15, weight: FontWeight.w700, color: AppColors.navy)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _evidenceImage('https://images.unsplash.com/photo-1581704906775-891dd5207444?q=80&w=200&auto=format&fit=crop'),
                    const SizedBox(width: 12),
                    _evidenceImage('https://images.unsplash.com/photo-1595428774223-ef52624120d2?q=80&w=200&auto=format&fit=crop'),
                  ],
                ),
                const SizedBox(height: 16),
                WhiteCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Timeline',
                          style: AppTheme.dm(
                              size: 14, weight: FontWeight.w700, color: AppColors.navy)),
                      const SizedBox(height: 16),
                      _timelineStep('Violation Reported', 'Jun 18, 10:24 AM', true),
                      _timelineStep('Evidence Verified', 'Jun 18, 02:15 PM', true),
                      _timelineStep('Deduction Calculated', 'Jun 18, 04:30 PM', true),
                      _timelineStep('Owner Notified', 'Jun 18, 04:35 PM', true, last: true),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _evidenceImage(String url) {
    return Expanded(
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: NetworkImage(url),
            fit: BoxFit.cover,
          ),
          border: Border.all(color: AppColors.border),
        ),
      ),
    );
  }

  Widget _timelineStep(String title, String time, bool completed, {bool last = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: completed ? AppColors.success : AppColors.muted,
                shape: BoxShape.circle,
              ),
            ),
            if (!last)
              Container(
                width: 2,
                height: 30,
                color: AppColors.border,
              ),
          ],
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: AppTheme.dm(
                    size: 13, weight: FontWeight.w600, color: AppColors.navy)),
            Text(time, style: AppTheme.dm(size: 11, color: AppColors.muted)),
          ],
        ),
      ],
    );
  }
}
