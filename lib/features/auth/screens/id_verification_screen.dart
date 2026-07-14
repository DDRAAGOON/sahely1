import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/cream_background.dart';
import '../../../core/widgets/ui.dart';

// ===================================================== 10 · ID Verification
class IdVerificationScreen extends StatefulWidget {
  const IdVerificationScreen({super.key});

  @override
  State<IdVerificationScreen> createState() => _IdVerificationScreenState();
}

class _IdVerificationScreenState extends State<IdVerificationScreen> {
  int _selectedType = 0; // 0: National ID, 1: Passport, 2: Driving Licence
  File? _frontImage;
  File? _backImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source, bool isFront) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          if (isFront) {
            _frontImage = File(pickedFile.path);
          } else {
            _backImage = File(pickedFile.path);
          }
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  void _showPicker(BuildContext context, bool isFront) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_selectedType == 1 ? 'Upload Passport' : 'Upload ${isFront ? 'Front' : 'Back'} Side',
                style: AppTheme.dm(size: 18, weight: FontWeight.w700, color: AppColors.navy)),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined, color: AppColors.gold),
                title: Text('Take a photo', style: AppTheme.dm(size: 15, weight: FontWeight.w600)),
                subtitle: Text('Capture with your camera', style: AppTheme.dm(size: 12, color: AppColors.muted)),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(ImageSource.camera, isFront);
                },
              ),
              const Divider(color: AppColors.border, indent: 20, endIndent: 20),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined, color: AppColors.gold),
                title: Text('Upload from gallery', style: AppTheme.dm(size: 15, weight: FontWeight.w600)),
                subtitle: Text('Choose an existing photo', style: AppTheme.dm(size: 12, color: AppColors.muted)),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(ImageSource.gallery, isFront);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;

    return PhoneScaffold(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(28, 22, 28, 26),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const _StepBar(active: 1),
                      const SizedBox(height: 24),
                      Text('Verify Your Identity', style: AppTheme.dm(size: 22, weight: FontWeight.w700, color: AppColors.navy)),
                      const SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          text: 'Upload your ',
                          style: AppTheme.dm(size: 14, color: AppColors.muted),
                          children: [
                            TextSpan(text: 'National ID', style: AppTheme.dm(size: 14, weight: FontWeight.w700, color: AppColors.ink)),
                            TextSpan(text: ', ', style: AppTheme.dm(size: 14, color: AppColors.muted)),
                            TextSpan(text: 'Passport', style: AppTheme.dm(size: 14, weight: FontWeight.w700, color: AppColors.ink)),
                            TextSpan(text: ', or ', style: AppTheme.dm(size: 14, color: AppColors.muted)),
                            TextSpan(text: 'Driving Licence', style: AppTheme.dm(size: 14, weight: FontWeight.w700, color: AppColors.ink)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(child: _DocTypeChip('National ID', selected: _selectedType == 0, onTap: () => setState(() => _selectedType = 0))),
                          const SizedBox(width: 8),
                          Expanded(child: _DocTypeChip('Passport', selected: _selectedType == 1, onTap: () => setState(() => _selectedType = 1))),
                          const SizedBox(width: 8),
                          Expanded(child: _DocTypeChip('Driving Licence', selected: _selectedType == 2, onTap: () => setState(() => _selectedType = 2))),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (_selectedType == 1) ...[
                        // Passport: Single upload box
                        const SizedBox(height: 40),
                        _UploadBox(
                          active: true,
                          uploaded: _frontImage != null,
                          image: _frontImage,
                          icon: Icons.image_outlined,
                          label: _frontImage != null ? 'Passport photo uploaded' : 'Tap to upload passport',
                          onTap: () => _showPicker(context, true),
                        ),
                        const SizedBox(height: 40),
                      ] else ...[
                        // National ID or Driving Licence: Front and Back
                        _UploadBox(
                          active: true,
                          uploaded: _frontImage != null,
                          image: _frontImage,
                          icon: Icons.image_outlined,
                          label: _frontImage != null ? 'Front side uploaded' : 'Tap to upload front',
                          onTap: () => _showPicker(context, true),
                        ),
                        const SizedBox(height: 12),
                        _UploadBox(
                          active: _frontImage != null,
                          uploaded: _backImage != null,
                          image: _backImage,
                          icon: Icons.notes_outlined,
                          label: _backImage != null ? 'Back side uploaded' : 'Tap to upload back',
                          onTap: _frontImage != null ? () => _showPicker(context, false) : null,
                        ),
                      ],
                      const SizedBox(height: 10),
                      Text(
                          _selectedType == 1 
                            ? 'JPG, PNG or PDF · Max 10MB · Upload the photo page only'
                            : 'JPG, PNG or PDF · Max 10MB',
                          style: AppTheme.dm(size: 12, color: AppColors.muted)),
                      const Spacer(),
                      const SizedBox(height: 24),
                      NavyButton(
                        label: 'Continue', 
                        enabled: _selectedType == 1 ? _frontImage != null : (_frontImage != null && _backImage != null),
                        onTap: () => Navigator.pushNamed(context, '/facial-scan', arguments: args)
                      ),
                      const SizedBox(height: 14),
                      Center(
                        child: GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/facial-scan', arguments: args),
                          child: Text('Skip for now',
                              style: AppTheme.dm(size: 13, weight: FontWeight.w600, color: AppColors.gold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _StepBar extends StatelessWidget {
  const _StepBar({required this.active}); // 0=personal,1=id,2=selfie
  final int active;
  @override
  Widget build(BuildContext context) {
    Widget node(int i, String label) {
      final done = i < active;
      final cur = i == active;
      final bg = done || cur ? (done ? AppColors.gold : AppColors.navy) : AppColors.border;
      final fg = done ? AppColors.navy : (cur ? AppColors.white : AppColors.muted);
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 22,
            height: 22,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
            child: done
                ? const Icon(Icons.check, size: 11, color: AppColors.navy)
                : Text('${i + 1}', style: AppTheme.dm(size: 11, color: fg)),
          ),
          if (label.isNotEmpty) ...[
            const SizedBox(width: 6),
            Text(label,
                style: AppTheme.dm(
                    size: 12,
                    weight: FontWeight.w600,
                    color: cur ? AppColors.navy : (done ? AppColors.gold : AppColors.faint))),
          ],
        ],
      );
    }

    return Row(
      children: [
        node(0, 'Personal'),
        Expanded(child: Container(height: 2, margin: const EdgeInsets.symmetric(horizontal: 8), color: active >= 1 ? AppColors.gold : AppColors.border)),
        node(1, 'ID Verify'),
        Expanded(child: Container(height: 2, margin: const EdgeInsets.symmetric(horizontal: 8), color: active >= 2 ? AppColors.gold : AppColors.border)),
        node(2, ''),
      ],
    );
  }
}

class _DocTypeChip extends StatelessWidget {
  const _DocTypeChip(this.label, {this.selected = false, this.onTap});
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.navy : AppColors.white,
          border: selected ? null : Border.all(color: AppColors.navy),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(label,
            textAlign: TextAlign.center,
            style: AppTheme.dm(size: 11, weight: FontWeight.w600, color: selected ? AppColors.white : AppColors.navy)),
      ),
    );
  }
}

