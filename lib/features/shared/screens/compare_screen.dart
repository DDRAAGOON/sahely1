import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/kit.dart';

const _azure = 'https://images.unsplash.com/photo-1776762893024-890728937eab?w=800&q=72&auto=format&fit=crop';
const _dunes = 'https://images.unsplash.com/photo-1776619316276-b1b461af9f15?w=800&q=72&auto=format&fit=crop';

class CompareScreen extends StatelessWidget {
  const CompareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
              child: Row(children: [
                const Text('Compare', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.gold)),
                const Spacer(),
                Container(
                    height: 30,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(color: AppColors.gold, borderRadius: BorderRadius.circular(16)),
                    child: const Row(children: [
                      Icon(Icons.link, size: 14, color: AppColors.navy),
                      SizedBox(width: 4),
                      Text('Share',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.navy))
                    ])),
                const SizedBox(width: 10),
                GestureDetector(
                    onTap: () => Navigator.maybePop(context),
                    child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12), shape: BoxShape.circle),
                        child: const Icon(Icons.close, size: 16, color: Colors.white))),
              ]),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                    color: AppColors.cream, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Row(children: [
                      Expanded(child: _photoCard(_azure, 'Azure Villa', 'EGP 4,500 / night')),
                      const SizedBox(width: 10),
                      Expanded(child: _photoCard(_dunes, 'Golden Dunes', 'EGP 3,800 / night')),
                    ]),
                    const SizedBox(height: 14),
                    WhiteCard(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      child: Column(children: [
                        _row('Location', 'Marassi · N.Coast', 'Hacienda Bay', 0),
                        _row('Type', 'Villa', 'Chalet', -1),
                        _row('Rating', '★ 4.8', '★ 4.7', 0),
                        _row('Bedrooms', '4 bdr · 6 beds', '3 bdr · 5 beds', 0),
                        _row('Bathrooms', '3', '2', -1),
                        _row('View', 'Sea view', 'Dune view', 0),
                        _row('Beach', 'Marina Beach', 'Lagoon Beach', -1),
                        _row('Beach access', 'Free', 'EGP 150 / day', 0),
                        _row('Pool', '✓', '×', 0, check: true),
                        _row('To beach', '3 min', '7 min', 0),
                      ]),
                    ),
                    const SizedBox(height: 14),
                    const Row(children: [
                      Expanded(child: WideButton(label: 'Book Azure', color: AppColors.navy, height: 44)),
                      SizedBox(width: 10),
                      Expanded(
                          child: WideButton(
                              label: 'Book Dunes', color: AppColors.gold, textColor: AppColors.navy, height: 44)),
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _photoCard(String img, String name, String price) => ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          height: 106,
          child: Stack(fit: StackFit.expand, children: [
            Image.network(img,
                fit: BoxFit.cover, errorBuilder: (_, __, ___) => const ColoredBox(color: AppColors.cardWarm)),
            const DecoratedBox(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Color(0xCC000000)]))),
            Positioned(
                left: 10,
                bottom: 8,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(name, style: AppTheme.dm(size: 14, weight: FontWeight.w700, color: Colors.white)),
                  Text(price, style: AppTheme.dm(size: 12, weight: FontWeight.w700, color: AppColors.gold)),
                ])),
          ]),
        ),
      );

  Widget _row(String label, String a, String b, int win, {bool check = false}) {
    Widget val(String v, bool winner) {
      if (check) {
        final yes = v == '✓';
        return Center(
            child: Text(v,
                style: AppTheme.dm(
                    size: 14, weight: FontWeight.w700, color: yes ? AppColors.success : const Color(0xFFBBBBBB))));
      }
      return Center(
          child: Text(v,
              style: AppTheme.dm(
                  size: 12, weight: winner ? FontWeight.w700 : FontWeight.w400, color: winner ? AppColors.gold : AppColors.ink)));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(children: [
        Expanded(flex: 11, child: Text(label, style: AppTheme.dm(size: 12, color: AppColors.muted))),
        Expanded(flex: 10, child: val(a, win == 0)),
        Expanded(flex: 10, child: val(b, win == -1)),
      ]),
    );
  }
}
