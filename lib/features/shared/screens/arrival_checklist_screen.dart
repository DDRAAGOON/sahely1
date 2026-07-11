import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/kit.dart';
import '../../../core/widgets/ui.dart';

class ArrivalChecklistScreen extends StatefulWidget {
  const ArrivalChecklistScreen({super.key});

  @override
  State<ArrivalChecklistScreen> createState() => _ArrivalChecklistScreenState();
}

class _ArrivalChecklistScreenState extends State<ArrivalChecklistScreen> {
  final List<Map<String, dynamic>> _items = [
    {'label': 'Pool clean & usable', 'done': true, 'issue': false},
    {'label': 'WiFi works (password on fridge)', 'done': true, 'issue': false},
    {'label': 'AC in all rooms', 'done': true, 'issue': false},
    {'label': '5 beds made & linens fresh', 'done': true, 'issue': false},
    {'label': 'Beach access tags (4)', 'done': false, 'issue': false},
    {'label': 'Kitchen fully equipped', 'done': false, 'issue': false},
  ];

  @override
  Widget build(BuildContext context) {
    return PhoneScaffold(
      child: Column(children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
            children: [
              const TopBar(title: 'Arrival Checklist', subtitle: 'Confirm everything is perfect'),
              const SizedBox(height: 16),
              const InfoNote(text: 'Reporting issues within 2 hours of check-in helps us resolve them faster.', icon: Icons.info_outline),
              const SizedBox(height: 16),
              WhiteCard(
                child: Column(children: [
                  for (var i = 0; i < _items.length; i++) ...[
                    _CheckItem(
                      label: _items[i]['label'],
                      done: _items[i]['done'],
                      issue: _items[i]['issue'],
                      onToggle: () => setState(() => _items[i]['done'] = !_items[i]['done']),
                      onIssue: () => setState(() => _items[i]['issue'] = !_items[i]['issue']),
                    ),
                    if (i < _items.length - 1) const Divider(height: 1, color: Color(0xFFF4EFE7)),
                  ],
                ]),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: NavyButton(label: 'Submit Checklist', onTap: () => Navigator.pop(context)),
        ),
      ]),
    );
  }
}

class _CheckItem extends StatelessWidget {
  const _CheckItem({required this.label, required this.done, required this.issue, required this.onToggle, required this.onIssue});
  final String label;
  final bool done, issue;
  final VoidCallback onToggle, onIssue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Column(
        children: [
          Row(children: [
            GestureDetector(
              onTap: onToggle,
              child: Container(
                width: 24, height: 24,
                decoration: BoxDecoration(color: done ? AppColors.success : Colors.transparent, border: Border.all(color: done ? AppColors.success : AppColors.border, width: 2), borderRadius: BorderRadius.circular(6)),
                child: done ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: AppTheme.dm(size: 14, weight: done ? FontWeight.w600 : FontWeight.w400, color: done ? AppColors.navy : AppColors.ink))),
            GestureDetector(
              onTap: onIssue,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: issue ? const Color(0xFFFDECEC) : Colors.transparent, borderRadius: BorderRadius.circular(6)),
                child: Text('Issue?', style: AppTheme.dm(size: 12, weight: FontWeight.w600, color: issue ? AppColors.danger : AppColors.muted)),
              ),
            ),
          ]),
          if (issue) ...[
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: 'Describe the issue...',
                hintStyle: AppTheme.dm(size: 13, color: AppColors.faint),
                filled: true,
                fillColor: const Color(0xFFFDECEC).withValues(alpha: 0.5),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.danger)),
                contentPadding: const EdgeInsets.all(10),
              ),
              maxLines: 2,
              style: AppTheme.dm(size: 13),
            ),
          ],
        ],
      ),
    );
  }
}
