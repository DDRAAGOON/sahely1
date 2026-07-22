import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/avatars.dart';
import 'package:sahely/core/widgets/cards.dart';
import 'package:sahely/core/widgets/cream_background.dart';
import 'package:sahely/core/widgets/ui.dart';

class OwnerEditBioScreen extends StatefulWidget {
  const OwnerEditBioScreen({super.key});

  @override
  State<OwnerEditBioScreen> createState() => _OwnerEditBioScreenState();
}

class _OwnerEditBioScreenState extends State<OwnerEditBioScreen> {
  final _bioController = TextEditingController(
      text:
          'Hosting beachfront villas across Marassi & Hacienda Bay. Superhost since 2023 🏖');
  final _instaController = TextEditingController(text: '@layla.stays');
  final _tiktokController = TextEditingController();
  final _fbController = TextEditingController();

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _bioController.dispose();
    _instaController.dispose();
    _tiktokController.dispose();
    _fbController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 24),
            Text('Change Photo',
                style: AppTheme.dm(
                    size: 17, weight: FontWeight.w700, color: AppColors.navy)),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _sourceButton(
                    icon: Icons.camera_alt_outlined,
                    label: 'Camera',
                    onTap: () async {
                      Navigator.pop(ctx);
                      final XFile? photo =
                          await _picker.pickImage(source: ImageSource.camera);
                      if (photo != null)
                        setState(() => _imageFile = File(photo.path));
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _sourceButton(
                    icon: Icons.photo_library_outlined,
                    label: 'Gallery',
                    onTap: () async {
                      Navigator.pop(ctx);
                      final XFile? image =
                          await _picker.pickImage(source: ImageSource.gallery);
                      if (image != null)
                        setState(() => _imageFile = File(image.path));
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _sourceButton(
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.goldSoft,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 28, color: AppColors.navy),
            const SizedBox(height: 8),
            Text(label,
                style: AppTheme.dm(
                    size: 14, weight: FontWeight.w600, color: AppColors.navy)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PhoneScaffold(
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Row(
              children: [
                const BackChip(),
                const SizedBox(width: 12),
                Text('Edit Bio',
                    style: AppTheme.dm(
                        size: 20,
                        weight: FontWeight.w700,
                        color: AppColors.navy)),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
              children: [
                // Profile Photo Section
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    behavior: HitTestBehavior.opaque,
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: const Color(0xFFD8B98A),
                                shape: BoxShape.circle,
                                image: _imageFile != null
                                    ? DecorationImage(
                                        image: FileImage(_imageFile!),
                                        fit: BoxFit.cover)
                                    : null,
                              ),
                              child: _imageFile == null
                                  ? const AvatarCircle(
                                      size: 100,
                                      colors: [
                                        Color(0xFFD8B98A),
                                        Color(0xFF7D5A2C)
                                      ],
                                    )
                                  : null,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: AppColors.gold,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: AppColors.white, width: 2),
                                ),
                                child: const Icon(Icons.camera_alt,
                                    size: 16, color: AppColors.navy),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text('Change photo',
                            style: AppTheme.dm(
                                size: 13,
                                weight: FontWeight.w700,
                                color: AppColors.gold)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // About You Section
                Text('About you',
                    style: AppTheme.dm(
                        size: 14,
                        weight: FontWeight.w700,
                        color: AppColors.navy)),
                const SizedBox(height: 8),
                AppTextField(
                  controller: _bioController,
                  height: 100,
                  fontSize: 14,
                  radius: 12,
                  borderColor: AppColors.gold,
                ),
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text('${_bioController.text.length} / 150',
                      style: AppTheme.dm(size: 12, color: AppColors.faint)),
                ),
                const SizedBox(height: 24),

                // Social Accounts Section
                RichText(
                  text: TextSpan(
                    style: AppTheme.dm(
                        size: 14,
                        weight: FontWeight.w700,
                        color: AppColors.navy),
                    children: [
                      const TextSpan(text: 'Link social accounts '),
                      TextSpan(
                        text: '· optional',
                        style: AppTheme.dm(
                            size: 14,
                            weight: FontWeight.w500,
                            color: AppColors.gold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                _socialCard(
                  icon: Icons.camera_alt_outlined,
                  name: 'Instagram',
                  status: 'Linked',
                  statusColor: const Color(0xFFD7EEDD),
                  statusTextColor: AppColors.success,
                  controller: _instaController,
                  hint: '@username',
                ),
                const SizedBox(height: 12),
                _socialCard(
                  icon: Icons.music_note_outlined,
                  name: 'TikTok',
                  status: 'Optional',
                  statusColor: Colors.transparent,
                  statusTextColor: AppColors.gold,
                  controller: _tiktokController,
                  hint: 'Add your TikTok',
                ),
                const SizedBox(height: 12),
                _socialCard(
                  icon: Icons.facebook_outlined,
                  name: 'Facebook',
                  status: 'Optional',
                  statusColor: Colors.transparent,
                  statusTextColor: AppColors.gold,
                  controller: _fbController,
                  hint: 'Add your Facebook',
                ),
              ],
            ),
          ),

          // Bottom Button
          Padding(
            padding: const EdgeInsets.all(20),
            child: NavyButton(
              label: 'Save Profile',
              onTap: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _socialCard({
    required IconData icon,
    required String name,
    required String status,
    required Color statusColor,
    required Color statusTextColor,
    required TextEditingController controller,
    required String hint,
  }) {
    return WhiteCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, size: 20, color: AppColors.gold),
                  const SizedBox(width: 8),
                  Text(name,
                      style: AppTheme.dm(
                          size: 14,
                          weight: FontWeight.w700,
                          color: AppColors.navy)),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(status,
                    style: AppTheme.dm(
                        size: 11,
                        weight: FontWeight.w700,
                        color: statusTextColor)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          AppTextField(
            controller: controller,
            hintText: hint,
            height: 48,
            radius: 10,
            backgroundColor: const Color(0xFFF5F0E8),
            borderColor: controller.text.isNotEmpty
                ? AppColors.gold
                : Colors.transparent,
          ),
        ],
      ),
    );
  }
}
