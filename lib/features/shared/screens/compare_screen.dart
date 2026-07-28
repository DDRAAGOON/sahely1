import 'package:flutter/material.dart';
import 'package:sahely/core/navigation/app_navigation.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/kit.dart';

const _azure = 'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=800&q=72&auto=format&fit=crop';
const _dunes = 'https://images.unsplash.com/photo-1776619316276-b1b461af9f15?w=800&q=72&auto=format&fit=crop';

class CompareScreen extends StatefulWidget {
  final String collectionName;
  final List<String> participantNames;

  const CompareScreen({
    super.key,
    this.collectionName = 'All Saved',
    this.participantNames = const ['Omar', 'Nour', 'Sara'],
  });

  @override
  State<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
  final TextEditingController _commentController = TextEditingController();
  final List<Map<String, dynamic>> _comments = [
    {'name': 'Omar', 'text': "Azure's free beach access seals it for me.", 'color': const Color(0xFFC19E67)},
    {'name': 'Nour', 'text': 'True, but Dunes is cheaper / night 🧐', 'color': const Color(0xFF6789A5)},
  ];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _addComment() {
    if (_commentController.text.trim().isEmpty) return;
    setState(() {
      _comments.add({
        'name': 'You',
        'text': _commentController.text.trim(),
        'color': AppColors.navy,
      });
      _commentController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      // Ensures the screen resizes when keyboard appears
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Header (Navy Part)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Row(children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.chevron_left, color: Colors.white, size: 20),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Compare',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.gold,
                              fontFamily: 'DM Sans')),
                      Text(widget.collectionName,
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.6),
                              fontFamily: 'DM Sans')),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => AppNavigation.goToShareCollection(
                    context,
                    collectionName: widget.collectionName,
                    shareableLink: 'sahely.app/compare/${widget.collectionName.toLowerCase().replaceAll(' ', '-')}',
                  ),
                  child: Container(
                      height: 30,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                          color: AppColors.gold,
                          borderRadius: BorderRadius.circular(16)),
                      child: const Row(children: [
                        Icon(Icons.link, size: 14, color: AppColors.navy),
                        SizedBox(width: 4),
                        Text('Share',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.navy,
                                fontFamily: 'DM Sans'))
                      ])),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            shape: BoxShape.circle),
                        child: const Icon(Icons.close,
                            size: 16, color: Colors.white))),
              ]),
            ),

            // 2. Main Content (Cream Part)
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                    color: AppColors.cream,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          // Property Image Teasers
                          Row(children: [
                            Expanded(child: _teaserCard(_azure, 'Azure Villa', 'EGP 4,500')),
                            const SizedBox(width: 12),
                            Expanded(child: _teaserCard(_dunes, 'Golden Dunes', 'EGP 3,800')),
                          ]),
                          
                          const SizedBox(height: 16),

                          // Comparison Table Card
                          WhiteCard(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            radius: 20,
                            child: Column(children: [
                              _tableRow('Location', 'Marassi · N.Coast', 'Hacienda Bay', 1),
                              _divider(),
                              _tableRow('Type', 'Villa', 'Chalet', 2),
                              _divider(),
                              _tableRow('Rating', '★ 4.8', '★ 4.7', 1),
                              _divider(),
                              _tableRow('Bedrooms', '4 bdr · 6 beds', '3 bdr · 5 beds', 1),
                              _divider(),
                              _tableRow('Bathrooms', '3', '2', 1),
                              _divider(),
                              _tableRow('View', 'Sea view', 'Dune view', 1),
                              _divider(),
                              _tableRow('Beach', 'Marina Beach', 'Lagoon Beach', 1),
                              _divider(),
                              _tableRow('Beach access', 'Free', 'EGP 150 / day', 1),
                              _divider(),
                              _tableRow('Pool', '✓', '×', 1),
                            ]),
                          ),

                          const SizedBox(height: 20),

                          // Action Buttons
                          const Row(children: [
                            Expanded(child: WideButton(label: 'Book Azure', color: AppColors.navy, height: 48, radius: 14)),
                            SizedBox(width: 12),
                            Expanded(child: WideButton(label: 'Book Dunes', color: AppColors.gold, textColor: AppColors.navy, height: 48, radius: 14)),
                          ]),

                          const SizedBox(height: 32),

                          // Collection Comments Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Collection comments',
                                  style: AppTheme.dm(size: 15, weight: FontWeight.w700, color: AppColors.navy)),
                              Row(children: [
                                const Icon(Icons.auto_awesome, size: 14, color: AppColors.muted),
                                const SizedBox(width: 4),
                                Text(widget.collectionName, style: AppTheme.dm(size: 11, color: AppColors.muted)),
                              ]),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Comments List
                          ..._comments.map((c) => Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(radius: 14, backgroundColor: c['color']),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      style: AppTheme.dm(size: 13, color: AppColors.navy),
                                      children: [
                                        TextSpan(text: '${c['name']} ', style: const TextStyle(fontWeight: FontWeight.w800)),
                                        TextSpan(text: c['text']),
                                      ]
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                        ],
                      ),
                    ),

                    // 3. Comment Input Bar (Now properly placed at bottom of Column)
                    Container(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF5F0E8),
                        border: Border(top: BorderSide(color: Color(0xFFE0D8CC))),
                      ),
                      child: Row(children: [
                        Expanded(
                          child: Container(
                            height: 44,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEEE7DE),
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: TextField(
                              controller: _commentController,
                              decoration: const InputDecoration(
                                hintText: 'Comment on this compare...',
                                hintStyle: TextStyle(fontSize: 13, color: AppColors.textPlaceholder),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                              style: const TextStyle(fontSize: 13),
                              onSubmitted: (_) => _addComment(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: _addComment,
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: const BoxDecoration(color: AppColors.gold, shape: BoxShape.circle),
                            child: const Icon(Icons.send, color: AppColors.navy, size: 20),
                          ),
                        ),
                      ]),
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

  Widget _teaserCard(String img, String name, String price) => ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: 106,
          child: Stack(fit: StackFit.expand, children: [
            Image.network(img, fit: BoxFit.cover),
            const DecoratedBox(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Color(0x99000000)]))),
            Positioned(
                left: 12,
                bottom: 10,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: AppTheme.dm(size: 13, weight: FontWeight.w700, color: Colors.white)),
                      Text(price, style: AppTheme.dm(size: 11, weight: FontWeight.w700, color: AppColors.gold)),
                    ])),
          ]),
        ),
      );

  Widget _tableRow(String label, String val1, String val2, int highlight) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(children: [
        Expanded(flex: 3, child: Text(label, style: AppTheme.dm(size: 12, color: AppColors.textSecondary))),
        Expanded(flex: 2, child: Center(child: Text(val1, style: AppTheme.dm(size: 12, weight: highlight == 1 ? FontWeight.w700 : FontWeight.w400, color: highlight == 1 ? AppColors.gold : AppColors.navy)))),
        Expanded(flex: 2, child: Center(child: Text(val2, style: AppTheme.dm(size: 12, weight: highlight == 2 ? FontWeight.w700 : FontWeight.w400, color: highlight == 2 ? AppColors.gold : AppColors.navy)))),
      ]),
    );
  }

  Widget _divider() => const Divider(height: 1, color: Color(0xFFF0EBE2));
}
