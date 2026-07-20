import 'package:flutter/material.dart';
import 'package:sahely/core/navigation/app_navigation.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/kit.dart';
import '../../../core/widgets/ui.dart';
import '../../../data/sample_data.dart';

class OwnerActiveDetailScreen extends StatefulWidget {
  final Property? property;

  const OwnerActiveDetailScreen({super.key, this.property});

  @override
  State<OwnerActiveDetailScreen> createState() =>
      _OwnerActiveDetailScreenState();
}

class _OwnerActiveDetailScreenState extends State<OwnerActiveDetailScreen> {
  final TextEditingController _aiController = TextEditingController();

  @override
  void dispose() {
    _aiController.dispose();
    super.dispose();
  }

  void _sendAiMessage() {
    if (_aiController.text.trim().isEmpty) return;
    final msg = _aiController.text;
    _aiController.clear();
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sahely AI: Processing "$msg"...'),
        backgroundColor: AppColors.navy,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final prop = widget.property ?? Sample.lagoon;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            ListView(
              padding: EdgeInsets.zero,
              children: [
                // 1. Hero Image
                SizedBox(
                  height: 280,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      SahelyImage(
                          imageUrl: prop.image,
                          enableViewer: true,
                          fadeHeight: 120,
                          fadeColor: AppColors.cream),
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Color(0x991B2744)],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 18,
                        bottom: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(prop.name,
                                style: AppTheme.dm(
                                    size: 26,
                                    weight: FontWeight.w700,
                                    color: Colors.white)),
                            const SizedBox(height: 4),
                            Row(children: [
                              const Icon(Icons.location_on_outlined,
                                  size: 14, color: Colors.white70),
                              const SizedBox(width: 4),
                              Text('Marassi · North Coast',
                                  style: AppTheme.dm(
                                      size: 13, color: Colors.white70)),
                            ]),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 2. Gallery Row
                      SizedBox(
                        height: 80,
                        child: Row(
                          children: [
                            _galleryThumb(Sample.azure.image),
                            const SizedBox(width: 10),
                            _galleryThumb(Sample.lagoon.image),
                            const SizedBox(width: 10),
                            _galleryThumb(Sample.dunes.image, overlay: '+18'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 3. Info Chips
                      Row(
                        children: [
                          _infoChip('Order SHLY-7741'),
                          const SizedBox(width: 8),
                          _infoChip('Jun 14–18'),
                          const SizedBox(width: 8),
                          _infoChip('2A · 1C'),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // 4. Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: WideButton(
                              label: 'Door Passcode',
                              icon: Icons.lock_outline,
                              color: const Color(0xFFD8B96A),
                              textColor: AppColors.navy,
                              height: 56,
                              radius: 12,
                              onTap: () =>
                                  AppNavigation.goToOwnerSmartLock(context),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: WideButton(
                              label: 'SOS',
                              icon: Icons.warning_amber_rounded,
                              color: const Color(0xFFB3261E),
                              height: 56,
                              radius: 12,
                              onTap: () => AppNavigation.goToSosOwner(context),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),

                      // 5. Property Details
                      Text('Property Details',
                          style: AppTheme.dm(
                              size: 19,
                              weight: FontWeight.w700,
                              color: AppColors.navy)),
                      const SizedBox(height: 14),
                      const WhiteCard(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                        child: Column(
                          children: [
                            Row(children: [
                              Expanded(child: _IconDetail(Icons.king_bed_outlined, '3 bdr · 5 beds')),
                              _VerticalDivider(),
                              Expanded(child: _IconDetail(Icons.bathtub_outlined, '2 bathrooms')),
                            ]),
                            SizedBox(height: 18),
                            Row(children: [
                              Expanded(child: _IconDetail(Icons.pool_outlined, 'Private pool')),
                              _VerticalDivider(),
                              Expanded(child: _IconDetail(Icons.wifi, 'Fast WiFi')),
                            ]),
                            SizedBox(height: 18),
                            Row(children: [
                              Expanded(child: _IconDetail(Icons.location_on_outlined, 'Lagoon Beach')),
                              _VerticalDivider(),
                              Expanded(child: _IconDetail(Icons.lock_outline, 'Smart lock')),
                            ]),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),

                      // 6. Location
                      Text('Location',
                          style: AppTheme.dm(
                              size: 19,
                              weight: FontWeight.w700,
                              color: AppColors.navy)),
                      const SizedBox(height: 14),
                      Container(
                        height: 160,
                        width: double.infinity,
                        decoration: BoxDecoration(color: const Color(0xFFC5D5E2), borderRadius: BorderRadius.circular(16)),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const Icon(Icons.location_on, color: Color(0xFFB3261E), size: 42),
                            Positioned(
                              bottom: 12,
                              left: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(color: AppColors.navy.withValues(alpha: 0.8), borderRadius: BorderRadius.circular(8)),
                                child: Text('Hacienda White, Marassi', style: AppTheme.dm(size: 12, weight: FontWeight.w600, color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),

                      // 7. Arrival Checklist
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Arrival Checklist', style: AppTheme.dm(size: 19, weight: FontWeight.w700, color: AppColors.navy)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(color: const Color(0xFFFDF9F4), border: Border.all(color: const Color(0xFFE7D9A8)), borderRadius: BorderRadius.circular(8)),
                            child: Text('4 / 6 done', style: AppTheme.dm(size: 12, weight: FontWeight.w700, color: const Color(0xFF9A7A22))),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text('Confirm everything the host listed is here.', style: AppTheme.dm(size: 14, color: AppColors.muted)),
                      const SizedBox(height: 14),
                      const WhiteCard(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        child: Column(
                          children: [
                            ChecklistTile(label: 'Pool clean & usable', done: true, trailing: 'OK', padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14)),
                            Divider(height: 1, color: Color(0xFFF4EFE7)),
                            ChecklistTile(label: 'WiFi works (password on fridge)', done: true, trailing: 'OK', padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14)),
                            Divider(height: 1, color: Color(0xFFF4EFE7)),
                            ChecklistTile(label: 'AC in all rooms', done: true, trailing: 'OK', padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14)),
                            Divider(height: 1, color: Color(0xFFF4EFE7)),
                            ChecklistTile(label: '5 beds made & linens fresh', done: true, trailing: 'OK', padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14)),
                            Divider(height: 1, color: Color(0xFFF4EFE7)),
                            ChecklistTile(label: 'Beach access tags (4)', done: false, trailing: 'Check', padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14)),
                            Divider(height: 1, color: Color(0xFFF4EFE7)),
                            ChecklistTile(label: 'Kitchen fully equipped', done: false, trailing: 'Check', padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      WideButton(
                        label: 'Report an issue to host',
                        color: AppColors.navy,
                        outline: true,
                        height: 52,
                        radius: 12,
                        onTap: () {},
                      ),
                      const SizedBox(height: 30),

                      // 8. Rate Stay
                      Text('Rate your stay', style: AppTheme.dm(size: 19, weight: FontWeight.w700, color: AppColors.navy)),
                      const SizedBox(height: 14),
                      const ReviewButton(),
                      const SizedBox(height: 30),

                      // 9. AI Section
                      Text('Ask Sahely AI', style: AppTheme.dm(size: 19, weight: FontWeight.w700, color: AppColors.navy)),
                      const SizedBox(height: 2),
                      Text('Questions about this stay — not live support.', style: AppTheme.dm(size: 14, color: AppColors.muted)),
                      const SizedBox(height: 16),
                      WhiteCard(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(color: const Color(0xFFD8B96A), borderRadius: BorderRadius.circular(8)),
                                  child: const Icon(Icons.auto_awesome, size: 20, color: AppColors.navy),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(color: const Color(0xFFF5F0E8), borderRadius: BorderRadius.circular(16)),
                                    child: Text(
                                      'Hi! I can help with WiFi, the pool heater, nearby restaurants or checkout steps. What do you need?',
                                      style: AppTheme.dm(size: 14, height: 1.5),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  _aiChip('How does the pool heater work?'),
                                  const SizedBox(width: 8),
                                  _aiChip('Checkout time?'),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              height: 48,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(color: const Color(0xFFF5F0E8), borderRadius: BorderRadius.circular(24)),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _aiController,
                                      onSubmitted: (_) => _sendAiMessage(),
                                      decoration: InputDecoration(
                                        hintText: 'Ask about your stay...',
                                        hintStyle: AppTheme.dm(size: 14, color: AppColors.navy.withValues(alpha: 0.5)),
                                        border: InputBorder.none,
                                        isDense: true,
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                      style: AppTheme.dm(size: 14, color: AppColors.navy),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: _sendAiMessage,
                                    behavior: HitTestBehavior.opaque,
                                    child: Container(
                                      width: 32,
                                      height: 32,
                                      decoration: const BoxDecoration(color: Color(0xFFD8B96A), shape: BoxShape.circle),
                                      child: const Icon(Icons.navigation, size: 16, color: AppColors.navy),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Floating Top Bar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          width: 42,
                          height: 42,
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)]),
                          child: const Icon(Icons.chevron_left, color: AppColors.navy, size: 28),
                        ),
                      ),
                      const StatusBadge('Checked in', kind: BadgeKind.green, dot: true),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _galleryThumb(String url, {String? overlay}) => Expanded(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(url, fit: BoxFit.cover),
              if (overlay != null)
                Container(
                  color: Colors.black.withValues(alpha: 0.45),
                  alignment: Alignment.center,
                  child: Text(overlay, style: AppTheme.dm(size: 16, weight: FontWeight.w700, color: Colors.white)),
                ),
            ],
          ),
        ),
      );

  Widget _infoChip(String label) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(color: AppColors.white, border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(10)),
        child: Text(label, style: AppTheme.dm(size: 13, weight: FontWeight.w600, color: AppColors.navy)),
      );

  Widget _aiChip(String label) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(border: Border.all(color: const Color(0xFFD8B96A)), borderRadius: BorderRadius.circular(14)),
        child: Text(label, style: AppTheme.dm(size: 11, weight: FontWeight.w500, color: const Color(0xFF8A6A1E)), maxLines: 1, overflow: TextOverflow.ellipsis),
      );
}

class _IconDetail extends StatelessWidget {
  const _IconDetail(this.icon, this.label);
  final IconData icon;
  final String label;
  @override
  Widget build(BuildContext context) => Row(children: [Icon(icon, size: 20, color: AppColors.navy), const SizedBox(width: 12), Flexible(child: Text(label, style: AppTheme.dm(size: 14)))]);
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();
  @override
  Widget build(BuildContext context) => Container(width: 1, height: 26, color: const Color(0xFFF0EAE0), margin: const EdgeInsets.symmetric(horizontal: 8));
}
