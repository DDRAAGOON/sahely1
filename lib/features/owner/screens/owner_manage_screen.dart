import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/floating_nav.dart';
import '../../../core/widgets/kit.dart';
import '../widgets/pending_request_card.dart';

class OwnerManageScreen extends StatelessWidget {
  const OwnerManageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PhoneScaffold(
      child: Stack(children: [
        ListView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
          children: [
            Row(children: [
              const AvatarCircle(
                  size: 52, colors: [Color(0xFFD8B98A), Color(0xFF7D5A2C)]),
              const SizedBox(width: 12),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text('Manage',
                        style: AppTheme.dm(
                            size: 22,
                            weight: FontWeight.w700,
                            color: AppColors.navy)),
                    Text('Layla Mansour',
                        style: AppTheme.dm(size: 13, color: AppColors.muted)),
                  ])),
              GestureDetector(
                onTap: () =>
                    context.push('/owner/add-property'),
                behavior: HitTestBehavior.opaque,
                child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: AppColors.gold,
                        borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.add, color: AppColors.navy)),
              ),
            ]),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: const Color(0xFFD7EEDD),
                    borderRadius: BorderRadius.circular(8)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.verified_user_outlined,
                      size: 14, color: AppColors.success),
                  const SizedBox(width: 6),
                  Text('Established Host',
                      style: AppTheme.dm(
                          size: 11,
                          weight: FontWeight.w700,
                          color: AppColors.success)),
                ]),
              ),
            ),
            const SizedBox(height: 16),
            const StatRow(cards: [
              StatCard(value: '3', label: 'Properties'),
              StatCard(value: '7', label: 'Active Bookings'),
              StatCard(value: '68.4k', label: 'EGP / month'),
            ]),
            const SizedBox(height: 14),
            Row(children: [
              Expanded(
                  child: _quickTile(context, 'Wallet', Icons.credit_card,
                      AppColors.gold, AppColors.navy, '/owner/earnings')),
              const SizedBox(width: 10),
              Expanded(
                  child: _quickTile(
                      context,
                      'Bookings',
                      Icons.calendar_today_outlined,
                      AppColors.navy,
                      AppColors.gold,
                      '/owner/bookings',
                      badge: '2',
                      useGo: true)),
              const SizedBox(width: 10),
              Expanded(
                  child: _quickTile(
                      context,
                      'AI Help',
                      Icons.chat_bubble_outline,
                      AppColors.navy,
                      AppColors.gold,
                      '/owner/ai-chat')),
            ]),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => context.push('/owner/properties'),
              behavior: HitTestBehavior.opaque,
              child: WhiteCard(
                  padding: const EdgeInsets.all(14),
                  child: Row(children: [
                    Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            color: const Color(0xFFF5F0E8),
                            borderRadius: BorderRadius.circular(12)),
                        child: const Icon(Icons.home_work_outlined,
                            color: AppColors.navy)),
                    const SizedBox(width: 12),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Text('My Properties',
                              style: AppTheme.dm(
                                  size: 14,
                                  weight: FontWeight.w700,
                                  color: AppColors.navy)),
                          Text('3 active · tap for insights',
                              style: AppTheme.dm(
                                  size: 12, color: AppColors.muted)),
                        ])),
                    const Icon(Icons.chevron_right, color: AppColors.faint),
                  ])),
            ),
            const SizedBox(height: 12),
            _gradientCta(
                context,
                'Portfolio Insights',
                'All properties · best performer',
                Icons.bar_chart,
                '/owner/portfolio',
                const [Color(0xFF1B2744), Color(0xFF0F1626)]),
            const SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Pending Requests',
                  style: AppTheme.dm(
                      size: 18,
                      weight: FontWeight.w700,
                      color: AppColors.navy)),
              GestureDetector(
                  onTap: () => context.push('/owner/requests'),
                  behavior: HitTestBehavior.opaque,
                  child: Text('View All · 2',
                      style: AppTheme.dm(
                          size: 13,
                          weight: FontWeight.w600,
                          color: AppColors.gold))),
            ]),
            const SizedBox(height: 12),
            PendingRequestCard(
                onTap: () =>
                    context.push('/owner/request-detail')),
          ],
        ),
        const FloatingNav(active: 4),
      ]),
    );
  }

  Widget _quickTile(BuildContext context, String label, IconData icon, Color bg,
      Color fg, String route,
      {String? badge, bool useGo = false}) {
    return GestureDetector(
      onTap: () => useGo ? context.go(route) : context.push(route),
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 76,
        decoration:
            BoxDecoration(color: bg, borderRadius: BorderRadius.circular(14)),
        child: Stack(children: [
          Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, color: fg, size: 22),
            const SizedBox(height: 6),
            Text(label,
                style: AppTheme.dm(
                    size: 12,
                    weight: FontWeight.w600,
                    color:
                        bg == AppColors.gold ? AppColors.navy : Colors.white)),
          ])),
          if (badge != null)
            Positioned(
                top: 8,
                right: 8,
                child: Container(
                    width: 18,
                    height: 18,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        color: Color(0xFFD2760A), shape: BoxShape.circle),
                    child: Text(badge,
                        style: AppTheme.dm(
                            size: 10,
                            weight: FontWeight.w700,
                            color: Colors.white)))),
        ]),
      ),
    );
  }

  Widget _gradientCta(BuildContext context, String title, String sub,
      IconData icon, String route, List<Color> colors) {
    return GestureDetector(
      onTap: () => context.push(route),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: colors),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.gold.withValues(alpha: 0.4))),
        child: Row(children: [
          Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: AppColors.gold, size: 20)),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(title,
                    style: AppTheme.dm(
                        size: 14,
                        weight: FontWeight.w700,
                        color: Colors.white)),
                Text(sub, style: AppTheme.dm(size: 11, color: AppColors.gold)),
              ])),
          const Icon(Icons.chevron_right, color: AppColors.gold),
        ]),
      ),
    );
  }
}
