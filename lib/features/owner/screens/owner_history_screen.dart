import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/kit.dart';
import '../../../core/widgets/ui.dart';
import '../../../core/widgets/chips.dart';

class OwnerHistoryScreen extends StatefulWidget {
  final String? period;
  const OwnerHistoryScreen({super.key, this.period});

  @override
  State<OwnerHistoryScreen> createState() => _OwnerHistoryScreenState();
}

class _OwnerHistoryScreenState extends State<OwnerHistoryScreen> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final periodArg = widget.period ?? 'Month';
    final periodLabel = periodArg == 'Month' ? 'MONTH' : (periodArg == 'Quarter' ? 'QUARTER' : 'YEAR');

    return PhoneScaffold(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        children: [
          TopBar(title: 'History', subtitle: 'Payouts · Payments · $periodArg History'),
          const SizedBox(height: 14),
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              children: [
                for (final f in ['All', 'Payouts', 'Payments', 'Violations']) ...[
                  ChoiceChipPill(
                    f,
                    selected: _selectedFilter == f,
                    height: 36,
                    horizontalPadding: 16,
                    onTap: () => setState(() => _selectedFilter = f),
                  ),
                  const SizedBox(width: 8),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          SectionLabel('THIS $periodLabel'),
          const SizedBox(height: 8),
          WhiteCard(
            child: Column(
              children: [
                if (_selectedFilter == 'All' || _selectedFilter == 'Payouts')
                  _hist('Payout · Azure Villa', 'Jun 14 · to bank', '+18,000', AppColors.success),
                if (_selectedFilter == 'All' || _selectedFilter == 'Payouts')
                  _hist('Payout · Golden Dunes', 'Jun 11 · Pending', '+15,200', AppColors.navy, pending: true),
                if (_selectedFilter == 'All' || _selectedFilter == 'Violations')
                  _hist('Cleaning damage fine', 'Jun 6 · Violation', '−500', const Color(0xFFB22222), last: true),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SectionLabel('LAST $periodLabel'),
          const SizedBox(height: 8),
          if (_selectedFilter == 'All' || _selectedFilter == 'Payouts')
            WhiteCard(
              child: _hist(
                'Payout · Azure Villa',
                periodArg == 'Month' ? 'May 30 · to bank' : (periodArg == 'Quarter' ? 'Q1 · to bank' : '2025 · to bank'),
                '+22,000',
                AppColors.success,
                last: true,
              ),
            ),
          const SizedBox(height: 14),
          Center(
            child: Text(
              'Owner view — payouts lead, plus any bookings you make and violations.',
              textAlign: TextAlign.center,
              style: AppTheme.dm(size: 11, color: AppColors.faint),
            ),
          ),
        ],
      ),
    );
  }

  Widget _hist(String title, String sub, String amount, Color color, {bool pending = false, bool last = false}) => Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: last ? null : const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFF4EFE7)))),
        child: Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: AppTheme.dm(size: 13, weight: FontWeight.w600)),
            Text(sub, style: AppTheme.dm(size: 11, color: pending ? const Color(0xFFD2760A) : AppColors.muted)),
          ])),
          Text(amount, style: AppTheme.dm(size: 14, weight: FontWeight.w700, color: color)),
        ]),
      );
}

class ChoiceChipPillStub extends StatelessWidget {
  const ChoiceChipPillStub(this.label, this.active, {super.key});
  final String label;
  final bool active;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(color: active ? AppColors.navy : AppColors.white, border: active ? null : Border.all(color: AppColors.navy), borderRadius: BorderRadius.circular(18)),
        child: Text(label, style: AppTheme.dm(size: 12, weight: FontWeight.w600, color: active ? Colors.white : AppColors.navy)),
      );
}

class ViolationsScreen extends StatelessWidget {
  const ViolationsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return PhoneScaffold(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        children: [
          const TopBar(title: 'Violations'),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: const Color(0xFFFDECEC), borderRadius: BorderRadius.circular(14)),
            child: Row(children: [
              Container(width: 40, height: 40, decoration: BoxDecoration(color: const Color(0xFFB22222), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.warning_amber_rounded, color: Colors.white)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('1 active violation', style: AppTheme.dm(size: 15, weight: FontWeight.w700, color: const Color(0xFFB22222))),
                Text('A deduction may apply to your payout', style: AppTheme.dm(size: 12, color: const Color(0xFF8A3A3A))),
              ])),
            ]),
          ),
          const SizedBox(height: 16),
          WhiteCard(
            padding: const EdgeInsets.all(14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Expanded(child: Text('Property damage — not reported', style: AppTheme.dm(size: 14, weight: FontWeight.w700, color: AppColors.navy))),
                const StatusBadge('Open', kind: BadgeKind.red),
              ]),
              Text('Azure Beach Villa · SHLY-8842', style: AppTheme.dm(size: 12, color: AppColors.muted)),
              const SizedBox(height: 10),
              Text('Broken glass table found after checkout and not declared in the post check-out report within 24h.', style: AppTheme.dm(size: 13, color: AppColors.ink, height: 1.5)),
              const SizedBox(height: 12),
              Row(children: [
                Container(width: 60, height: 60, decoration: BoxDecoration(color: AppColors.cardWarm, borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.image_outlined, color: AppColors.muted)),
                const SizedBox(width: 8),
                Container(width: 60, height: 60, decoration: BoxDecoration(color: AppColors.cardWarm, borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.image_outlined, color: AppColors.muted)),
                const SizedBox(width: 8),
                DottedBorder(color: AppColors.border, radius: 10, child: Container(width: 60, height: 60, alignment: Alignment.center, child: const Text('Receipt', style: TextStyle(fontSize: 10, color: AppColors.muted)))),
              ]),
              const SizedBox(height: 12),
              const KeyValueRow('Deduction', '− EGP 1,500', valueColor: Color(0xFFB22222)),
              const KeyValueRow('Reported on', 'Jun 18, 2026'),
              const SizedBox(height: 12),
              const Row(children: [
                Expanded(child: WideButton(label: 'Dispute', color: AppColors.navy, outline: true, height: 44)),
                SizedBox(width: 10),
                Expanded(child: WideButton(label: 'View full report', color: AppColors.navy, height: 44)),
              ]),
            ]),
          ),
          const SizedBox(height: 16),
          const SectionLabel('RESOLVED'),
          const SizedBox(height: 8),
          WhiteCard(padding: const EdgeInsets.all(14), child: Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Late check-out cleaning', style: AppTheme.dm(size: 14, weight: FontWeight.w700, color: AppColors.navy)),
              Text('Golden Dunes · May 20', style: AppTheme.dm(size: 12, color: AppColors.muted)),
            ])),
            const StatusBadge('Cleared', kind: BadgeKind.greenSoft),
          ])),
        ],
      ),
    );
  }
}