class _UploadBox extends StatelessWidget {
  const _UploadBox({
    required this.active, 
    required this.icon, 
    required this.label, 
    this.onTap,
    this.uploaded = false,
    this.image,
  });
  final bool active;
  final bool uploaded;
  final File? image;
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: active ? onTap : null,
      child: Opacity(
        opacity: active ? 1.0 : 0.5,
        child: DottedBorder(
          color: uploaded ? AppColors.success : (active ? AppColors.gold : AppColors.border),
          child: Container(
            height: 132,
            decoration: BoxDecoration(
              color: uploaded ? AppColors.goldSoft.withValues(alpha: 0.5) : (active ? AppColors.goldSoft : AppColors.white),
              borderRadius: BorderRadius.circular(14),
              image: image != null ? DecorationImage(
                image: FileImage(image!),
                fit: BoxFit.cover,
                opacity: 0.3,
              ) : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!uploaded) Icon(icon, size: 34, color: active ? AppColors.gold : AppColors.faint),
                if (uploaded) const Icon(Icons.check_circle, size: 34, color: AppColors.success),
                const SizedBox(height: 10),
                Text(label,
                    style: AppTheme.dm(
                        size: 14, 
                        weight: FontWeight.w600, 
                        color: uploaded ? AppColors.success : (active ? AppColors.navy : AppColors.muted))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
