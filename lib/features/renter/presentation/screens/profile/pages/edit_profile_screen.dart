import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/providers/profile_provider.dart';
import '../widgets/edit_profile_avatar.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _bioController;
  late TextEditingController _instagramController;
  late TextEditingController _tiktokController;
  late TextEditingController _facebookController;
  String? _localAvatarPath;
  
  final int _bioMaxLength = 150;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final profile = context.read<ProfileProvider>();
    _bioController = TextEditingController(text: profile.bio);
    _instagramController = TextEditingController(text: profile.instagram ?? '');
    _tiktokController = TextEditingController(text: profile.tiktok ?? '');
    _facebookController = TextEditingController(text: profile.facebook ?? '');
    _localAvatarPath = profile.avatarPath;
    
    _bioController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _bioController.dispose();
    _instagramController.dispose();
    _tiktokController.dispose();
    _facebookController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() {
        _localAvatarPath = image.path;
      });
    }
  }

  void _handleSave() async {
    setState(() => _isLoading = true);
    
    // Save to provider
    context.read<ProfileProvider>().updateProfile(
      bio: _bioController.text,
      instagram: _instagramController.text,
      tiktok: _tiktokController.text,
      facebook: _facebookController.text,
      avatarPath: _localAvatarPath,
    );

    // Mock API delay
    await Future.delayed(const Duration(seconds: 1));
    
    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    }
  }

  Color _getCounterColor() {
    int length = _bioController.text.length;
    if (length > 140) return AppColors.red;
    if (length > 120) return AppColors.warning;
    return AppColors.secondary;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(Icons.chevron_left, color: AppColors.navy),
          ),
        ),
        title: const Text(
          'Edit Bio',
          style: TextStyle(
            color: AppColors.navy,
            fontWeight: FontWeight.w700,
            fontFamily: 'Cairo',
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  // Avatar Section
                  EditProfileAvatar(
                    localPath: _localAvatarPath,
                    onAvatarTap: _pickImage,
                  ),
                  const SizedBox(height: 16), // Reduced spacing

                  // About You Section
                  const Text(
                    'About you',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.goldTint,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.gold, width: 1.5),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextField(
                          controller: _bioController,
                          maxLength: _bioMaxLength,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            counterText: '',
                            hintText: 'Tell us about yourself...',
                          ),
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.navy,
                            fontFamily: 'Cairo',
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${_bioController.text.length} / $_bioMaxLength',
                      style: TextStyle(
                        fontSize: 12,
                        color: _getCounterColor(),
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Social Accounts Section
                  const Row(
                    children: [
                      Text(
                        'Link social accounts',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      SizedBox(width: 6),
                      Text(
                        '· optional',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.gold,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _SocialLinkField(
                    icon: Icons.camera_alt_outlined,
                    label: 'Instagram',
                    controller: _instagramController,
                    hint: 'Add your Instagram',
                  ),
                  const SizedBox(height: 12),
                  _SocialLinkField(
                    icon: Icons.music_note_outlined,
                    label: 'TikTok',
                    controller: _tiktokController,
                    hint: 'Add your TikTok',
                  ),
                  const SizedBox(height: 12),
                  _SocialLinkField(
                    icon: Icons.facebook_outlined,
                    label: 'Facebook',
                    controller: _facebookController,
                    hint: 'Add your Facebook',
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),

          // Bottom Button (No box behind)
          Container(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            color: Colors.transparent, // Explicitly transparent
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.navy,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Text(
                        'Save Profile',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontFamily: 'Cairo',
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialLinkField extends StatefulWidget {
  final IconData icon;
  final String label;
  final TextEditingController controller;
  final String hint;

  const _SocialLinkField({
    required this.icon,
    required this.label,
    required this.controller,
    required this.hint,
  });

  @override
  State<_SocialLinkField> createState() => _SocialLinkFieldState();
}

class _SocialLinkFieldState extends State<_SocialLinkField> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    bool isLinked = widget.controller.text.isNotEmpty;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(widget.icon, size: 20, color: AppColors.gold),
              const SizedBox(width: 10),
              Text(
                widget.label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                  fontFamily: 'Cairo',
                ),
              ),
              const Spacer(),
              _buildBadge(isLinked),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.goldTint,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isLinked ? AppColors.gold : AppColors.border),
            ),
            child: TextField(
              controller: widget.controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: widget.hint,
                hintStyle: const TextStyle(color: AppColors.placeholder, fontSize: 13),
              ),
              style: const TextStyle(fontSize: 14, color: AppColors.navy),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(bool isLinked) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isLinked ? AppColors.green.withValues(alpha: 0.1) : AppColors.gold.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        isLinked ? 'Linked' : 'Optional',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: isLinked ? AppColors.green : AppColors.gold,
        ),
      ),
    );
  }
}
