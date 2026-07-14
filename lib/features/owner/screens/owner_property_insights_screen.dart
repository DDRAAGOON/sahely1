import 'package:flutter/material.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';
import '../../../data/models.dart';
import '../../../data/sample_data.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/common.dart';
import '../../../core/widgets/kit.dart';
import '../../../core/widgets/ui.dart';

class OwnerPropertyInsightsScreen extends StatelessWidget {
  const OwnerPropertyInsightsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final prop = ModalRoute.of(context)?.settings.arguments as Property? ?? Sample.azure;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: CreamBackground(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Stack(children: [
              SizedBox(
              height: 170,
              width: double.infinity,
              child: SahelyImage(imageUrl: prop.image, enableViewer: true),
            ),
              Positioned(top: 44, left: 16, child: GestureDetector(onTap: () => Navigator.maybePop(context), child: Container(width: 34, height: 34, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.92), shape: BoxShape.circle), child: const Icon(Icons.chevron_left, color: AppColors.navy)))),
              Positioned(top: 50, right: 16, child: GestureDetector(onTap: () => Navigator.pushNamed(context, '/sos-owner'), child: const StatusBadge('SOS', kind: BadgeKind.red))),
              Positioned(left: 18, bottom: 12, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(prop.name, style: AppTheme.dm(size: 19, weight: FontWeight.w700, color: Colors.white)),
                Text('${prop.area} · Active', style: AppTheme.dm(size: 12, color: Colors.white70)),
              ])),
            ]),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Expanded(child: WideButton(label: 'Edit property', icon: Icons.edit_outlined, color: AppColors.navy, height: 46, onTap: () => Navigator.pushNamed(context, '/owner/edit'))),
                  const SizedBox(width: 10),
                  Expanded(child: WideButton(label: 'Preview listing', color: AppColors.navy, outline: true, height: 46, onTap: () => Navigator.pushNamed(context, '/owner/preview'))),
                ]),
                const SizedBox(height: 16),
                const StatRow(cards: [StatCard(value: '1,284', label: 'Views ▲18%'), StatCard(value: '96', label: 'Saved'), StatCard(value: '12', label: 'Bookings')]),
                const SizedBox(height: 10),
                const StatRow(cards: [StatCard(value: '88%', label: 'Occupancy'), StatCard(value: '★ 4.8', label: '124 reviews'), StatCard(value: '68.4k', label: 'Revenue/mo')]),
                const SizedBox(height: 16),
                WhiteCard(
                  padding: const EdgeInsets.all(14),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Views · last 7 days', style: AppTheme.dm(size: 13, weight: FontWeight.w700, color: AppColors.navy)),
                        Text('1,284 · ▲ 18% vs last week', style: AppTheme.dm(size: 12, color: AppColors.success)),
                      ]),
                      Text('Peak Sat', style: AppTheme.dm(size: 12, color: AppColors.muted)),
                    ]),
                    const SizedBox(height: 14),
                    SizedBox(height: 90, child: CustomPaint(size: const Size(double.infinity, 90), painter: _SparklinePainter())),
                    const SizedBox(height: 6),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [for (final d in ['M', 'T', 'W', 'T', 'F', 'S', 'S']) Text(d, style: AppTheme.dm(size: 10, color: AppColors.faint))]),
                  ]),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(14)),
                  child: Row(children: [
                    Container(width: 38, height: 38, decoration: BoxDecoration(color: const Color(0xFF46B7A8), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.lock_outline, color: Colors.white, size: 18)),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Door · Locked', style: AppTheme.dm(size: 13, weight: FontWeight.w700, color: Colors.white)),
                      Text('Passcode active for current guest', style: AppTheme.dm(size: 11, color: Colors.white60)),
                    ])),
                    Row(children: [Container(width: 6, height: 6, decoration: const BoxDecoration(color: Color(0xFF2BB673), shape: BoxShape.circle)), const SizedBox(width: 5), Text('Online', style: AppTheme.dm(size: 11, color: const Color(0xFF7BE0A0)))]),
                  ]),
                ),
                const SizedBox(height: 12),
                WideButton(label: 'Manage smart lock', color: AppColors.navy, outline: true, height: 44, onTap: () => Navigator.pushNamed(context, '/owner/smart-lock')),
                const SizedBox(height: 16),
                Text('Availability', style: AppTheme.dm(size: 15, weight: FontWeight.w700, color: AppColors.navy)),
                const SizedBox(height: 8),
                const AvailabilityCalendar(blocked: [4, 5, 6], ongoing: [14, 15, 16, 17, 18], upcoming: [21, 22, 23, 24, 25], ownerOff: [28, 29], legend: ['Ongoing', 'Upcoming', 'Owner days-off', 'Blocked']),
                const SizedBox(height: 12),
                const InfoNote(text: 'Owner days-off — 2 personal days/month. Block them for yourself or keep renting. 2 left this month.'),
                const SizedBox(height: 16),
                Text('Inspection Checklist', style: AppTheme.dm(size: 15, weight: FontWeight.w700, color: AppColors.navy)),
                const SizedBox(height: 8),
                const WhiteCard(child: Column(children: [
                  ChecklistTile(label: 'Pre check-in', done: true, trailing: 'Done'),
                  ChecklistTile(label: 'Post check-out · window closes in 21h', done: false, warn: true, trailing: 'Start'),
                ])),
                const SizedBox(height: 12),
                const WideButton(label: 'Report damage · photos + receipt', color: Color(0xFFB22222), outline: true, height: 44),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final pts = [0.5, 0.4, 0.55, 0.35, 0.6, 0.25, 0.1];
    final path = Path();
    for (var i = 0; i < pts.length; i++) {
      final x = size.width * i / (pts.length - 1);
      final y = size.height * pts[i];
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    final fill = Path.from(path)..lineTo(size.width, size.height)..lineTo(0, size.height)..close();
    canvas.drawPath(fill, Paint()..shader = const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0x55C9A84C), Color(0x00C9A84C)]).createShader(Offset.zero & size));
    canvas.drawPath(path, Paint()..color = AppColors.gold..style = PaintingStyle.stroke..strokeWidth = 2.5..strokeJoin = StrokeJoin.round..strokeCap = StrokeCap.round);
    final last = Offset(size.width, size.height * pts.last);
    canvas.drawCircle(last, 4, Paint()..color = AppColors.navy);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
