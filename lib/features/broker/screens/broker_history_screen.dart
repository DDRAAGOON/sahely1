import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/kit.dart';
import '../../../widgets/cream_background.dart';

class BrokerHistoryScreen extends StatelessWidget {
  const BrokerHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PhoneScaffold(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        children: [
          const TopBar(title: 'History', subtitle: 'Commissions · Payments'),
          const SizedBox(height: 14),
          SizedBox(
              height: 32,
              child: ListView(scrollDirection: Axis.horizontal, children: const [
                _ChoiceChipPillStub('All', true),
                SizedBox(width: 8),
                _ChoiceChipPillStub('Commissions', false),
                SizedBox(width: 8),
                _ChoiceChipPillStub('Payments', false),
              ])),
          const SizedBox(height: 16),
          const SectionLabel('THIS MONTH'),
          const SizedBox(height: 8),
          WhiteCard(
              child: Column(children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
              decoration: BoxDecoration(color: const Color(0xFFFDF9F4), borderRadius: BorderRadius.circular(10)),
              child: Row(children: [
                Container(
                    width: 30,
                    height: 30,
                    decoration:
                        BoxDecoration(color: AppColors.gold.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.star, size: 16, color: AppColors.gold)),
                const SizedBox(width: 10),
                Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Retroactive bonus', style: AppTheme.dm(size: 13, weight: FontWeight.w600)),
                  Text('Gold tier upgrade · Jun 13', style: AppTheme.dm(size: 11, color: AppColors.muted)),
                ])),
                Text('+2,400', style: AppTheme.dm(size: 14, weight: FontWeight.w700, color: AppColors.success)),
              ]),
            ),
            _brk('Commission · Palm Chalet', 'Jun 12', '+1,820', AppColors.success),
            _brk('Commission · Dune House', 'Jun 9 · Pending', '+960', AppColors.navy, pending: true, last: true),
          ])),
          const SizedBox(height: 16),
          const SectionLabel('LAST MONTH'),
          const SizedBox(height: 8),
          WhiteCard(
              child: Column(children: [
            _brk('Commission · Marina Loft', 'May 24', '+1,450', AppColors.success),
            _brk('Booking payment', 'Own stay · May 18', '−9,800', const Color(0xFFB22222), last: true),
          ])),
          const SizedBox(height: 14),
          Center(
              child: Text('Broker view — commissions & your own bookings appear here.',
                  style: AppTheme.dm(size: 11, color: AppColors.faint))),
        ],
      ),
    );
  }

  Widget _brk(String title, String sub, String amount, Color color, {bool pending = false, bool last = false}) => Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: last ? null : const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFF4EFE7)))),
        child: Row(children: [
          Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: AppTheme.dm(size: 13, weight: FontWeight.w600)),
            Text(sub, style: AppTheme.dm(size: 11, color: pending ? const Color(0xFFD2760A) : AppColors.muted)),
          ])),
          Text(amount, style: AppTheme.dm(size: 14, weight: FontWeight.w700, color: color)),
        ]),
      );
}

class _ChoiceChipPillStub extends StatelessWidget {
  const _ChoiceChipPillStub(this.label, this.active);
  final String label;
  final bool active;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: active ? AppColors.navy : AppColors.white,
            border: active ? null : Border.all(color: AppColors.navy),
            borderRadius: BorderRadius.circular(18)),
        child: Text(label, style: AppTheme.dm(size: 12, weight: FontWeight.w600, color: active ? Colors.white : AppColors.navy)),
      );
}
