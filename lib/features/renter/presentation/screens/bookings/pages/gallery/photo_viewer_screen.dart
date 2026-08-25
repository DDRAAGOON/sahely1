import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PhotoViewerScreen extends StatefulWidget {
  final List<String> photos;
  final int initialIndex;

  const PhotoViewerScreen({
    super.key,
    required this.photos,
    this.initialIndex = 0,
  });

  @override
  State<PhotoViewerScreen> createState() => _PhotoViewerScreenState();
}

class _PhotoViewerScreenState extends State<PhotoViewerScreen> {
  late PageController _pageController;
  late int _currentIndex;
  final TransformationController _transformationController =
      TransformationController();
  bool _isZoomed = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  void _handleDoubleTap() {
    if (_transformationController.value != Matrix4.identity()) {
      _transformationController.value = Matrix4.identity();
      setState(() => _isZoomed = false);
    } else {
      const double scale = 2.5;
      final size = MediaQuery.of(context).size;
      final double dx = -(scale - 1) * size.width / 2;
      final double dy = -(scale - 1) * size.height / 2;
      _transformationController.value = Matrix4.identity()
        ..translateByDouble(dx, dy, 0, 1)
        ..scaleByDouble(scale, scale, scale, 1);
      setState(() => _isZoomed = true);
    }
  }

  void _showDownloadOptions() {
    showModalBottomSheet(
      useRootNavigator: true, context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'Download Photos',
                style: AppTheme.dm(
                  size: 18,
                  weight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.image_outlined, color: AppColors.navy),
              title: Text('Download current photo',
                  style: AppTheme.dm()),
              onTap: () {
                Navigator.pop(context);
                _downloadImage(widget.photos[_currentIndex]);
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.copy_all_outlined, color: AppColors.navy),
              title: Text('Download all photos (${widget.photos.length})',
                  style: AppTheme.dm()),
              onTap: () {
                Navigator.pop(context);
                _downloadAllImages();
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _saveImageToGallery(String url) async {
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    final tempDir = await getTemporaryDirectory();
    final path =
        '${tempDir.path}/sahely_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final file = File(path);
    await file.writeAsBytes(bytes);
    await Gal.putImage(path);
  }

  void _downloadImage(String url) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(children: [
          const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: Colors.white)),
          const SizedBox(width: 12),
          Text('Saving to gallery...', style: AppTheme.dm(color: Colors.white)),
        ]),
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.navy,
      ),
    );
    try {
      await _saveImageToGallery(url);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Image saved to gallery!',
                style: AppTheme.dm(color: Colors.white)),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save. Check your connection.',
                style: AppTheme.dm(color: Colors.white)),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    }
  }

  void _downloadAllImages() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(children: [
          const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: Colors.white)),
          const SizedBox(width: 12),
          Text('Downloading all ${widget.photos.length} photos...',
              style: AppTheme.dm(color: Colors.white)),
        ]),
        duration: const Duration(seconds: 3),
        backgroundColor: AppColors.navy,
      ),
    );
    try {
      for (final url in widget.photos) {
        await _saveImageToGallery(url);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('All ${widget.photos.length} photos saved!',
                style: AppTheme.dm(color: Colors.white)),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save. Check your connection.',
                style: AppTheme.dm(color: Colors.white)),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            physics: _isZoomed
                ? const NeverScrollableScrollPhysics()
                : const BouncingScrollPhysics(),
            itemCount: widget.photos.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
                _transformationController.value = Matrix4.identity();
                _isZoomed = false;
              });
            },
            itemBuilder: (context, index) {
              return GestureDetector(
                onDoubleTap: _handleDoubleTap,
                child: InteractiveViewer(
                  transformationController:
                      index == _currentIndex ? _transformationController : null,
                  panEnabled: true,
                  minScale: 1.0,
                  maxScale: 5.0,
                  onInteractionStart: (_) {
                    if (!_isZoomed) setState(() => _isZoomed = true);
                  },
                  onInteractionEnd: (details) {
                    if (_transformationController.value.getMaxScaleOnAxis() <=
                        1.01) {
                      setState(() => _isZoomed = false);
                    }
                  },
                  child: SizedBox.expand(
                    child: CachedNetworkImage(
                      imageUrl: widget.photos[index],
                      fit: BoxFit.contain,
                      placeholder: (context, url) => const Center(
                        child:
                            CircularProgressIndicator(color: AppColors.navy),
                      ),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.broken_image,
                        color: AppColors.navy,
                        size: 50,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // Counter pill
          if (widget.photos.length > 1)
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.navy.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_currentIndex + 1} / ${widget.photos.length}',
                    style: AppTheme.dm(
                        size: 13,
                        weight: FontWeight.w600,
                        color: AppColors.white),
                  ),
                ),
              ),
            ),

          // Top bar: close + download
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: AppColors.navy,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close,
                          color: AppColors.gold, size: 22),
                    ),
                  ),
                  GestureDetector(
                    onTap: _showDownloadOptions,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: AppColors.navy,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.download_rounded,
                          color: AppColors.gold, size: 22),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
