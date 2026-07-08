import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';

class ArrivalChecklistSection extends StatefulWidget {
  final List<dynamic> checklist;
  final VoidCallback onReportIssue;
  final Function(List<Map<String, dynamic>>)? onChecklistChanged;

  const ArrivalChecklistSection({
    super.key,
    required this.checklist,
    required this.onReportIssue,
    this.onChecklistChanged,
  });

  @override
  State<ArrivalChecklistSection> createState() => _ArrivalChecklistSectionState();
}

class _ArrivalChecklistSectionState extends State<ArrivalChecklistSection> {
  late List<Map<String, dynamic>> _checklist;

  @override
  void initState() {
    super.initState();
    _checklist = widget.checklist.map((item) {
      if (item is Map) {
        return Map<String, dynamic>.from(item);
      }
      return {'label': item.toString(), 'completed': false};
    }).toList();
  }

  @override
  void didUpdateWidget(ArrivalChecklistSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Important: Update internal state when external checklist changes
    if (widget.checklist != oldWidget.checklist) {
      setState(() {
        _checklist = widget.checklist.map((item) {
          if (item is Map) {
            return Map<String, dynamic>.from(item);
          }
          return {'label': item.toString(), 'completed': false};
        }).toList();
      });
    }
  }

  int get _completedCount => _checklist.where((item) => item['completed'] == true).length;
  int get _totalCount => _checklist.length;

  void _toggleItem(int index) {
    setState(() {
      _checklist[index]['completed'] = !(_checklist[index]['completed'] ?? false);
    });
    widget.onChecklistChanged?.call(_checklist);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Arrival Checklist',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.navy,
                fontFamily: 'DM Sans',
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.gold.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.gold, width: 1),
              ),
              child: Text(
                '$_completedCount / $_totalCount done',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.gold,
                  fontFamily: 'DM Sans',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          'Confirm everything the host listed is here.',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.secondary,
            fontFamily: 'DM Sans',
          ),
        ),
        const SizedBox(height: 12),

        // Checklist Items
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: _checklist.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isCompleted = item['completed'] == true;
              final isLast = index == _checklist.length - 1;

              return Column(
                children: [
                  GestureDetector(
                    onTap: () => _toggleItem(index),
                    child: Container(
                      color: Colors.transparent,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Row(
                        children: [
                          // Checkbox
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: isCompleted ? AppColors.green : Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: isCompleted ? AppColors.green : AppColors.border,
                                width: 2,
                              ),
                            ),
                            child: isCompleted
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 16,
                                  )
                                : null,
                          ),
                          const SizedBox(width: 12),
                          // Label
                          Expanded(
                            child: Text(
                              item['label'] ?? '',
                              style: TextStyle(
                                fontSize: 14,
                                color: isCompleted ? AppColors.secondary : AppColors.dark,
                                fontFamily: 'DM Sans',
                              ),
                            ),
                          ),
                          // Status
                          Text(
                            isCompleted ? 'OK' : 'Check',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isCompleted ? AppColors.green : AppColors.gold,
                              fontFamily: 'DM Sans',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (!isLast)
                    const Divider(
                      height: 1,
                      color: AppColors.border,
                      indent: 16,
                      endIndent: 16,
                    ),
                ],
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 12),

        // Report Issue Button
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton(
            onPressed: widget.onReportIssue,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.navy, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Report an issue to host',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.navy,
                fontFamily: 'DM Sans',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
