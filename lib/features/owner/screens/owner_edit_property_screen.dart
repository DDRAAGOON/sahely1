import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/models.dart';
import '../../../data/sample_data.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/common.dart';
import '../../../core/widgets/kit.dart';
import '../../../core/widgets/ui.dart';

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
