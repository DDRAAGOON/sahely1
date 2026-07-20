import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gal/gal.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../core/theme/app_colors.dart';

class ShareCollectionSheet extends StatelessWidget {
  final String collectionName;
  final String collectionImage;
  final int placesCount;
  final String shareableLink;
  final bool isInviteOnly;

  const ShareCollectionSheet({
    super.key,
    required this.collectionName,
    required this.collectionImage,
    required this.placesCount,
    required this.shareableLink,
    this.isInviteOnly = false,
  });

  Future<void> _launchUrl(String url, BuildContext context) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not open the app for: $url')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _shareViaWhatsApp(BuildContext context) {
    final text =
        'Check out my Sahely collection "$collectionName": $shareableLink';
    final url = 'whatsapp://send?text=${Uri.encodeComponent(text)}';
    _launchUrl(url, context);
  }

  void _shareViaInstagram(BuildContext context) {
    // Open Instagram app or web
    const url = 'https://www.instagram.com/';
    _launchUrl(url, context);
  }

  void _openMoreSharing(BuildContext context) {
    Share.share(
      'Check out my Sahely collection "$collectionName": $shareableLink',
      subject: 'My Sahely Collection',
    );
  }

  Future<void> _saveToGallery(BuildContext context) async {
    try {
      final hasAccess = await Gal.hasAccess();
      if (!hasAccess) {
        final granted = await Gal.requestAccess();
        if (!granted) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Gallery permission denied')),
            );
          }
          return;
        }
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Saving collection image...')),
        );
      }

      final response = await http.get(Uri.parse(collectionImage));
      if (response.statusCode == 200) {
        await Gal.putImageBytes(response.bodyBytes);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Saved to gallery!')),
          );
        }
      } else {
        throw Exception('Failed to download image');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF5F0E8),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(32),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
          20, 12, 20, MediaQuery.of(context).padding.bottom + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFE0D8CC),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),

          // Collection Info
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  collectionImage,
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 64,
                    height: 64,
                    color: AppColors.border,
                    child: const Icon(Icons.folder, color: AppColors.secondary),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      collectionName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1B2744),
                        fontFamily: 'DM Sans',
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$placesCount places · shareable link',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF717171),
                        fontFamily: 'DM Sans',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Share Link Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFE0D8CC)),
            ),
            child: Row(
              children: [
                const Icon(Icons.link, size: 20, color: Color(0xFFA08050)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    shareableLink,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF717171),
                      fontFamily: 'DM Sans',
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: shareableLink));
                    HapticFeedback.mediumImpact();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Link copied to clipboard!'),
                          duration: Duration(seconds: 2)),
                    );
                  },
                  behavior: HitTestBehavior.opaque,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Text(
                      'Copy',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1B2744),
                        fontFamily: 'DM Sans',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Sharing Options Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _SocialOption(
                icon: Icons.chat_bubble,
                label: 'WhatsApp',
                color: const Color(0xFF25D366),
                onTap: () => _shareViaWhatsApp(context),
              ),
              _SocialOption(
                icon: Icons.camera_alt,
                label: 'Instagram',
                color: Colors.white,
                isInstagram: true,
                onTap: () => _shareViaInstagram(context),
              ),
              _SocialOption(
                icon: Icons.file_upload_outlined,
                label: 'Save gallery',
                color: const Color(0xFF1B2744),
                onTap: () => _saveToGallery(context),
              ),
              _SocialOption(
                icon: Icons.more_horiz,
                label: 'More',
                color: const Color(0xFF1B2744),
                isMore: true,
                onTap: () => _openMoreSharing(context),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Invite Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                const Icon(Icons.person_add_alt_1_outlined,
                    color: Color(0xFF1B6B3A), size: 20),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text.rich(
                    TextSpan(
                      text: 'Invite friends to ',
                      style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF1B2744),
                          fontFamily: 'DM Sans'),
                      children: [
                        TextSpan(
                            text: 'add & vote',
                            style: TextStyle(fontWeight: FontWeight.w700)),
                        TextSpan(text: ' on places'),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Invite sent to contacts')),
                    );
                  },
                  behavior: HitTestBehavior.opaque,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Text(
                      'Invite',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFA08050),
                        fontFamily: 'DM Sans',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Done Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B2744),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Done',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'DM Sans',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isInstagram;
  final bool isMore;
  final VoidCallback onTap;

  const _SocialOption({
    required this.icon,
    required this.label,
    required this.color,
    this.isInstagram = false,
    this.isMore = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isMore ? Colors.white : (isInstagram ? null : color),
              gradient: isInstagram
                  ? const LinearGradient(
                      colors: [
                        Color(0xFF833AB4),
                        Color(0xFFFD1D1D),
                        Color(0xFFFCB045)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              boxShadow: isMore
                  ? [
                      BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2))
                    ]
                  : null,
            ),
            child: Icon(
              label == 'WhatsApp'
                  ? Icons.chat
                  : (isInstagram ? Icons.camera_alt : icon),
              color: isMore ? const Color(0xFF1B2744) : Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1B2744),
              fontFamily: 'DM Sans',
            ),
          ),
        ],
      ),
    );
  }
}
