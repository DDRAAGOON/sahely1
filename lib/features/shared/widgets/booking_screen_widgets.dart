import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

class BookingCalendarCard extends StatelessWidget {
  const BookingCalendarCard({super.key});

  @override
  Widget build(BuildContext context) {
    const selected = [21, 22, 23, 24, 25];
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Color(0x0F1B2744), blurRadius: 12, offset: Offset(0, 2))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('June 2026', style: AppTheme.dm(size: 14, weight: FontWeight.w600, color: AppColors.navy)),
              const Row(
                children: [
                  Icon(Icons.chevron_left, size: 18, color: AppColors.muted),
                  SizedBox(width: 14),
                  Icon(Icons.chevron_right, size: 18, color: AppColors.muted),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              for (final d in ['S', 'M', 'T', 'W', 'T', 'F', 'S'])
                Expanded(child: Center(child: Text(d, style: AppTheme.dm(size: 11, color: AppColors.muted)))),
            ],
          ),
          const SizedBox(height: 6),
          GridView.count(
            crossAxisCount: 7,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            childAspectRatio: 1.3,
            children: [
              for (var d = 15; d <= 27; d++)
                Builder(builder: (_) {
                  final isEnd = d == 21 || d == 25;
                  final isMid = selected.contains(d) && !isEnd;
                  return Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isEnd ? AppColors.navy : (isMid ? const Color(0xFFEFE3C2) : null),
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(d == 21 ? 8 : 0),
                        right: Radius.circular(d == 25 ? 8 : 0),
                      ),
                    ),
                    child: Text(
                      '$d',
                      style: AppTheme.dm(
                        size: 12,
                        color: isEnd ? AppColors.white : AppColors.ink,
                        weight: isEnd ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  );
                }),
            ],
          ),
        ],
      ),
    );
  }
}

class BookingCheckCol extends StatelessWidget {
  const BookingCheckCol(this.label, this.value, {super.key});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTheme.dm(size: 11, color: AppColors.muted)),
        Text(value, style: AppTheme.dm(size: 14, weight: FontWeight.w600, color: AppColors.navy)),
      ],
    );
  }
}

class BookingGuestRow extends StatelessWidget {
  const BookingGuestRow(this.title, this.sub, this.value, {super.key, this.onMinus, this.onPlus});
  final String title;
  final String sub;
  final int value;
  final VoidCallback? onMinus;
  final VoidCallback? onPlus;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTheme.dm(size: 14)),
              Text(sub, style: AppTheme.dm(size: 11, color: AppColors.muted)),
            ],
          ),
          Row(
            children: [
              _circleBtn(Icons.remove, filled: false, enabled: onMinus != null, onTap: onMinus),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Text('$value', style: AppTheme.dm(size: 15, weight: FontWeight.w700)),
              ),
              _circleBtn(Icons.add, filled: true, onTap: onPlus),
            ],
          ),
        ],
      ),
    );
  }

  Widget _circleBtn(IconData icon, {required bool filled, bool enabled = true, VoidCallback? onTap}) => GestureDetector(
        onTap: enabled ? onTap : null,
        child: Container(
          width: 30,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: filled ? AppColors.navy : Colors.transparent,
            border: filled ? null : Border.all(color: enabled ? AppColors.navy : AppColors.border, width: 1.5),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 18, color: filled ? AppColors.white : (enabled ? AppColors.navy : const Color(0xFFBBBBBB))),
        ),
      );
}
