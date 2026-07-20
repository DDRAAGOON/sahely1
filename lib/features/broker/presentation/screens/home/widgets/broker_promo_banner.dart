import 'package:flutter/material.dart';

import '../../../../../../core/theme/app_colors.dart';

class BrokerPromoBanner extends StatefulWidget {
  const BrokerPromoBanner({super.key});

  @override
  State<BrokerPromoBanner> createState() => _BrokerPromoBannerState();
}

class _BrokerPromoBannerState extends State<BrokerPromoBanner> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  final List<Map<String, String>> _slides = [
    {
      'title': 'Book with Confidence',
      'subtitle': 'Secure payments, verified properties.',
    },
    {
      'title': 'Smart Lock Access',
      'subtitle': 'Instant entry with digital passcodes.',
    },
    {
      'title': 'Verified Properties',
      'subtitle': 'Every listing inspected by our team.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    Future.delayed(const Duration(seconds: 4), () {
      if (_pageController.hasClients) {
        final nextPage = (_currentPage + 1) % _slides.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        if (mounted) {
          setState(() => _currentPage = nextPage);
        }
        _startAutoPlay();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 120,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: AppColors.promoBannerGold,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -20,
                top: -20,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.promoCircleGold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _slides.length,
                  onPageChanged: (index) {
                    if (mounted) setState(() => _currentPage = index);
                  },
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _slides[index]['title']!,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.navy,
                            fontFamily: 'DM Sans',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _slides[index]['subtitle']!,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.navy,
                            fontFamily: 'DM Sans',
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_slides.length, (index) {
            final isActive = _currentPage == index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: isActive ? 18 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.gold
                    : AppColors.gold.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }
}
