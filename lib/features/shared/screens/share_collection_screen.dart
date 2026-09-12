import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gal/gal.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:sahely/core/di/service_locator.dart' show sl;
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/kit.dart';
import 'package:sahely/core/widgets/sheet_handle.dart';
import 'package:sahely/core/widgets/image.dart';
import 'package:sahely/features/renter/data/datasources/wishlist_api_data_source.dart';

/// Share sheet for a wishlist collection.
///
/// The link is the collection's invite URL from the API
/// (`POST /wishlists/:id/share-link`). Opening it joins the collection - in
/// the app when it is installed, on the website otherwise.
class ShareCollectionScreen extends StatefulWidget {
  final String collectionId;
  final String collectionName;
  final String collectionImage;
  final int placesCount;

  const ShareCollectionScreen({
    super.key,
    this.collectionId = '',
    this.collectionName = '',
    this.collectionImage = '',
    this.placesCount = 0,
  });

  @override
  State<ShareCollectionScreen> createState() => _ShareCollectionScreenState();
}

class _ShareCollectionScreenState extends State<ShareCollectionScreen> {
  String? _link;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    if (widget.collectionId.isEmpty) {
      _failed = true;
    } else {
      _createLink();
    }
  }

  Future<void> _createLink() async {
    try {
      final link = await sl<WishlistApiDataSource>()
          .createShareLink(widget.collectionId);
      if (!mounted) return;
      setState(() {
        _link = link.isEmpty ? null : link;
        _failed = link.isEmpty;
      });
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    }
  }

  /// The link, or null (with a message) while it is not available.
  String? _requireLink() {
    final link = _link;
    if (link == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(_failed
              ? 'This collection cannot be shared right now.'
              : 'Creating the link, one moment…')));
    }
    return link;
  }

  String get _message =>
      'Check out this collection "${widget.collectionName}": $_link';

  Future<void> _shareViaWhatsApp() async {
    if (_requireLink() == null) return;
    final url =
        Uri.parse('whatsapp://send?text=${Uri.encodeComponent(_message)}');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
        return;
      }
    } catch (_) {}
    // WhatsApp is not installed: fall back to the system share sheet.
    await SharePlus.instance.share(ShareParams(text: _message));
  }

  void _shareViaInstagram() async {
    const url = 'https://www.instagram.com/';
    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      }
    } catch (_) {}
  }

  Future<void> _saveToGallery(BuildContext context) async {
    if (widget.collectionImage.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('This collection has no cover yet.')));
      return;
    }
    try {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Saving image...')));
      final hasAccess = await Gal.hasAccess();
      if (!hasAccess) {
        final granted = await Gal.requestAccess();
        if (!granted) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Permission denied')));
          }
          return;
        }
      }
      final response = await http.get(Uri.parse(widget.collectionImage));
      if (response.statusCode == 200) {
        await Gal.putImageBytes(response.bodyBytes);
        if (context.mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Saved to gallery!')));
        }
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to save image')));
      }
    }
  }

  void _openMoreSharing() {
    if (_requireLink() == null) return;
    SharePlus.instance.share(ShareParams(text: _message));
  }

  void _invite() {
    final link = _requireLink();
    if (link == null) return;
    SharePlus.instance
        .share(ShareParams(text: 'Help me add & vote on places: $link'));
  }

  void _copyLink() {
    final link = _requireLink();
    if (link == null) return;
    Clipboard.setData(ClipboardData(text: link));
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Link copied!')));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Color(0xF5F5F0E8),
          borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 26),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SheetHandle(),
          const SizedBox(height: 12),
          Row(children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AppNetworkImage(
                    url: widget.collectionImage,
                    width: 52,
                    height: 52,
                    errorWidget: (_, __, ___) => Container(
                        width: 52, height: 52, color: AppColors.cardWarm))),
            const SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(widget.collectionName,
                  style: AppTheme.dm(
                      size: 15,
                      weight: FontWeight.w700,
                      color: AppColors.navy)),
              Text('${widget.placesCount} places · shareable link',
                  style: AppTheme.dm(size: 12, color: AppColors.muted)),
            ]),
          ]),
          const SizedBox(height: 16),
          Container(
            height: 46,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
                color: AppColors.white,
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(999)),
            child: Row(children: [
              const Icon(Icons.link, size: 16, color: AppColors.gold),
              const SizedBox(width: 8),
              Expanded(
                  child: Text(
                      _link ??
                          (_failed ? 'Link unavailable' : 'Creating link…'),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTheme.dm(size: 12, color: AppColors.muted))),
              GestureDetector(
                onTap: _copyLink,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 4.0),
                  child: Text('Copy',
                      style: AppTheme.dm(
                          size: 12,
                          weight: FontWeight.w700,
                          color: AppColors.navy)),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 18),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            _target('WhatsApp', const Color(0xFF25D366), Icons.chat,
                onTap: _shareViaWhatsApp),
            _target('Instagram', null, Icons.camera_alt,
                gradient: const [
                  Color(0xFFFEDA77),
                  Color(0xFFF58529),
                  Color(0xFFDD2A7B),
                  Color(0xFF8134AF)
                ],
                onTap: _shareViaInstagram),
            _target('Save gallery', AppColors.navy, Icons.download,
                iconColor: AppColors.gold,
                onTap: () => _saveToGallery(context)),
            _target('More', AppColors.white, Icons.more_horiz,
                border: true, onTap: _openMoreSharing),
          ]),
          const SizedBox(height: 18),
          WhiteCard(
            padding: const EdgeInsets.all(12),
            radius: 18,
            child: Row(children: [
              const Icon(Icons.people_outline,
                  size: 20, color: AppColors.success),
              const SizedBox(width: 10),
              Expanded(
                  child: RichText(
                      text: TextSpan(
                          style: AppTheme.dm(size: 12, color: AppColors.ink),
                          children: const [
                    TextSpan(text: 'Invite friends to '),
                    TextSpan(
                        text: 'add & vote',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                    TextSpan(text: ' on places')
                  ]))),
              GestureDetector(
                onTap: _invite,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 8.0),
                  child: Text('Invite',
                      style: AppTheme.dm(
                          size: 12,
                          weight: FontWeight.w700,
                          color: AppColors.gold)),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 16),
          WideButton(
              label: 'Done',
              color: AppColors.navy,
              height: 50,
              radius: 999,
              onTap: () => Navigator.maybePop(context)),
        ],
      ),
    );
  }

  Widget _target(String label, Color? bg, IconData icon,
          {List<Color>? gradient,
          Color iconColor = Colors.white,
          bool border = false,
          VoidCallback? onTap}) =>
      GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                  color: bg,
                  gradient: gradient != null
                      ? LinearGradient(
                          colors: gradient,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight)
                      : null,
                  shape: BoxShape.circle,
                  border: border ? Border.all(color: AppColors.border) : null),
              child: Icon(icon,
                  color: border ? AppColors.navy : iconColor, size: 22),
            ),
            const SizedBox(height: 6),
            Text(label, style: AppTheme.dm(size: 11, color: AppColors.ink)),
          ],
        ),
      );
}
