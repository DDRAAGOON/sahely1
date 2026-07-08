import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/kit.dart';
import '../../../widgets/ui.dart';
import '../../../widgets/cream_background.dart';

class RenterWalletScreen extends StatelessWidget {
  const RenterWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PhoneScaffold(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
        children: [
          const TopBar(title: 'Wallet'),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF22335A), AppColors.navy]),
                borderRadius: BorderRadius.circular(18)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Sahely Credit Balance', style: AppTheme.dm(size: 13, color: const Color(0xFFCDD4E0))),
              const SizedBox(height: 6),
              Text('EGP 250', style: AppTheme.dm(size: 32, weight: FontWeight.w700, color: AppColors.gold)),
              const SizedBox(height: 4),
              Text('Use credit toward bookings & services', style: AppTheme.dm(size: 12, color: const Color(0xFF9FB0CF))),
            ]),
          ),
          const SizedBox(height: 14),
          const GoldButton(label: 'Add Credit'),
          const SizedBox(height: 14),
          const Row(children: [
            Expanded(child: StatCard(value: 'EGP 1,200', label: 'Added this season', valueColor: AppColors.success)),
            SizedBox(width: 10),
            Expanded(child: StatCard(value: '1', label: 'Open violations', valueColor: Color(0xFFD2760A))),
          ]),
          const SizedBox(height: 18),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Recent Activity', style: AppTheme.dm(size: 16, weight: FontWeight.w600, color: AppColors.navy)),
            GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/renter/history'),
                child: Text('View All', style: AppTheme.dm(size: 13, weight: FontWeight.w600, color: AppColors.gold))),
          ]),
          const SizedBox(height: 10),
          WhiteCard(
            child: Column(children: [
              _activity(Icons.credit_card, const Color(0xFFFDECEC), 'Booking · Azure Villa', 'Jun 14', '−21,090',
                  const Color(0xFFB22222)),
              _activity(Icons.add, const Color(0xFFE6F4EC), 'Credit added', 'Jun 10 · Visa ••42', '+500', AppColors.success),
              _activity(Icons.warning_amber_rounded, const Color(0xFFFCEEDD), 'Late checkout fine', 'Jun 9 · Violation', '−300',
                  const Color(0xFFB22222),
                  last: true),
            ]),
          ),
          const SizedBox(height: 12),
          Center(
              child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/renter/history'),
                  child: Text('View Full History →', style: AppTheme.dm(size: 13, weight: FontWeight.w600, color: AppColors.gold)))),
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
