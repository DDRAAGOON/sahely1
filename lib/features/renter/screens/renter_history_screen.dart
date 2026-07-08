import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/chips.dart';
import '../../../widgets/kit.dart';
import '../../../widgets/cream_background.dart';

class RenterHistoryScreen extends StatefulWidget {
  const RenterHistoryScreen({super.key});

  @override
  State<RenterHistoryScreen> createState() => _RenterHistoryScreenState();
}

class _RenterHistoryScreenState extends State<RenterHistoryScreen> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return PhoneScaffold(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
        children: [
          const TopBar(title: 'History', subtitle: 'Payments · Credit · Violations'),
          const SizedBox(height: 18),
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              children: [
                for (final f in ['All', 'Payments', 'Credit', 'Violations']) ...[
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
          const SizedBox(height: 22),
          const SectionLabel('THIS MONTH'),
          const SizedBox(height: 12),
          WhiteCard(
            child: Column(children: [
              _activity(Icons.credit_card, const Color(0xFFFDECEC), 'Booking payment', 'Azure Villa · Jun 14', '−21,090',
                  const Color(0xFFB22222)),
              _activity(Icons.add, const Color(0xFFE6F4EC), 'Credit added', 'Visa ••42 · Jun 10', '+500', AppColors.success),
              _activity(Icons.warning_amber_rounded, const Color(0xFFFCEEDD), 'Late checkout fine', 'Jun 9 · Violation', '−300',
                  const Color(0xFFB22222),
                  last: true),
            ]),
          ),
          const SizedBox(height: 20),
          const SectionLabel('LAST MONTH'),
          const SizedBox(height: 12),
          WhiteCard(
            child: Column(children: [
              _activity(Icons.check, const Color(0xFFE6F4EC), 'Refund · cancelled stay', 'May 28', '+1,200', AppColors.success),
              _activity(Icons.credit_card, const Color(0xFFFDECEC), 'Booking payment', 'Lagoon Retreat · May 20', '−18,400',
                  const Color(0xFFB22222),
                  last: true),
            ]),
          ),
          const SizedBox(height: 24),
          Center(
              child: Text('Renter view — every booking payment, credit top-up & violation in one place.',
                  textAlign: TextAlign.center, style: AppTheme.dm(size: 11, color: AppColors.faint))),
        ],
      ),
    );
  }

  Widget _activity(IconData icon, Color bg, String title, String sub, String amount, Color amountColor, {bool last = false}) {
    final violation = sub.contains('Violation');
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: last ? null : const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFF4EFE7)))),
      child: Row(children: [
        Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
            child: Icon(icon,
                size: 16,
                color: amountColor == AppColors.success
                    ? AppColors.success
                    : (bg == const Color(0xFFFCEEDD) ? const Color(0xFFD2760A) : const Color(0xFFB22222)))),
        const SizedBox(width: 12),
        Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: AppTheme.dm(size: 13, weight: FontWeight.w600)),
          Text(sub, style: AppTheme.dm(size: 11, color: violation ? const Color(0xFFD2760A) : AppColors.muted)),
        ])),
        Text(amount, style: AppTheme.dm(size: 14, weight: FontWeight.w700, color: amountColor)),
      ]),
    );
  }
}
