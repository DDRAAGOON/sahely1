import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../widgets/branding.dart';
import '../../../widgets/buttons.dart';
import '../../../widgets/image.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;

  final List<Map<String, String>> _slides = [
    {
      'image': 'https://images.unsplash.com/photo-1765288116127-3c5a76fa2ba6?w=1200&q=75&auto=format&fit=crop',
      'title': 'Find Your Perfect Stay',
      'subtitle': 'Discover luxury villas, chalets, and beachfront properties.',
    },
    {
      'image': 'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=1200&q=75&auto=format&fit=crop',
      'title': 'Book with Confidence',
      'subtitle': 'Verified listings and secure payments for a chaos-free experience.',
    },
    {
      'image': 'https://images.unsplash.com/photo-1499793983690-e29da59ef1c2?w=1200&q=75&auto=format&fit=crop',
      'title': 'Enjoy Your Vacation',
      'subtitle': 'Experience luxury like never before with our premium services.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (_currentPage < _slides.length - 1) {
        _currentPage++;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushNamed(context, '/role');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
                if (page == _slides.length - 1) {
                  _timer?.cancel();
                }
              },
              itemCount: _slides.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    SizedBox(
                      height: 460,
                      width: double.infinity,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          SahelyImage(
                            imageUrl: _slides[index]['image']!,
                            showFade: true,
                            fadeHeight: 300,
                            enableViewer: false,
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: SafeArea(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 12, right: 16),
                                child: GestureDetector(
                                  onTap: () => Navigator.pushNamed(context, '/role'),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: AppColors.navy.withValues(alpha: 0.35),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text('Skip',
                                        style: AppTheme.dm(size: 13, weight: FontWeight.w600, color: AppColors.white)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(_slides[index]['title']!,
                        style: AppTheme.dm(size: 22, weight: FontWeight.w700, color: AppColors.navy)),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(_slides[index]['subtitle']!,
                          textAlign: TextAlign.center, style: AppTheme.dm(size: 15, color: AppColors.muted, height: 1.5)),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 22),
          ProgressDots(count: _slides.length, active: _currentPage),
          const SizedBox(height: 40),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(28, 0, 28, 40),
              child: GoldButton(
                label: _currentPage == _slides.length - 1 ? 'Get Started' : 'Next',
                onTap: _onNext,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
