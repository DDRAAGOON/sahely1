import 'dart:async';
import 'package:flutter/material.dart';
import '../../../data/models.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/common.dart';
import '../../../core/widgets/cream_background.dart';
import '../../../core/widgets/kit.dart';
import '../../../core/widgets/ui.dart';
import '../widgets/property_widgets.dart';

class PropertyDetailScreen extends StatefulWidget {
  const PropertyDetailScreen({super.key});

  @override
  State<PropertyDetailScreen> createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final property = ModalRoute.of(context)?.settings.arguments as Property?;
    if (property == null) return const Scaffold(body: Center(child: Text('Property not found')));

    final images = [
      property.image,
      'https://images.unsplash.com/photo-1707075108813-edefd7b3308d?w=1200&q=72&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1776619316276-b1b461af9f15?w=1200&q=72&auto=format&fit=crop',
    ];

    final fullDescription =
        'A stunning ${property.type.toLowerCase()} located in the heart of ${property.area}. This property offers a perfect blend of luxury and comfort, featuring spacious rooms, modern amenities, and breathtaking views. Whether you\'re looking for a peaceful retreat or a place to entertain friends and family, this ${property.type.toLowerCase()} has everything you need for an unforgettable stay. Experience the best of the North Coast with direct access to premium facilities and services.';

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: CreamBackground(
        child: Column(
          children: [
            // Hero Carousel
            Stack(
              children: [
                SizedBox(
                  height: 280,
                  width: double.infinity,
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) => setState(() => _currentPage = index),
                    itemCount: images.length,
                    itemBuilder: (context, index) => SahelyImage(
                      imageUrl: images[index],
                      allImages: images,
                      fadeHeight: 140,
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PropertyCircleBtn(icon: Icons.chevron_left, onTap: () => Navigator.maybePop(context)),
                          SaveHeart(property: property, size: 38),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 14,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(images.length, (index) {
                        return Container(
                          width: index == _currentPage ? 18 : 6,
                          height: 6,
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          decoration: BoxDecoration(
                            color: index == _currentPage ? Colors.white : Colors.white54,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                children: [
                  Text(property.name, style: AppTheme.dm(size: 22, weight: FontWeight.w700, color: AppColors.navy)),
                  const SizedBox(height: 6),
                  Row(children: [
                    const Icon(Icons.location_on_outlined, size: 14, color: AppColors.muted),
                    const SizedBox(width: 5),
                    Text('${property.area}, North Coast', style: AppTheme.dm(size: 14, color: AppColors.muted)),
                  ]),
                  const SizedBox(height: 8),
                  RatingRow(rating: property.rating, reviews: property.reviews, size: 14),
                  const SizedBox(height: 8),
                  Row(children: [
                    const PropertyMetaChip(icon: Icons.meeting_room_outlined, label: 'Unit B-214'),
                    const SizedBox(width: 8),
                    PropertyMetaChip(icon: Icons.home_outlined, label: 'Floor ${property.beds > 2 ? "2 of 2" : "1 of 1"}'),
                  ]),
                  const SizedBox(height: 14),
                  Wrap(spacing: 8, runSpacing: 8, children: [
                    Pill(property.type, border: AppColors.navy),
                    const Pill('320 m²', border: AppColors.navy),
                    Pill(property.beds > 2 ? '2 Floors' : '1 Floor', border: AppColors.navy),
                    const Pill('Beachfront', border: AppColors.navy),
                    Pill('${property.guests} Guests', border: AppColors.navy),
                    Pill('${property.beds} Beds', border: AppColors.navy),
                    const Pill('Pool', border: AppColors.navy),
                    const Pill('Mixed groups OK', bg: Color(0xFFD7EEDD), fg: AppColors.success),
                  ]),
                  const SizedBox(height: 14),
                  GestureDetector(
                    onTap: () => setState(() => _isExpanded = !_isExpanded),
                    child: RichText(
                      text: TextSpan(
                        style: AppTheme.dm(size: 14, color: AppColors.ink, height: 1.55),
                        children: [
                          TextSpan(
                            text: _isExpanded ? fullDescription : '${fullDescription.substring(0, 100)}... ',
                          ),
                          TextSpan(
                              text: _isExpanded ? ' Show Less' : 'Show More',
                              style: AppTheme.dm(size: 14, weight: FontWeight.w600, color: AppColors.gold)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                      decoration: BoxDecoration(color: AppColors.gold, borderRadius: BorderRadius.circular(8)),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        const Icon(Icons.lock_outline, size: 14, color: AppColors.navy),
                        const SizedBox(width: 6),
                        Text('Smart Lock Enabled',
                            style: AppTheme.dm(size: 12, weight: FontWeight.w700, color: AppColors.navy)),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Row(children: [
                    Expanded(child: PropertyFeature(icon: Icons.pool_outlined, label: 'Private Pool')),
                    Expanded(child: PropertyFeature(icon: Icons.wifi, label: 'Fast WiFi')),
                  ]),
                  const SizedBox(height: 18),
                  Text('House Rules', style: AppTheme.dm(size: 15, weight: FontWeight.w700, color: AppColors.navy)),
                  const SizedBox(height: 8),
                  WhiteCard(
                    child: Column(children: [
                      _ruleRow('Calm hours', Icons.schedule, valueText: '11 PM – 8 AM'),
                      const Divider(height: 1, color: Color(0xFFF4EFE7)),
                      _ruleRow('Parties', Icons.celebration_outlined, allowed: true),
                      const Divider(height: 1, color: Color(0xFFF4EFE7)),
                      _ruleRow('Pets', Icons.pets, allowed: property.petsOk, petPaw: property.petsOk),
                      const Divider(height: 1, color: Color(0xFFF4EFE7)),
                      _ruleRow('Mixed groups', Icons.groups_outlined, allowed: true),
                    ]),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 70,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFFCFE0E8), Color(0xFFA7C2CF)]),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(child: Icon(Icons.location_on, color: Color(0xFFB22222), size: 22)),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        Text('Reviews', style: AppTheme.dm(size: 18, weight: FontWeight.w600, color: AppColors.navy)),
                        const SizedBox(width: 8),
                        const Icon(Icons.star, size: 14, color: AppColors.gold),
                        const SizedBox(width: 4),
                        Text('${property.rating} · ${property.reviews}', style: AppTheme.dm(size: 13, color: AppColors.muted)),
                      ]),
                      GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/property-reviews', arguments: property),
                          child: Text('See All', style: AppTheme.dm(size: 13, weight: FontWeight.w600, color: AppColors.gold))),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _review('Nour A.', 'Renter', BadgeKind.renterLight, 5, 'Jun 2026',
                      'Absolutely stunning. The pool and sea views were unreal, and check-in via the smart lock was seamless.',
                      const [Color(0xFF7FA8BF), Color(0xFF2C5066)]),
                  const SizedBox(height: 10),
                  _review('Omar K.', 'Renter', BadgeKind.renterLight, 5, 'May 2026',
                      'Spotless, exactly as pictured. Host was responsive and the location is unbeatable. Will book again.',
                      const [Color(0xFFD8B98A), Color(0xFF7D5A2C)]),
                  const SizedBox(height: 10),
                  _review('Sara M.', 'Broker', BadgeKind.gold, 4, 'May 2026',
                      'Great property for clients. Beautiful finish; only note is the beach can get busy on weekends.',
                      const [Color(0xFFC9A84C), Color(0xFF8A7330)]),
                  const SizedBox(height: 14),
                  WideButton(
                    label: 'See All ${property.reviews} Reviews',
                    color: AppColors.navy,
                    outline: true,
                    height: 46,
                    onTap: () => Navigator.pushNamed(context, '/property-reviews', arguments: property),
                  ),
                ],
              ),
            ),
            // Sticky book bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                            'EGP ${property.price.toString().replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (Match m) => "${m[1]},")}',
                            style: AppTheme.dm(size: 17, weight: FontWeight.w700, color: AppColors.navy)),
                        Text('/ night', style: AppTheme.dm(size: 11, color: AppColors.muted)),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/booking', arguments: property),
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 34),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(12)),
                        child: Text('Book Now', style: AppTheme.dm(size: 15, weight: FontWeight.w700, color: AppColors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ruleRow(String label, IconData icon, {String? valueText, bool allowed = false, bool petPaw = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 11),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            Icon(icon, size: 16, color: AppColors.navy),
            const SizedBox(width: 8),
            Text(label, style: AppTheme.dm(size: 13)),
          ]),
          if (valueText != null)
            Text(valueText, style: AppTheme.dm(size: 13, weight: FontWeight.w700, color: AppColors.navy))
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration:
                  BoxDecoration(color: allowed ? const Color(0xFFD7EEDD) : const Color(0xFFFDECEC), borderRadius: BorderRadius.circular(8)),
              child: Text(allowed ? (petPaw ? '🐾 Allowed' : 'Allowed') : 'Not allowed',
                  style: AppTheme.dm(size: 12, weight: FontWeight.w700, color: allowed ? AppColors.success : const Color(0xFFB22222))),
            ),
        ],
      ),
    );
  }

  Widget _review(String name, String role, BadgeKind kind, int stars, String date, String body, List<Color> avatar) {
    return WhiteCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            AvatarCircle(size: 38, colors: avatar),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Text(name, style: AppTheme.dm(size: 14, weight: FontWeight.w700, color: AppColors.navy)),
                    const SizedBox(width: 7),
                    StatusBadge(role, kind: kind),
                  ]),
                  const SizedBox(height: 3),
                  Row(children: [
                    for (var i = 0; i < 5; i++) Icon(Icons.star, size: 12, color: i < stars ? AppColors.gold : AppColors.border),
                    const SizedBox(width: 4),
                    Text(date, style: AppTheme.dm(size: 11, color: AppColors.faint)),
                  ]),
                ],
              ),
            ),
          ]),
          const SizedBox(height: 10),
          Text(body, style: AppTheme.dm(size: 13, color: AppColors.ink, height: 1.5)),
        ],
      ),
    );
  }
}
