import 'package:flutter/material.dart';
import 'package:sahely/core/navigation/app_navigation.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/kit.dart';

class ArrivalChecklistSection extends StatefulWidget {
  final List<Map<String, dynamic>>? checklist;
  final ValueChanged<List<Map<String, dynamic>>>? onChecklistChanged;
  final VoidCallback? onReportIssue;

  const ArrivalChecklistSection({
    super.key,
    this.checklist,
    this.onChecklistChanged,
    this.onReportIssue,
  });

  @override
  State<ArrivalChecklistSection> createState() => _ArrivalChecklistSectionState();
}

class _ArrivalChecklistSectionState extends State<ArrivalChecklistSection> {
  late List<Map<String, dynamic>> _items;

  @override
  void initState() {
    super.initState();
    _items = widget.checklist != null 
      ? List<Map<String, dynamic>>.from(widget.checklist!)
      : [
          {'label': 'Check gate clearance', 'completed': true},
          {'label': 'Key collection from lockbox', 'completed': false},
          {'label': 'Electricity & AC inspection', 'completed': false},
          {'label': 'Welcome hamper confirmation', 'completed': false},
        ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Arrival Checklist', style: AppTheme.dm(size: 18, weight: FontWeight.w700, color: AppColors.navy)),
            GestureDetector(
              onTap: widget.onReportIssue ?? () => AppNavigation.goToArrivalChecklist(context),
              child: Text('View Details', style: AppTheme.dm(size: 13, weight: FontWeight.w600, color: AppColors.gold)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        WhiteCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: _items.map((item) => _buildItem(item)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildItem(Map<String, dynamic> item) {
    final bool isDone = item['completed'] ?? item['done'] ?? false;
    final String label = item['label'] ?? item['title'] ?? '';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                if (item.containsKey('completed')) {
                  item['completed'] = !isDone;
                } else {
                  item['done'] = !isDone;
                }
              });
              widget.onChecklistChanged?.call(_items);
            },
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: isDone ? AppColors.success : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: isDone ? AppColors.success : AppColors.borderDefault),
              ),
              child: isDone ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label, style: AppTheme.dm(size: 14, color: isDone ? AppColors.muted : AppColors.navy)),
          ),
        ],
      ),
    );
  }
}
