import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';


class ChecklistTile extends StatelessWidget {
  const ChecklistTile({super.key, required this.label, required this.done, this.trailing, this.warn = false, this.padding});
  final String label;
  final bool done;
  final String? trailing;
  final bool warn;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: done ? const Color(0xFF1B6B3A) : Colors.transparent,
              border: done ? null : Border.all(color: const Color(0xFFC9A84C), width: 1.2),
              borderRadius: BorderRadius.circular(6),
            ),
            alignment: Alignment.center,
            child: done ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: AppTheme.dm(size: 13, color: const Color(0xFF2D2D2D)))),
          if (trailing != null)
            Text(trailing!,
                style: AppTheme.dm(
                    size: 12,
                    weight: FontWeight.w700,
                    color: done ? AppColors.success : (warn ? const Color(0xFFD2760A) : AppColors.gold))),
        ],
      ),
    );
  }
}
