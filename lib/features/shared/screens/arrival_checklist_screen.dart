import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/kit.dart';
import 'package:sahely/l10n/app_localizations.dart';
import 'package:sahely/l10n/app_localizations_ext.dart';

class ArrivalChecklistScreen extends StatefulWidget {
  final String? bookingId;
  final DateTime? checkInTime;
  final List<Map<String, dynamic>>? checklistItems;

  const ArrivalChecklistScreen({
    super.key,
    this.bookingId,
    this.checkInTime,
    this.checklistItems,
  });

  @override
  State<ArrivalChecklistScreen> createState() => _ArrivalChecklistScreenState();
}

class _ArrivalChecklistScreenState extends State<ArrivalChecklistScreen> {
  late List<Map<String, dynamic>> _items;

  @override
  void initState() {
    super.initState();
    _items = widget.checklistItems ??
        [
          {'label': 'chkPool', 'done': true, 'issue': false},
          {'label': 'chkWifi', 'done': true, 'issue': false},
          {'label': 'chkAc', 'done': true, 'issue': false},
          {'label': 'chkBeds', 'done': true, 'issue': false},
          {'label': 'chkBeachTags', 'done': false, 'issue': false},
          {'label': 'chkKitchen', 'done': false, 'issue': false},
        ];
  }

  @override
  Widget build(BuildContext context) {
    return PhoneScaffold(
      child: Column(children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
            children: [
              TopBar(
                  title: AppLocalizations.of(context).arrivalChecklist,
                  subtitle: AppLocalizations.of(context).confirmEverything),
              const SizedBox(height: 16),
              InfoNote(
                  text: AppLocalizations.of(context).checklistNote,
                  icon: Icons.info_outline),
              const SizedBox(height: 16),
              WhiteCard(
                child: Column(children: [
                  for (var i = 0; i < _items.length; i++) ...[
                    _CheckItem(
                      label:
                          AppLocalizations.of(context).t(_items[i]['label']!),
                      done: _items[i]['done'],
                      issue: _items[i]['issue'],
                      onToggle: () => setState(
                          () => _items[i]['done'] = !_items[i]['done']),
                      onIssue: () => setState(
                          () => _items[i]['issue'] = !_items[i]['issue']),
                    ),
                    if (i < _items.length - 1)
                      const Divider(height: 1, color: Color(0xFFF4EFE7)),
                  ],
                ]),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: NavyButton(
              label: AppLocalizations.of(context).submitChecklist,
              onTap: () => Navigator.pop(context, _items)),
        ),
      ]),
    );
  }
}

class _CheckItem extends StatelessWidget {
  const _CheckItem(
      {required this.label,
      required this.done,
      required this.issue,
      required this.onToggle,
      required this.onIssue});

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
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                    color: done ? AppColors.success : Colors.transparent,
                    border: null,
                    borderRadius: BorderRadius.circular(6)),
                child: done
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                    : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
                child: Text(label,
                    style: AppTheme.dm(
                        size: 14,
                        weight: done ? FontWeight.w600 : FontWeight.w400,
                        color: done ? AppColors.navy : AppColors.ink))),
            GestureDetector(
              onTap: onIssue,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: issue ? const Color(0xFFFDECEC) : Colors.transparent,
                    borderRadius: BorderRadius.circular(6)),
                child: Text(AppLocalizations.of(context).issueQ,
                    style: AppTheme.dm(
                        size: 12,
                        weight: FontWeight.w600,
                        color: issue ? AppColors.danger : AppColors.muted)),
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
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.danger)),
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
