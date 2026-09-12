import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/buttons.dart';

/// Performance-optimized drop-in replacement for [Image.network]:
/// disk-caches downloads and decodes at display size instead of full res.
class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.errorWidget,
  });

  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final ImageErrorWidgetBuilder? errorWidget;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      fadeInDuration: const Duration(milliseconds: 150),
      memCacheWidth: _bounded(width),
      memCacheHeight: _bounded(height),
      placeholder: (_, __) => Container(
        width: width,
        height: height,
        color: AppColors.cardWarm.withValues(alpha: 0.5),
      ),
      errorWidget: (context, url, error) {
        final custom = errorWidget;
        if (custom != null) return custom(context, error, StackTrace.empty);
        return Container(
            width: width, height: height, color: AppColors.cardWarm);
      },
    );
  }

  static int? _bounded(double? logicalSide) {
    if (logicalSide == null || !logicalSide.isFinite || logicalSide <= 0) {
      return null;
    }
    return (logicalSide * 2).toInt();
  }
}

/// Rounded photo with a soft bottom fade.
class BlendedImage extends StatelessWidget {
  const BlendedImage({
    super.key,
    required this.url,
    required this.height,
    this.radius = 16,
    this.overlay = true,
  });

  final String url;
  final double height;
  final double radius;
  final bool overlay;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: url,
              fit: BoxFit.cover,
              placeholder: (c, url) =>
                  const ColoredBox(color: AppColors.cardWarm),
              errorWidget: (_, __, ___) =>
                  const ColoredBox(color: AppColors.cardWarm),
              memCacheHeight:
                  (height * 2).toInt(), // Optimization: limit cache size
            ),
            if (overlay)
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x0A1B2744),
                      Colors.transparent,
                      Color(0x8CF5F0E8)
                    ],
                    stops: [0, 0.5, 1],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class SahelyImage extends StatelessWidget {
  const SahelyImage({
    super.key,
    required this.imageUrl,
    this.allImages,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.fadeColor,
    this.fadeHeight = 100,
    this.borderRadius,
    this.showFade = true,
    this.errorBuilder,
    this.loadingBuilder,
    this.enableViewer = true,
  });

  final String imageUrl;
  final List<String>? allImages;
  final double? height;
  final double? width;
  final BoxFit fit;
  final Color? fadeColor;
  final double fadeHeight;
  final BorderRadius? borderRadius;
  final bool showFade;
  final ImageErrorWidgetBuilder? errorBuilder;
  final ImageLoadingBuilder? loadingBuilder;
  final bool enableViewer;

  @override
  Widget build(BuildContext context) {
    final image = CachedNetworkImage(
      imageUrl: imageUrl,
      height: height,
      width: width,
      fit: fit,
      placeholder: (context, url) => loadingBuilder != null
          ? loadingBuilder!(context, const SizedBox(), null)
          : Container(
              height: height ?? 150,
              width: width ?? double.infinity,
              color: AppColors.border.withValues(alpha: 0.1),
            ),
      errorWidget: (context, url, error) => errorBuilder != null
          ? errorBuilder!(context, error, null)
          : Container(
              height: height ?? 150,
              width: width ?? double.infinity,
              color: AppColors.navy,
            ),
      memCacheHeight:
          (height != null && height!.isFinite) ? (height! * 2).toInt() : null,
      memCacheWidth:
          (width != null && width!.isFinite) ? (width! * 2).toInt() : null,
    );

    Widget result = image;

    if (showFade) {
      result = Stack(
        fit: StackFit.passthrough,
        children: [
          image,
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: fadeHeight,
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    fadeColor ?? AppColors.white.withValues(alpha: 0.95)
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }

    if (borderRadius != null) {
      result = ClipRRect(borderRadius: borderRadius!, child: result);
    }

    if (enableViewer) {
      final List<String> images = allImages ?? [imageUrl];
      final int initialIndex = images.indexOf(imageUrl);
      return GestureDetector(
        onTap: () => Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (_) => SahelyImageViewer(
              images: images,
              initialIndex: initialIndex != -1 ? initialIndex : 0,
            ),
          ),
        ),
        child: result,
      );
    }

    return result;
  }
}

class SahelyImageViewer extends StatefulWidget {
  const SahelyImageViewer(
      {super.key, required this.images, this.initialIndex = 0});

  final List<String> images;
  final int initialIndex;

  @override
  State<SahelyImageViewer> createState() => _SahelyImageViewerState();
}

class _SahelyImageViewerState extends State<SahelyImageViewer> {
  late final PageController _pageController;
  final TransformationController _transformationController =
      TransformationController();
  late int _currentIndex;
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

  Future<void> _downloadImage(String url) async {
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    final tempDir = await getTemporaryDirectory();
    final path =
        '${tempDir.path}/sahely_image_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final file = File(path);
    await file.writeAsBytes(bytes);
    await Gal.putImage(path);
  }

  void _onDownloadTap() {
    showModalBottomSheet(
      isScrollControlled: true,
      useRootNavigator: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
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
              Text('Download Options',
                  style: AppTheme.dm(
                      size: 17,
                      weight: FontWeight.w700,
                      color: AppColors.navy)),
              const SizedBox(height: 24),
              NavyButton(
                label: 'Download Current Image',
                onTap: () {
                  Navigator.pop(ctx);
                  _executeDownload([widget.images[_currentIndex]]);
                },
              ),
              if (widget.images.length > 1) ...[
                const SizedBox(height: 12),
                NavyButton(
                  label: 'Download All Images (${widget.images.length})',
                  outline: true,
                  onTap: () {
                    Navigator.pop(ctx);
                    _executeDownload(widget.images);
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _executeDownload(List<String> urls) async {
    try {
      final multiple = urls.length > 1;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white)),
              const SizedBox(width: 12),
              Text(
                  multiple
                      ? 'Downloading all images...'
                      : 'Saving to gallery...',
                  style: AppTheme.dm(color: Colors.white)),
            ],
          ),
          duration: const Duration(seconds: 1),
          backgroundColor: AppColors.navy,
        ),
      );

      for (final url in urls) {
        await _downloadImage(url);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                multiple
                    ? 'All images saved successfully!'
                    : 'Image saved successfully!',
                style: AppTheme.dm(color: Colors.white)),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save. Please check your connection.',
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
            onPageChanged: (i) {
              setState(() {
                _currentIndex = i;
                _transformationController.value = Matrix4.identity();
                _isZoomed = false;
              });
            },
            itemCount: widget.images.length,
            itemBuilder: (context, i) {
              return GestureDetector(
                onDoubleTap: _handleDoubleTap,
                child: InteractiveViewer(
                  transformationController:
                      i == _currentIndex ? _transformationController : null,
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
                      imageUrl: widget.images[i],
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              );
            },
          ),
          if (widget.images.length > 1)
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.navy.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_currentIndex + 1} / ${widget.images.length}',
                    style: AppTheme.dm(
                        size: 13, weight: FontWeight.w600, color: Colors.white),
                  ),
                ),
              ),
            ),
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
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 4)
                          ]),
                      child: const Icon(Icons.close,
                          color: AppColors.navy, size: 24),
                    ),
                  ),
                  GestureDetector(
                    onTap: _onDownloadTap,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                          color: AppColors.gold,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 4)
                          ]),
                      child: const Icon(Icons.download_rounded,
                          color: AppColors.navy, size: 24),
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
