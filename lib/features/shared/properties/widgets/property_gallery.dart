import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../widgets/image.dart';

class PropertyGallery extends StatefulWidget {
  final List<String> images;
  final double height;

  const PropertyGallery({
    super.key,
    required this.images,
    this.height = 280,
  });

  @override
  State<PropertyGallery> createState() => _PropertyGalleryState();
}

class _PropertyGalleryState extends State<PropertyGallery> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return Container(
        height: widget.height,
        color: AppColors.border,
        child: const Icon(Icons.image_not_supported, color: AppColors.secondary),
      );
    }

    return Stack(
      children: [
        SizedBox(
          height: widget.height,
          width: double.infinity,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: widget.images.length,
            itemBuilder: (context, index) => SahelyImage(
              imageUrl: widget.images[index],
              allImages: widget.images,
              fadeHeight: 140,
              showFade: true,
            ),
          ),
        ),
        // Indicators
        Positioned(
          bottom: 14,
          left: 0,
          right: 0,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(widget.images.length, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: index == _currentPage ? 18 : 6,
                  height: 6,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    color: index == _currentPage ? Colors.white : Colors.white54,
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}
