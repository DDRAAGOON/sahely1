import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sahely/core/navigation/app_navigation.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/ui.dart';
import 'package:sahely/l10n/app_localizations.dart';
import 'package:sahely/core/theme/system_ui.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;

  List<Map<String, String>> _getSlides(AppLocalizations l) => [
        {
          'image':
              'https://images.unsplash.com/photo-1765288116127-3c5a76fa2ba6?w=1200&q=75&auto=format&fit=crop',
          'title': l.obTitle1,
          'subtitle': l.obSub1,
        },
        {
          'image':
              'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=1200&q=75&auto=format&fit=crop',
          'title': l.obTitle2,
          'subtitle': l.obSub2,
        },
        {
          'image':
              'https://images.unsplash.com/photo-1499793983690-e29da59ef1c2?w=1200&q=75&auto=format&fit=crop',
          'title': l.obTitle3,
          'subtitle': l.obSub3,
        },
      ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (_currentPage < 2) {
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
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      AppNavigation.goToRoleSelection(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final slides = _getSlides(l);

    return LightStatusBar(
      child: Scaffold(
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
                  if (page == slides.length - 1) {
                    _timer?.cancel();
                  }
                },
                itemCount: slides.length,
                itemBuilder: (context, index) {
                  return LayoutBuilder(
                    builder: (context, constraints) => SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        child: Column(
                          children: [
                            SizedBox(
                              // Full artwork on regular phones; shorter on small ones so the
// title and description stay visible.
                              height: (constraints.maxHeight - 150)
                                  .clamp(240.0, 460.0)
                                  .toDouble(),
                              width: double.infinity,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  SahelyImage(
                                    imageUrl: slides[index]['image']!,
                                    showFade: true,
                                    fadeHeight: 300,
                                    enableViewer: false,
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: SafeArea(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 12, right: 16),
                                        child: GestureDetector(
                                          onTap: () =>
                                              AppNavigation.goToRoleSelection(
                                                  context),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 14, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: AppColors.navy
                                                  .withValues(alpha: 0.35),
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            child: Text(l.skip,
                                                style: AppTheme.dm(
                                                    size: 13,
                                                    weight: FontWeight.w600,
                                                    color: AppColors.white)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(slides[index]['title']!,
                                style: AppTheme.dm(
                                    size: 22,
                                    weight: FontWeight.w700,
                                    color: AppColors.navy)),
                            const SizedBox(height: 10),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 32),
                              child: Text(slides[index]['subtitle']!,
                                  textAlign: TextAlign.center,
                                  style: AppTheme.dm(
                                      size: 15,
                                      color: AppColors.muted,
                                      height: 1.5)),
                            ),
                          ],
                        )),
                  );
                },
              ),
            ),
            const SizedBox(height: 22),
            ProgressDots(count: slides.length, active: _currentPage),
            const SizedBox(height: 40),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(28, 0, 28, 40),
                child: Builder(builder: (context) {
                  final l = AppLocalizations.of(context);
                  return GoldButton(
                    label: _currentPage == 2 ? l.getStarted : l.next,
                    onTap: _onNext,
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
