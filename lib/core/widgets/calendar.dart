import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import 'cards.dart';

class AvailabilityCalendar extends StatelessWidget {
  const AvailabilityCalendar({
    super.key,
    this.ongoing = const [],
    this.upcoming = const [],
    this.blocked = const [],
    this.ownerOff = const [],
    this.legend = const ['Ongoing', 'Upcoming', 'Blocked'],
  });

  final List<int> ongoing;
  final List<int> upcoming;
  final List<int> blocked;
  final List<int> ownerOff;
  final List<String> legend;

  Color? _bg(int d) {
    if (ongoing.contains(d)) return AppColors.success;
    if (upcoming.contains(d)) return AppColors.navy;
    if (ownerOff.contains(d)) return const Color(0xFFB22222);
    if (blocked.contains(d)) return const Color(0xFFE6EAF2);
    return null;
  }

  Color _fg(int d) {
    if (ongoing.contains(d) || upcoming.contains(d) || ownerOff.contains(d))
      return AppColors.white;
    return AppColors.ink;
  }

  @override
  Widget build(BuildContext context) {
    return WhiteCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('June 2026',
                  style: AppTheme.dm(
                      size: 14,
                      weight: FontWeight.w600,
                      color: AppColors.navy)),
              const Row(children: [
                Icon(Icons.chevron_left, size: 18, color: AppColors.muted),
                SizedBox(width: 12),
                Icon(Icons.chevron_right, size: 18, color: AppColors.muted),
              ]),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              for (final d in ['S', 'M', 'T', 'W', 'T', 'F', 'S'])
                Expanded(
                    child: Center(
                        child: Text(d,
                            style: AppTheme.dm(
                                size: 11, color: AppColors.muted)))),
            ],
          ),
          const SizedBox(height: 6),
          GridView.count(
            crossAxisCount: 7,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            childAspectRatio: 1.2,
            children: [
              for (var d = 1; d <= 30; d++)
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: _bg(d), borderRadius: BorderRadius.circular(8)),
                  child: Text('$d',
                      style: AppTheme.dm(
                          size: 12,
                          color: _fg(d),
                          weight: _bg(d) != null
                              ? FontWeight.w600
                              : FontWeight.w400)),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 6,
            children: [
              for (final l in legend) _legendItem(l),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendItem(String label) {
    final color = switch (label) {
      'Ongoing' => AppColors.success,
      'Upcoming' => AppColors.navy,
      'Owner days-off' => const Color(0xFFB22222),
      _ => const Color(0xFFE6EAF2),
    };
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(3))),
        const SizedBox(width: 5),
        Text(label, style: AppTheme.dm(size: 11, color: AppColors.muted)),
      ],
    );
  }
}
