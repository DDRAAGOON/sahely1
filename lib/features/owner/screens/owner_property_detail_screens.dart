import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sahely/core/navigation/app_navigation.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/common.dart';
import 'package:sahely/core/widgets/kit.dart';
import 'package:sahely/core/widgets/ui.dart';
import 'package:sahely/data/sample_data.dart';

import '../../../core/utils/currency_formatter.dart';

class OwnerPropertyInsightsScreen extends StatelessWidget {
  final Property? property;

  const OwnerPropertyInsightsScreen({super.key, this.property});

  @override
  Widget build(BuildContext context) {
    final prop = property ?? Sample.azure;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // 1. Hero Header
          Stack(
            children: [
              SizedBox(
                height: 220,
                width: double.infinity,
                child: SahelyImage(
                  imageUrl: prop.image,
                  enableViewer: true,
                  fadeColor: AppColors.navy.withValues(alpha: 0.6),
                  fadeHeight: 80,
                ),
              ),
              // Back Button
              Positioned(
                top: 44,
                left: 16,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.chevron_left, color: AppColors.navy),
                  ),
                ),
              ),
              // SOS Button
              Positioned(
                top: 44,
                right: 16,
                child: GestureDetector(
                  onTap: () => AppNavigation.goToSosOwner(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFB22222),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.warning_amber_rounded,
                            color: Colors.white, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          'SOS',
                          style: AppTheme.dm(
                            size: 13,
                            weight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Name & Status overlay
              Positioned(
                left: 18,
                bottom: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      prop.name,
                      style: AppTheme.dm(
                        size: 24,
                        weight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${prop.area} · Active',
                      style: AppTheme.dm(
                        size: 13,
                        weight: FontWeight.w500,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 2. Top Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: WideButton(
                        label: 'Edit property',
                        icon: Icons.edit_outlined,
                        color: AppColors.navy,
                        height: 48,
                        radius: 12,
                        onTap: () => AppNavigation.goToOwnerEdit(context),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: WideButton(
                        label: 'Preview listing',
                        color: AppColors.navy,
                        outline: true,
                        height: 48,
                        radius: 12,
                        onTap: () => AppNavigation.goToOwnerPreview(context),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 3. Requests Card
                GestureDetector(
                  onTap: () => AppNavigation.goToOwnerRequests(context),
                  child: WhiteCard(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFDF5E8),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.notes, color: Color(0xFFD2760A)),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Requests for this property',
                                style: AppTheme.dm(
                                  size: 15,
                                  weight: FontWeight.w700,
                                  color: AppColors.navy,
                                ),
                              ),
                              Text(
                                '1 pending · tap to review',
                                style: AppTheme.dm(
                                  size: 12,
                                  color: AppColors.muted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right,
                            color: AppColors.border, size: 20),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // 4. Stats Grid (3x2)
                _buildStatsGrid(),
                const SizedBox(height: 24),

                // 5. Views Chart
                Text(
                  'Views · last 7 days',
                  style: AppTheme.dm(
                    size: 16,
                    weight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 12),
                WhiteCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('1,284',
                                  style: AppTheme.dm(
                                      size: 20, weight: FontWeight.w800)),
                              Text('▲ 18% vs last week',
                                  style: AppTheme.dm(
                                      size: 12,
                                      weight: FontWeight.w600,
                                      color: AppColors.success)),
                            ],
                          ),
                          Text('Peak Sat',
                              style:
                                  AppTheme.dm(size: 12, color: AppColors.muted)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 100,
                        child: CustomPaint(
                          size: const Size(double.infinity, 100),
                          painter: _SparklinePainter(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          for (final d in ['M', 'T', 'W', 'T', 'F', 'S', 'S'])
                            Text(d,
                                style: AppTheme.dm(
                                    size: 10, color: AppColors.border)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // 6. Smart Lock
                Text(
                  'Smart Lock',
                  style: AppTheme.dm(
                    size: 16,
                    weight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.navy,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: AppColors.gold.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.lock_outline,
                            color: AppColors.gold, size: 22),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Door · Locked',
                              style: AppTheme.dm(
                                size: 14,
                                weight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Passcode active for current guest',
                              style: AppTheme.dm(
                                size: 11,
                                color: Colors.white.withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E7D32).withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: const Color(0xFF4CAF50), width: 0.5),
                        ),
                        child: Row(
                          children: [
                            const CircleAvatar(radius: 3, backgroundColor: Color(0xFF4CAF50)),
                            const SizedBox(width: 6),
                            Text('Online',
                                style: AppTheme.dm(
                                    size: 10,
                                    weight: FontWeight.w700,
                                    color: const Color(0xFF4CAF50))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Recent Access Log
                Text(
                  'RECENT ACCESS',
                  style: AppTheme.dm(
                    size: 11,
                    weight: FontWeight.w800,
                    color: AppColors.muted,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 10),
                WhiteCard(
                  child: Column(
                    children: [
                      _accessItem(Icons.login_rounded, const Color(0xFF2E7D32),
                          'Guest entry', 'Nour A.', 'Today 3:12 PM'),
                      const Divider(height: 1, indent: 44, endIndent: 16, color: AppColors.border),
                      _accessItem(Icons.logout_rounded, AppColors.muted,
                          'Guest exit', 'Nour A.', 'Today 9:40 AM'),
                      const Divider(height: 1, indent: 44, endIndent: 16, color: AppColors.border),
                      _accessItem(Icons.edit_outlined, const Color(0xFFD2760A),
                          'Passcode set', 'by you', 'Jun 14'),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                WideButton(
                  label: 'Manage smart lock',
                  color: AppColors.navy,
                  outline: true,
                  height: 48,
                  radius: 12,
                  onTap: () => AppNavigation.goToOwnerSmartLock(context),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'Passcode locked during an active stay · change after checkout',
                    style: AppTheme.dm(size: 10, color: AppColors.muted),
                  ),
                ),
                const SizedBox(height: 28),

                // 7. Recent Reviews
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Reviews',
                      style: AppTheme.dm(
                        size: 16,
                        weight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => AppNavigation.goToMyReviews(context),
                      child: Text(
                        'See All',
                        style: AppTheme.dm(
                          size: 13,
                          weight: FontWeight.w700,
                          color: AppColors.gold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _reviewItem(
                    'Nour A.',
                    'Stunning villa, the pool was the highlight. Will return!',
                    5.0,
                    const Color(0xFF457B9D)),
                const SizedBox(height: 12),
                _reviewItem(
                    'Omar K.',
                    'Exactly as pictured and spotless. Smooth check-in.',
                    5.0,
                    const Color(0xFFB39264)),
                const SizedBox(height: 28),

                // 8. Availability
                Text(
                  'Availability',
                  style: AppTheme.dm(
                    size: 16,
                    weight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 12),
                const AvailabilityCalendar(
                  blocked: [4, 5, 6],
                  ongoing: [14, 15, 16, 17, 18],
                  upcoming: [21, 22, 23, 24, 25],
                  ownerOff: [28, 29],
                  legend: ['Ongoing', 'Upcoming', 'Owner days-off', 'Blocked'],
                ),
                const SizedBox(height: 16),
                // Owner days-off card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDF9F4),
                    border: Border.all(color: const Color(0xFFEAD9A8), width: 1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Owner days-off',
                              style: AppTheme.dm(
                                size: 14,
                                weight: FontWeight.w700,
                                color: const Color(0xFF9A7A22),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '2 personal days/month — block them for yourself or keep renting. 2 left this month.',
                              style: AppTheme.dm(
                                size: 11,
                                weight: FontWeight.w500,
                                color: const Color(0xFF8A6D1E),
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFC9A84C),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Block days',
                            style: AppTheme.dm(
                              size: 12,
                              weight: FontWeight.w700,
                              color: AppColors.navy,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // 9. Inspection Checklist
                Text(
                  'Inspection Checklist',
                  style: AppTheme.dm(
                    size: 16,
                    weight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 12),
                WhiteCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _checklistRow(
                        icon: Icons.check_circle_rounded,
                        iconColor: const Color(0xFF2E7D32),
                        title: 'Pre check-in',
                        sub: 'Clean & verify before guest',
                        actionLabel: 'Done',
                        isActionCompleted: true,
                      ),
                      const Divider(height: 32, color: AppColors.border),
                      _checklistRow(
                        icon: Icons.watch_later_rounded,
                        iconColor: const Color(0xFFD2760A),
                        title: 'Post check-out',
                        sub: 'Window closes in 21h',
                        actionLabel: 'Start',
                        isActionCompleted: false,
                        onActionTap: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Pre check-in opens up to 2 days & at least 4h before arrival. Post check-out must be done within 24h of departure.',
                  style: AppTheme.dm(size: 11, color: AppColors.muted, height: 1.4),
                ),
                const SizedBox(height: 16),
                WideButton(
                  label: 'Report damage · photos + receipt',
                  icon: Icons.warning_amber_rounded,
                  color: const Color(0xFFB22222),
                  outline: true,
                  height: 48,
                  radius: 12,
                  onTap: () => AppNavigation.goToOwnerViolationReport(context),
                ),
                const SizedBox(height: 28),

                // 10. Upcoming Bookings
                Text(
                  'Upcoming Bookings',
                  style: AppTheme.dm(
                    size: 16,
                    weight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 12),
                _upcomingBookingItem(
                    'Omar K.', 'Jun 21–25', '4 guests', CurrencyFormatter.format(18000), const Color(0xFF457B9D)),
                const SizedBox(height: 120),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _statCard('1,284', 'Views', trend: '▲ 18% this wk')),
            const SizedBox(width: 12),
            Expanded(child: _statCard('96', 'Saved', trend: 'in wishlists')),
            const SizedBox(width: 12),
            Expanded(child: _statCard('12', 'Bookings', trend: 'this season', trendColor: const Color(0xFF2E7D32))),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _statCard('88%', 'Occupancy')),
            const SizedBox(width: 12),
            Expanded(child: _statCard('★ 4.8', 'Rating', trend: '124 reviews')),
            const SizedBox(width: 12),
            Expanded(child: _statCard('68.4k', 'Revenue', trend: '${CurrencyFormatter.defaultSymbol} / mo')),
          ],
        ),
      ],
    );
  }

  Widget _statCard(String v, String l, {String? trend, Color? trendColor}) =>
      WhiteCard(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(v,
                style: AppTheme.dm(
                    size: 18, weight: FontWeight.w800, color: AppColors.navy)),
            const SizedBox(height: 2),
            Text(l, style: AppTheme.dm(size: 10, color: AppColors.muted)),
            if (trend != null) ...[
              const SizedBox(height: 4),
              Text(
                trend,
                style: AppTheme.dm(
                  size: 9,
                  weight: FontWeight.w700,
                  color: trendColor ?? AppColors.success,
                ),
              ),
            ],
          ],
        ),
      );

  Widget _accessItem(IconData icon, Color color, String type, String user, String time) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 12),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: AppTheme.dm(size: 13, color: AppColors.navy, weight: FontWeight.w700),
                  children: [
                    TextSpan(text: '$type · '),
                    TextSpan(text: user, style: AppTheme.dm(weight: FontWeight.w500, color: AppColors.muted)),
                  ],
                ),
              ),
            ),
            Text(time, style: AppTheme.dm(size: 11, color: AppColors.faint)),
          ],
        ),
      );

  Widget _reviewItem(String name, String text, double rating, Color avatarColor) =>
      WhiteCard(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(radius: 14, backgroundColor: avatarColor),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(name,
                      style: AppTheme.dm(size: 13, weight: FontWeight.w700)),
                ),
                Row(
                  children: List.generate(
                      5,
                      (i) => Icon(Icons.star,
                          size: 12,
                          color: i < rating ? AppColors.gold : AppColors.border)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              text,
              style: AppTheme.dm(size: 12, color: AppColors.ink, height: 1.4),
            ),
          ],
        ),
      );

  Widget _checklistRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String sub,
    required String actionLabel,
    required bool isActionCompleted,
    VoidCallback? onActionTap,
  }) =>
      Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: AppTheme.dm(size: 14, weight: FontWeight.w700)),
                Text(sub, style: AppTheme.dm(size: 11, color: (title == 'Post check-out') ? const Color(0xFFD2760A) : AppColors.muted, weight: (title == 'Post check-out') ? FontWeight.w700 : FontWeight.w500)),
              ],
            ),
          ),
          if (isActionCompleted)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFD7EEDD),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                actionLabel,
                style: AppTheme.dm(
                  size: 11,
                  weight: FontWeight.w800,
                  color: const Color(0xFF2E7D32),
                ),
              ),
            )
          else
            GestureDetector(
              onTap: onActionTap,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.navy,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  actionLabel,
                  style: AppTheme.dm(
                    size: 12,
                    weight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      );

  Widget _upcomingBookingItem(String name, String date, String guests, String price, Color avatarColor) =>
      WhiteCard(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(radius: 20, backgroundColor: avatarColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: AppTheme.dm(size: 14, weight: FontWeight.w700, color: AppColors.navy),
                      children: [
                        TextSpan(text: '$name · '),
                        TextSpan(text: date, style: AppTheme.dm(weight: FontWeight.w500, color: AppColors.muted)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text('$guests · $price', style: AppTheme.dm(size: 12, color: AppColors.muted)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.navy,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Upcoming',
                style: AppTheme.dm(
                  size: 10,
                  weight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
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
    final fill = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(
        fill,
        Paint()
          ..shader = const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x55C9A84C), Color(0x00C9A84C)])
              .createShader(Offset.zero & size));
    canvas.drawPath(
        path,
        Paint()
          ..color = AppColors.gold
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..strokeJoin = StrokeJoin.round
          ..strokeCap = StrokeCap.round);
    final last = Offset(size.width, size.height * pts.last);
    canvas.drawCircle(last, 4, Paint()..color = AppColors.navy);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class OwnerEditPropertyScreen extends StatefulWidget {
  const OwnerEditPropertyScreen({super.key});

  @override
  State<OwnerEditPropertyScreen> createState() =>
      _OwnerEditPropertyScreenState();
}

class _OwnerEditPropertyScreenState extends State<OwnerEditPropertyScreen> {
  int _price = 4500;
  final TextEditingController _priceController =
      TextEditingController(text: '4500');
  final TextEditingController _descController = TextEditingController(
      text:
          'A stunning beachfront villa with private pool, panoramic sea views and direct beach access. Sleeps 6 across 4 bedrooms.');
  final List<String> _photos = [
    Sample.azure.image,
    Sample.lagoon.image,
    Sample.dunes.image
  ];
  final List<String> _amenities = ['Pool', 'Wi-Fi', 'AC', 'Smart Lock'];
  final ImagePicker _picker = ImagePicker();

  void _updatePrice(int delta) {
    setState(() {
      _price = (_price + delta).clamp(0, 100000);
      _priceController.text = _price.toString();
    });
  }

  Future<void> _addPhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _photos.add(image.path);
      });
    }
  }

  void _addAmenity() {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Add Amenity',
            style: AppTheme.dm(
                size: 18, weight: FontWeight.w700, color: AppColors.navy)),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'e.g. Sea View, Parking',
            border: UnderlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel',
                style: AppTheme.dm(size: 14, color: AppColors.muted)),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() {
                  _amenities.add(controller.text.trim());
                });
              }
              Navigator.pop(ctx);
            },
            child: Text('Add',
                style: AppTheme.dm(
                    size: 14, weight: FontWeight.w700, color: AppColors.gold)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _priceController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return PhoneScaffold(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
              children: [
                // 1. Header
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => AppNavigation.goBack(context),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.borderDefault),
                        ),
                        child: const Icon(Icons.chevron_left,
                            size: 24, color: AppColors.navy),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Edit Property',
                              style: AppTheme.dm(
                                  size: 22,
                                  weight: FontWeight.w700,
                                  color: AppColors.navy)),
                          Text('Azure Beach Villa · Hacienda Bay',
                              style: AppTheme.dm(
                                  size: 13, color: AppColors.muted)),
                        ],
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        Sample.azure.image,
                        width: 52,
                        height: 52,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // 2. Nightly Price Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('NIGHTLY PRICE',
                        style: AppTheme.dm(
                            size: 13,
                            weight: FontWeight.w800,
                            color: AppColors.navy,
                            letterSpacing: 0.5)),
                    const StatusBadge('Instant', kind: BadgeKind.greenSoft),
                  ],
                ),
                const SizedBox(height: 10),
                WhiteCard(
                  padding: const EdgeInsets.all(20),
                  radius: 20,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Minus Button
                          GestureDetector(
                            onTap: () => _updatePrice(-100),
                            child: Container(
                              width: 54,
                              height: 54,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.borderDefault),
                              ),
                              child: const Icon(Icons.remove,
                                  color: AppColors.navy, size: 24),
                            ),
                          ),
                          // Price Display
                          Column(
                            children: [
                              Text('${CurrencyFormatter.defaultSymbol} / night',
                                  style: AppTheme.dm(
                                      size: 12,
                                      weight: FontWeight.w500,
                                      color: AppColors.muted)),
                              const SizedBox(height: 2),
                              Text(CurrencyFormatter.formatNumber(_price),
                                  style: AppTheme.dm(
                                      size: 38,
                                      weight: FontWeight.w800,
                                      color: AppColors.navy,
                                      letterSpacing: -1)),
                            ],
                          ),
                          // Plus Button
                          GestureDetector(
                            onTap: () => _updatePrice(100),
                            child: Container(
                              width: 54,
                              height: 54,
                              decoration: const BoxDecoration(
                                color: AppColors.navy,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.add,
                                  color: Colors.white, size: 24),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD7EEDD),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Applies immediately to new bookings · current ${CurrencyFormatter.format(_price)}',
                          textAlign: TextAlign.center,
                          style: AppTheme.dm(
                            size: 11,
                            weight: FontWeight.w700,
                            color: const Color(0xFF1B6B3A),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 3. Photos Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('PHOTOS',
                        style: AppTheme.dm(
                            size: 13,
                            weight: FontWeight.w800,
                            color: AppColors.navy,
                            letterSpacing: 0.5)),
                    const StatusBadge('Add only', kind: BadgeKind.gold),
                  ],
                ),
                const SizedBox(height: 10),
                WhiteCard(
                  padding: const EdgeInsets.all(16),
                  radius: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          for (int i = 0; i < _photos.length; i++)
                            _photoTile(_photos[i], cover: i == 0),
                          GestureDetector(
                            onTap: _addPhoto,
                            child: DottedBorder(
                              color: AppColors.gold,
                              radius: 12,
                              child: Container(
                                width: 85,
                                height: 85,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.add,
                                        color: AppColors.gold, size: 24),
                                    const SizedBox(height: 4),
                                    Text('Add photo',
                                        style: AppTheme.dm(
                                            size: 10,
                                            weight: FontWeight.w700,
                                            color: AppColors.gold)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDF5E8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.lock_outline,
                                size: 16, color: Color(0xFFD2760A)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: AppTheme.dm(
                                      size: 11,
                                      color: const Color(0xFF8A6D1E),
                                      height: 1.4),
                                  children: [
                                    const TextSpan(
                                        text:
                                            "Existing photos can't be deleted here. "),
                                    TextSpan(
                                      text: "Request removal from support →",
                                      style: AppTheme.dm(
                                          weight: FontWeight.w700,
                                          size: 11,
                                          color: const Color(0xFF8A6D1E))
                                      .copyWith(
                                          decoration: TextDecoration.underline),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 4. Description Section
                Text('DESCRIPTION',
                    style: AppTheme.dm(
                        size: 13,
                        weight: FontWeight.w800,
                        color: AppColors.navy,
                        letterSpacing: 0.5)),
                const SizedBox(height: 10),
                WhiteCard(
                  padding: const EdgeInsets.all(16),
                  radius: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDECEC),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline,
                                size: 16, color: Color(0xFFB22222)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Note: no phone numbers or social media accounts allowed.',
                                style: AppTheme.dm(
                                    size: 11,
                                    weight: FontWeight.w700,
                                    color: const Color(0xFFB22222)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _descController,
                        maxLines : null,
                        style: AppTheme.dm(
                            size: 14, color: AppColors.navy, height: 1.5),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text('${_descController.text.length} / 400',
                            style: AppTheme.dm(
                                size: 11, color: AppColors.muted)),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 5. Features & Amenities Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('FEATURES & AMENITIES',
                        style: AppTheme.dm(
                            size: 13,
                            weight: FontWeight.w800,
                            color: AppColors.navy,
                            letterSpacing: 0.5)),
                    const StatusBadge('Reviewed · 24h', kind: BadgeKind.gold),
                  ],
                ),
                const SizedBox(height: 10),
                WhiteCard(
                  padding: const EdgeInsets.all(16),
                  radius: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Edits to the guest checklist are reviewed by Sahely before going live (~24h).',
                        style: AppTheme.dm(
                            size: 12, color: AppColors.muted, height: 1.4),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final amenity in _amenities)
                            _amenityChip(amenity),
                          GestureDetector(
                            onTap: _addAmenity,
                            child: DottedBorder(
                              color: AppColors.gold,
                              radius: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 8),
                                child: Text('+ Add',
                                    style: AppTheme.dm(
                                        size: 13,
                                        weight: FontWeight.w700,
                                        color: AppColors.gold)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 6. Bottom Buttons
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            decoration: const BoxDecoration(
              color: AppColors.cream,
              border:
                  Border(top: BorderSide(color: AppColors.border, width: 0.5)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 54,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border : null,
                      ),
                      child: Text('Discard',
                          style: AppTheme.dm(
                              size: 16,
                              weight: FontWeight.w700,
                              color: AppColors.navy)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: NavyButton(
                    label: 'Save changes',
                    height: 54,
                    radius: 16,
                    onTap: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _photoTile(String img, {bool cover = false}) => ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 85,
          height: 85,
          decoration: const BoxDecoration(color: AppColors.cardWarm),
          child: Stack(
            fit: StackFit.expand,
            children: [
              img.startsWith('http')
                  ? Image.network(img, fit: BoxFit.cover)
                  : Image.file(File(img), fit: BoxFit.cover),
              if (cover)
                Positioned(
                  top: 6,
                  left: 6,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                        color: AppColors.gold,
                        borderRadius: BorderRadius.circular(6)),
                    child: Text('Cover',
                        style: AppTheme.dm(
                            size: 8,
                            weight: FontWeight.w800,
                            color: AppColors.navy)),
                  ),
                ),
              Positioned(
                bottom: 6,
                right: 6,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.lock, size: 12, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _amenityChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label,
              style: AppTheme.dm(
                  size: 13, weight: FontWeight.w700, color: Colors.white)),
          const SizedBox(width: 4),
          const Icon(Icons.check, size: 14, color: Colors.white),
        ],
      ),
    );
  }
}

class OwnerPreviewListingScreen extends StatelessWidget {
  const OwnerPreviewListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PhoneScaffold(
      child: Column(children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            children: [
              const TopBar(
                  title: 'Listing status',
                  subtitle: 'How guests see Azure Beach Villa'),
              const SizedBox(height: 16),
              WhiteCard(
                padding: EdgeInsets.zero,
                radius: 16,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            height: 170,
                            width: double.infinity,
                            child: Stack(fit: StackFit.expand, children: [
                              Image.network(Sample.azure.image,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      const ColoredBox(
                                          color: AppColors.cardWarm)),
                              const Positioned(
                                  top: 10,
                                  left: 10,
                                  child: StatusBadge('Live · Bookable',
                                      kind: BadgeKind.green, dot: true)),
                              const Positioned(
                                  top: 10,
                                  right: 10,
                                  child: SaveHeart(property: Sample.azure)),
                            ])),
                        Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Azure Beach Villa',
                                      style: AppTheme.dm(
                                          size: 16,
                                          weight: FontWeight.w700,
                                          color: AppColors.navy)),
                                  Text('Hacienda Bay · North Coast',
                                      style: AppTheme.dm(
                                          size: 12, color: AppColors.muted)),
                                  const SizedBox(height: 8),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                              '★ 4.8 · 124 reviews · 88% occupancy',
                                              style: AppTheme.dm(
                                                  size: 12,
                                                  color: AppColors.muted),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                        const SizedBox(width: 8),
                                        const PriceTag(price: 4500, size: 15),
                                      ]),
                                  const SizedBox(height: 10),
                                  const Wrap(
                                      spacing: 7,
                                      runSpacing: 7,
                                      children: [
                                        Pill('Villa', border: AppColors.navy),
                                        Pill('6 Guests',
                                            border: AppColors.navy),
                                        Pill('Pool', border: AppColors.navy),
                                        Pill('🐾 Pets',
                                            bg: Color(0xFFD7EEDD),
                                            fg: AppColors.success)
                                      ]),
                                ])),
                      ]),
                ),
              ),
              const SizedBox(height: 14),
              WhiteCard(
                padding: const EdgeInsets.all(14),
                child: Row(children: [
                  Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                          color: const Color(0xFFD7EEDD),
                          borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.check, color: AppColors.success)),
                  const SizedBox(width: 12),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text('Listed',
                            style: AppTheme.dm(
                                size: 14,
                                weight: FontWeight.w700,
                                color: AppColors.navy)),
                        Text('Visible & accepting bookings',
                            style:
                                AppTheme.dm(size: 11, color: AppColors.muted)),
                      ])),
                  Container(
                      width: 42,
                      height: 24,
                      decoration: BoxDecoration(
                          color: AppColors.success,
                          borderRadius: BorderRadius.circular(12)),
                      child: const Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                              padding: EdgeInsets.all(2),
                              child: CircleAvatar(
                                  radius: 10, backgroundColor: Colors.white)))),
                ]),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [AppColors.gold, Color(0xFFB3923C)]),
                    borderRadius: BorderRadius.circular(14)),
                child: Row(children: [
                  Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                          color: AppColors.navy,
                          borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.lock_outline,
                          color: AppColors.gold)),
                  const SizedBox(width: 12),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text('Protected listing period',
                            style: AppTheme.dm(
                                size: 14,
                                weight: FontWeight.w700,
                                color: AppColors.navy)),
                        Text(
                            'New listings stay live for their first month — unlisting unlocks Jul 14. Part of our T&Cs.',
                            style: AppTheme.dm(
                                size: 11,
                                color: const Color(0xFF3A3320),
                                height: 1.4)),
                      ])),
                ]),
              ),
            ],
          ),
        ),
        const Padding(
            padding: EdgeInsets.all(16),
            child: WideButton(
                label: 'Unlisting locked until Jul 14',
                icon: Icons.lock,
                color: Color(0xFFE7DFD2),
                textColor: AppColors.muted,
                height: 52)),
      ]),
    );
  }
}
