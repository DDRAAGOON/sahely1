import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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

class OwnerEditPropertyScreen extends StatefulWidget {
  const OwnerEditPropertyScreen({super.key});

  @override
  State<OwnerEditPropertyScreen> createState() => _OwnerEditPropertyScreenState();
}

class _OwnerEditPropertyScreenState extends State<OwnerEditPropertyScreen> {
  int _price = 4500;
  final TextEditingController _priceController = TextEditingController(text: '4500');
  bool _isEditingPrice = false;
  final List<String> _photos = [Sample.azure.image, Sample.lagoon.image, Sample.dunes.image];
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

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String format(num n) => n.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');

    return PhoneScaffold(
      child: Column(children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            children: [
              const TopBar(title: 'Edit Property', subtitle: 'Azure Beach Villa · Hacienda Bay'),
              const SizedBox(height: 16),
              const Row(children: [SectionLabel('NIGHTLY PRICE'), SizedBox(width: 8), StatusBadge('Instant', kind: BadgeKind.greenSoft)]),
              const SizedBox(height: 8),
              WhiteCard(
                padding: const EdgeInsets.all(14),
                child: Column(children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    GestureDetector(
                      onTap: () => _updatePrice(-100),
                      child: Container(width: 44, height: 44, alignment: Alignment.center, decoration: BoxDecoration(border: Border.all(color: AppColors.navy, width: 1.5), shape: BoxShape.circle), child: const Icon(Icons.remove, color: AppColors.navy)),
                    ),
                    Column(children: [
                      Text('EGP / night', style: AppTheme.dm(size: 11, color: AppColors.muted)),
                      if (_isEditingPrice)
                        SizedBox(
                          width: 120,
                          child: TextField(
                            controller: _priceController,
                            autofocus: true,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: AppTheme.dm(size: 30, weight: FontWeight.w700, color: AppColors.navy),
                            decoration: const InputDecoration(border: InputBorder.none, isDense: true),
                            onSubmitted: (v) {
                              setState(() {
                                _price = int.tryParse(v) ?? _price;
                                _isEditingPrice = false;
                              });
                            },
                          ),
                        )
                      else
                        GestureDetector(
                          onTap: () => setState(() => _isEditingPrice = true),
                          child: Text(format(_price), style: AppTheme.dm(size: 30, weight: FontWeight.w700, color: AppColors.navy)),
                        ),
                    ]),
                    GestureDetector(
                      onTap: () => _updatePrice(100),
                      child: Container(width: 44, height: 44, alignment: Alignment.center, decoration: const BoxDecoration(color: AppColors.navy, shape: BoxShape.circle), child: const Icon(Icons.add, color: Colors.white)),
                    ),
                  ]),
                  const SizedBox(height: 10),
                  Container(width: double.infinity, padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: const Color(0xFFD7EEDD), borderRadius: BorderRadius.circular(8)), child: Text('Applies immediately to new bookings · current EGP ${format(_price)}', textAlign: TextAlign.center, style: AppTheme.dm(size: 11, weight: FontWeight.w600, color: AppColors.success))),
                ]),
              ),
              const SizedBox(height: 16),
              const Row(children: [SectionLabel('PHOTOS'), SizedBox(width: 8), StatusBadge('Add only', kind: BadgeKind.gold)]),
              const SizedBox(height: 8),
              GridView.count(crossAxisCount: 3, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), mainAxisSpacing: 8, crossAxisSpacing: 8, children: [
                for (var i = 0; i < _photos.length; i++)
                  _photoTile(_photos[i], cover: i == 0),
                GestureDetector(
                  onTap: _addPhoto,
                  child: const DottedBorder(color: AppColors.gold, radius: 10, child: Center(child: Icon(Icons.add, color: AppColors.gold))),
                ),
              ]),
              const SizedBox(height: 8),
              Text("Existing photos can't be deleted here. Request removal from support →", style: AppTheme.dm(size: 11, color: AppColors.muted)),
              const SizedBox(height: 16),
              const SectionLabel('DESCRIPTION'),
              const SizedBox(height: 8),
              Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: const Color(0xFFFDECEC), borderRadius: BorderRadius.circular(8)), child: Text('Note: no phone numbers or social media accounts allowed.', style: AppTheme.dm(size: 11, weight: FontWeight.w600, color: const Color(0xFFB22222)))),
              const SizedBox(height: 8),
              Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.white, border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(10)), child: Text('A stunning beachfront villa with private pool, panoramic sea views and direct beach access. Sleeps 6 across 4 bedrooms.', style: AppTheme.dm(size: 13, height: 1.4))),
              const SizedBox(height: 16),
              const Row(children: [SectionLabel('FEATURES & AMENITIES'), SizedBox(width: 8), StatusBadge('Reviewed · 24h', kind: BadgeKind.gold)]),
              const SizedBox(height: 8),
              Text('Edits to the guest checklist are reviewed by Sahely before going live (~24h).', style: AppTheme.dm(size: 11, color: AppColors.muted)),
              const SizedBox(height: 8),
              const Wrap(spacing: 8, runSpacing: 8, children: [
                Pill('Pool ✓', bg: AppColors.navy, fg: AppColors.white),
                Pill('WiFi ✓', bg: AppColors.navy, fg: AppColors.white),
                Pill('AC ✓', bg: AppColors.navy, fg: AppColors.white),
                Pill('Smart Lock ✓', bg: AppColors.navy, fg: AppColors.white),
              ]),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Row(children: [
            Expanded(child: WideButton(label: 'Discard', color: AppColors.navy, outline: true, height: 52, radius: 14, onTap: () => Navigator.maybePop(context))),
            const SizedBox(width: 12),
            Expanded(child: NavyButton(label: 'Save changes', height: 52, radius: 14, onTap: () => Navigator.maybePop(context))),
          ]),
        ),
      ]),
    );
  }

  Widget _photoTile(String img, {bool cover = false}) => ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(fit: StackFit.expand, children: [
          img.startsWith('http') 
            ? Image.network(img, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const ColoredBox(color: AppColors.cardWarm))
            : Image.file(File(img), fit: BoxFit.cover),
          if (cover) Positioned(top: 6, left: 6, child: Container(padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3), decoration: BoxDecoration(color: AppColors.gold, borderRadius: BorderRadius.circular(6)), child: Text('Cover', style: AppTheme.dm(size: 9, weight: FontWeight.w700, color: AppColors.navy)))),
          const Positioned(bottom: 6, right: 6, child: Icon(Icons.lock, size: 14, color: Colors.white)),
        ]),
      );
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
              const TopBar(title: 'Listing status', subtitle: 'How guests see Azure Beach Villa'),
              const SizedBox(height: 16),
              WhiteCard(
                padding: EdgeInsets.zero,
                radius: 16,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    SizedBox(height: 170, width: double.infinity, child: Stack(fit: StackFit.expand, children: [
                      Image.network(Sample.azure.image, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const ColoredBox(color: AppColors.cardWarm)),
                      const Positioned(top: 10, left: 10, child: StatusBadge('Live · Bookable', kind: BadgeKind.green, dot: true)),
                      const Positioned(top: 10, right: 10, child: SaveHeart(property: Sample.azure)),
                    ])),
                    Padding(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Azure Beach Villa', style: AppTheme.dm(size: 16, weight: FontWeight.w700, color: AppColors.navy)),
                      Text('Hacienda Bay · North Coast', style: AppTheme.dm(size: 12, color: AppColors.muted)),
                      const SizedBox(height: 8),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('★ 4.8 · 124 reviews · 88% occupancy', style: AppTheme.dm(size: 12, color: AppColors.muted)),
                        const PriceTag(price: 4500, size: 15),
                      ]),
                      const SizedBox(height: 10),
                      const Wrap(spacing: 7, runSpacing: 7, children: [Pill('Villa', border: AppColors.navy), Pill('6 Guests', border: AppColors.navy), Pill('Pool', border: AppColors.navy), Pill('🐾 Pets', bg: Color(0xFFD7EEDD), fg: AppColors.success)]),
                    ])),
                  ]),
                ),
              ),
              const SizedBox(height: 14),
              WhiteCard(
                padding: const EdgeInsets.all(14),
                child: Row(children: [
                  Container(width: 36, height: 36, decoration: BoxDecoration(color: const Color(0xFFD7EEDD), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.check, color: AppColors.success)),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Listed', style: AppTheme.dm(size: 14, weight: FontWeight.w700, color: AppColors.navy)),
                    Text('Visible & accepting bookings', style: AppTheme.dm(size: 11, color: AppColors.muted)),
                  ])),
                  Container(width: 42, height: 24, decoration: BoxDecoration(color: AppColors.success, borderRadius: BorderRadius.circular(12)), child: const Align(alignment: Alignment.centerRight, child: Padding(padding: EdgeInsets.all(2), child: CircleAvatar(radius: 10, backgroundColor: Colors.white)))),
                ]),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(gradient: const LinearGradient(colors: [AppColors.gold, Color(0xFFB3923C)]), borderRadius: BorderRadius.circular(14)),
                child: Row(children: [
                  Container(width: 38, height: 38, decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.lock_outline, color: AppColors.gold)),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Protected listing period', style: AppTheme.dm(size: 14, weight: FontWeight.w700, color: AppColors.navy)),
                    Text('New listings stay live for their first month — unlisting unlocks Jul 14. Part of our T&Cs.', style: AppTheme.dm(size: 11, color: const Color(0xFF3A3320), height: 1.4)),
                  ])),
                ]),
              ),
            ],
          ),
        ),
        const Padding(padding: EdgeInsets.all(16), child: WideButton(label: 'Unlisting locked until Jul 14', icon: Icons.lock, color: Color(0xFFE7DFD2), textColor: AppColors.muted, height: 52)),
      ]),
    );
  }
}
